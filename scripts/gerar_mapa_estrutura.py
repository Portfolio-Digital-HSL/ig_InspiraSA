# Gera input/pagecontent/mapa-estrutura.md a partir de
#   comparativo/comparativo_sumarioalta_rnds_brcore.xlsx
#   scripts/modelo_logico.json (gerado por scripts/gerar_modelo_logico.py)
# Uso (na raiz do repositório): python3 scripts/gerar_mapa_estrutura.py
# Autoria: Jussara Macedo Pinho Rötzsch
import json, collections
import openpyxl

XLSX = 'comparativo/comparativo_sumarioalta_rnds_brcore.xlsx'
wb = openpyxl.load_workbook(XLSX, read_only=True)
E = json.load(open('scripts/modelo_logico.json', encoding='utf-8'))


def c(v):
    if v is None or v == '':
        return ''
    return str(v).replace('|', '\\|').replace('\n', ' ')


def cb(card, bind):
    card, bind = c(card), c(bind)
    if card and bind:
        return f'{card} · {bind}'
    return card or bind


def short(p):
    return p.replace('Composition.section:', 'section:').replace('Composition.', '')


def rows(name):
    ws = wb[name]
    it = ws.iter_rows(values_only=True)
    head = next(it)
    return head, [r for r in it if any(r)]


o = []
w = o.append
w('# Mapa de estrutura\n')
w('Este mapa mostra onde cada elemento do Sumário de Alta da RNDS (SA-IG) está no BR-Core e o que diverge. '
  'É gerado da planilha `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx` e do modelo lógico '
  '[SumarioAltaML](StructureDefinition-sumario-alta-ml.html) pelo script `scripts/gerar_mapa_estrutura.py`; '
  'para alterar, edite a planilha ou o modelo e gere de novo.\n')

w('## Herança comparada\n')
w('| Modelo | Cadeia |\n|---|---|')
w('| SA-IG da RNDS | BRSumarioAlta → BRConjuntoMinimoDados-1.1 (CMD) → Composition (R4); canonical `http://www.saude.gov.br/fhir/r4`, sem dependência do BR-Core |')
w('| BR-Core 1.3.0 | br-core-sumarioalta → br-core-composition → Composition (R4); o br-core-sumarioalta foi retirado do `main` do BR-Core |')
w('| Este guia | BRSumarioAlta → br-core-composition → Composition (R4); o CMD sai da cadeia. Documento em rnds-documento-sumarioalta |')
w('')
w('O comparativo tem duas camadas: o **documento-base** (CMD × br-core-composition) e o **Sumário de Alta** '
  '(BRSumarioAlta × br-core-sumarioalta, cabeçalho e seções). As colunas trazem a cardinalidade e o binding no '
  'FHIR R4, no SA-IG, no BR-Core 1.3.0 publicado e no BR-Core corrigido (`main` do HL7-BR, commit 9cf1bc9, ainda sem nova versão do pacote).\n')

w('### Legenda\n')
w('| Conformidade | Significado |\n|---|---|')
w('| Não conforme | O SA-IG proíbe o que o BR-Core exige, permite omitir o que ele exige, permite mais ocorrências ou usa outro ValueSet onde o BR-Core é required |')
w('| Divergente | Restrições diferentes que, sozinhas, não impedem a validação |')
w('| Conforme | Mesma cardinalidade e mesmas restrições |')
w('| Sem equivalente | O elemento existe só em um dos modelos |')
w('')
w('Grau do débito: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; '
  '**Médio** gera ambiguidade; **Baixo** é ajuste de documentação. A lista completa está em [Débitos técnicos](debitos-tecnicos.html).\n')

# 1. Modelo lógico
w('## Modelo lógico → BR-Core → SA-IG\n')
w('O SA-IG publica uma página de modelo de informação vazia, copiada do modelo do RIA-R (AC-13). '
  'O [modelo lógico do Sumário de Alta](StructureDefinition-sumario-alta-ml.html) reconstrói os elementos de dados '
  'do documento, independentes de tecnologia, e mapeia cada um para o elemento do BR-Core usado neste guia e para o '
  'do SA-IG. Os mesmos mapeamentos estão na aba *Mappings* do modelo.\n')
comfilhos = {x[0].split('.')[0] for x in E if '.' in x[0]}
grupo = None
for p, card, tipo, nome, defi, brc, saig in E:
    g = p.split('.')[0]
    if g != grupo:
        if grupo is not None:
            w('')
        grupo = g
        if '.' not in p:
            w(f'### {nome} (`{p}`, {card})\n')
            w(f'BR-Core: {c(brc)}. SA-IG: {c(saig)}.\n')
            if g not in comfilhos:
                continue
            w('| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |\n|---|---|---|---|---|---|')
            continue
    w(f'| `{p}` | {card} | {tipo} | {c(nome)} | {c(brc)} | {c(saig)} |')
w('')

# 2. CMD x br-core-composition
h, R = rows('CMD × br-core-composition')
cnt = collections.Counter(r[10] for r in R)
w('## Documento-base: CMD × br-core-composition\n')
w(f'{len(R)} elementos comparados: ' + ', '.join(f'{v} {k.lower()}' for k, v in cnt.most_common()) +
  '. A tabela mostra só os que não são conformes; os demais estão na planilha. '
  'Quase todas as restrições do cabeçalho do SA-IG vêm daqui.\n')
w('| Elemento | R4 | CMD | br-core-composition 1.3.0 | Conformidade | Observação |\n|---|---|---|---|---|---|')
for r in R:
    if r[10] == 'Conforme':
        continue
    cmd = cb(r[4], r[6]) + (' · MS' if r[5] else '')
    brc = cb(r[7], r[9]) + (' · MS' if r[8] else '')
    w(f'| `{short(r[0])}` | {cb(r[2], r[3])} | {cmd} | {brc} | {c(r[10])} | {c(r[1])} |')
w('')

# 3. Cabeçalho
h, R = rows('Composition')
w('## Sumário de Alta: cabeçalho (BRSumarioAlta × br-core-sumarioalta)\n')
w('| Elemento | R4 | SA-IG | BR-Core 1.3.0 | BR-Core corrigido | Conformidade | Grau | Origem no SA-IG | Recomendação |\n|---|---|---|---|---|---|---|---|---|')
for r in R:
    el = short(r[0]) if r[0] and r[0] != '—' else short(r[1])
    w(f'| `{el}` | {cb(r[2], r[3])} | {cb(r[4], r[6])} | {cb(r[7], r[9])} | {cb(r[10], r[11])} | {c(r[12])} | {c(r[13])} | {c(r[16])} | {c(r[15])} |')
w('')

# 4. Seções
h, R = rows('Seções')
w('## Sumário de Alta: seções\n')
w('O SA-IG tem nove seções, fatiadas pelo perfil de `entry.resolve()`; o BR-Core tem sete, fatiadas por `code` (LOINC). '
  'Três seções do SA-IG não têm equivalente no BR-Core e vão para o Encounter da internação (`Composition.encounter`). '
  'O binding de `section.code` é o ValueSet `doc-section-codes`, com códigos do CodeSystem LOINC (`http://loinc.org`). '
  'No BR-Core 1.3.0 é required e três códigos de seção (42347-5, 8654-6 e 54522-8) não estão no ValueSet; no BR-Core corrigido é example, como no R4 e no IPS, '
  'e a capacidade funcional usa o código do IPS, 47420-5 (AC-14).\n')
w('| Seção no BR-Core | Seção no SA-IG | SA-IG card. | BR-Core card. | Conformidade | Grau | Observação |\n|---|---|---|---|---|---|---|')
secs = [r for r in R if ((r[0] or '—') if (r[0] or '—') != '—' else r[1]).count('.') == 1]
for r in secs:
    b = short(r[0]) if r[0] and r[0] != '—' else '—'
    s = short(r[1]) if r[1] and r[1] != '—' else '—'
    w(f'| {b} | {s} | {c(r[4])} | {c(r[7])} | {c(r[12])} | {c(r[13])} | {c(r[14])} |')
w('')
w('### Subelementos das seções\n')
w('Sem as linhas das três seções que só existem no SA-IG (todas sem equivalente).\n')
w('| Elemento (BR-Core) | Elemento (SA-IG) | SA-IG | BR-Core 1.3.0 | BR-Core corrigido | Conformidade | Grau | Origem no SA-IG |\n|---|---|---|---|---|---|---|---|')
for r in R:
    if r in secs:
        continue
    if (not r[0] or r[0] == '—') and r[12] == 'Sem equivalente no BR-Core':
        continue
    b = f'`{short(r[0])}`' if r[0] and r[0] != '—' else '—'
    s = f'`{short(r[1])}`' if r[1] and r[1] != '—' else '—'
    w(f'| {b} | {s} | {cb(r[4], r[6])} | {cb(r[7], r[9])} | {cb(r[10], r[11])} | {c(r[12])} | {c(r[13])} | {c(r[16])} |')
w('')

# 5. Planilhas e cotejo
w('## Planilhas\n')
w('| Planilha | Conteúdo |\n|---|---|')
w('| `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx` (este repositório) | Fonte deste mapa: as duas camadas elemento a elemento, a partir dos snapshots, com FHIR R4, BR-Core 1.3.0, BR-Core corrigido e a origem de cada restrição; débitos e cotejo com a planilha anterior. |')
w('| `comparativo_sa.xlsx` (repositório sa-ig, pasta `Claude outputs`) | Seções do SA-IG × br-core-sumarioalta, cinco recursos clínicos (Condition, AllergyIntolerance, Procedure, MedicationRequest, CarePlan) elemento a elemento e inventário dos 24 perfis do SA-IG, a partir do JSON do SA-IG e do FSH do BR-Core. |')
w('')
h, R = rows('Cotejo com comparativo_sa')
w('### Cotejo entre as duas planilhas\n')
w('| Tema | Planilha anterior | Este comparativo | Situação | Encaminhamento |\n|---|---|---|---|---|')
for r in R:
    w('| ' + ' | '.join(c(x) for x in r[:5]) + ' |')
w('')
open('input/pagecontent/mapa-estrutura.md', 'w', encoding='utf-8', newline='\n').write('\n'.join(o))
print(len(o), 'linhas')
