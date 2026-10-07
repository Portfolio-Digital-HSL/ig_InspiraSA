# IG InspiraSA: Sumário de Alta

Guia de Implementação FHIR **R4 (4.0.1)** do Sumário de Alta hospitalar (Portaria SAES/MS nº 701/2022). Refatora o SA-IG legado da RNDS (`br.gov.saude.sa.fhir`) sobre os perfis do **BR-Core**.

Status `draft`, versão 0.1.0. Proposta técnica para deliberação; não é especificação oficial da RNDS.

Autoria: Jussara Macedo Pinho Rötzsch (HL7 Brasil / Hospital Sírio-Libanês, projeto INSPIRA, PROADI-SUS).

## Princípio

A RNDS se ajusta aos perfis do BR-Core. Onde o BR-Core não tem perfil, usa a especificação internacional do HL7 (para o documento, o [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/) 1.0.1) e, na falta dela, o recurso canônico do FHIR R4.

Defeitos do BR-Core são corrigidos no repositório do BR-Core ([HL7-BR/br.org.hl7.fhir.core](https://github.com/HL7-BR/br.org.hl7.fhir.core)), não contornados aqui. Para os implementadores da RNDS, o guia tem três perfis RNDS que só restringem o BR-Core e o FHIR Clinical Documents (`rnds-documento-sumarioalta`, `BRSumarioAlta`, `rnds-internacao`) e a declaração de capacidades do servidor da RNDS (`rnds-servidor-sumarioalta`).

## Por que refatorar

- O BRSumarioAlta herda do BRConjuntoMinimoDados (CMD), não do BR-Core, sob o canonical `http://www.saude.gov.br/fhir/r4` e sem `dependsOn` do BR-Core.
- O CMD proíbe identificador, atestação, custodiante e `Composition.encounter`, fixa o título e põe a modalidade assistencial em `category`.
- As seções não têm `code` nem `text` e são fatiadas por `entry.resolve()`: o documento não valida contra o BR-Core.
- O SA-IG remodela o que o FHIR já tem (contato assistencial como seção, ClinicalImpression só para texto, Composition intermediária na prescrição, status do HL7 recriados em CodeSystems nacionais, extensões que duplicam elementos nativos).
- O modelo de informação publicado no SA-IG está vazio.

## Como foi feito

1. Comparação dos snapshots em duas camadas: CMD × `br-core-composition` e BRSumarioAlta × `br-core-sumarioalta`, com FHIR R4, BR-Core 1.3.0 e BR-Core corrigido.
2. Modelo lógico SumarioAltaML reconstruído dos perfis do SA-IG, com mapeamento para o BR-Core e para o SA-IG.
3. Substituição de cada perfil do SA-IG pelo do BR-Core; as seções sem equivalente vão para o Encounter da internação.
4. Composition e Bundle conformes também ao `clinical-document-composition` e ao `clinical-document-bundle`.
5. Correção do BR-Core no `main` do repositório do HL7 Brasil (commit 9cf1bc9).
6. Terminologia pelos ValueSets do HL7 com suplementos pt-BR, SNOMED CT com CBARA e MedDRA, `BRProcedimentosNacionais` (Tabela SUS e TUSS 22). Mapas revisados no OCL.
7. Validação com o validador FHIR e o IG Publisher.

## Perfis usados

| Conteúdo | Perfil |
|---|---|
| Documento | `BRSumarioAlta` (deriva de `br-core-composition`, impõe `clinical-document-composition`; define as sete seções) |
| Envio | `rnds-documento-sumarioalta` (deriva de `clinical-document-bundle`; de `br-core-bundle-documento` quando publicado) |
| Internação | `rnds-internacao` (deriva de `br-core-encounter`) |
| Diagnósticos | `br-core-condition` |
| Alergias e intolerâncias | `br-core-allergyintolerance` |
| Procedimentos | `br-core-procedure` |
| Prescrição de alta | `br-core-medicationrequest` + `br-core-medication` |
| Plano de cuidados | `br-core-careplan` |
| Capacidade funcional | `br-core-capacidadefuncional` |
| Paciente, profissional, estabelecimento | `br-core-patient`, `br-core-practitioner`, `br-core-organization` |

## Correções propostas ao BR-Core

No `main` do [br.org.hl7.fhir.core](https://github.com/HL7-BR/br.org.hl7.fhir.core), sobre a 1.4.1:

| Débito | Correção |
|---|---|
| D-41 | `br-core-sumarioalta` e `br-core-registroatendimentoclinico` retirados: documentos são casos de uso da RNDS (D-01 deixa de existir) |
| D-02 | LOINC com o canonical `http://loinc.org` (era `https://loinc.org/`) |
| D-04 | `br-core-capacidadefuncional` revisto (`code` com o ValueSet `BRCapacidadeFuncional`; `subject.identifier` e `stage` deixam de ser obrigatórios; `category` sem binding nacional) |
| D-39 | `br-core-composition`: `section.code` com o ValueSet `doc-section-codes` como example, como no R4 e no IPS; códigos de seção do IPS onde o IPS tem a seção |
| novo | `br-core-bundle-documento` (Bundle `document`) |

O guia depende do BR-Core **1.3.0** e não usa mais o `br-core-sumarioalta`: o QA do IG Publisher dá 0 erros. Com o `main` do BR-Core, os exemplos também validam sem erro.

## Conteúdo do repositório

| Caminho | Conteúdo |
|---|---|
| `input/fsh/profiles/` | Perfis RNDS (`rnds-documento-sumarioalta`, `BRSumarioAlta`, `rnds-internacao`): só restrições sobre o BR-Core e o FHIR Clinical Documents |
| `input/fsh/capacidades/` | CapabilityStatement do servidor da RNDS (`rnds-servidor-sumarioalta`) |
| `input/fsh/instances/` | Exemplos: internação por insuficiência cardíaca (documento completo e Bundle) e colecistectomia (seções vazias com `emptyReason`) |
| `input/fsh/logicos/` | Modelo lógico SumarioAltaML, com mapeamentos para o BR-Core e o SA-IG |
| `input/pagecontent/` | Páginas: Início, Estrutura do documento, Terminologia, Mapeamento SA-IG, Mapa de estrutura, Débitos técnicos, Recomendações à RNDS, Transição |
| `comparativo/` | Planilha `comparativo_sumarioalta_rnds_brcore.xlsx`: as duas camadas elemento a elemento, débitos e cotejo com a planilha anterior do sa-ig. Fonte do Mapa de estrutura |
| `scripts/` | `gerar_modelo_logico.py` (modelo lógico e `modelo_logico.json`) e `gerar_mapa_estrutura.py` (página Mapa de estrutura). Rodar nessa ordem, na raiz |
| `terminologia/` | Suplementos pt-BR, ValueSets e ConceptMaps para o OCL e o guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`). Não são publicados por este guia. Ver `terminologia/README.md` |
| `json/` | Exemplos em JSON (`exemplos/`, `exemplos-inspirasa.zip`), o modelo lógico (`modelo-logico/`), os perfis RNDS em JSON (`perfis-rnds/`) e `inspirasa-json.zip` (guia publicado e terminologia). Ver `json/LEIA-ME.md` |

## Dependências

| Pacote | Versão |
|---|---|
| `br.gov.saude.br-core.fhir` | 1.3.0 |
| `hl7.fhir.uv.fhir-clinical-document` | 1.0.1 |
| `hl7.fhir.r4.core` | 4.0.1 |

## Build

Pré-requisitos: Node.js 20 ou superior, Java 17 ou superior, Ruby com Jekyll. O SUSHI (3.20.1) é instalado pelo `npm install`.

```bash
npm install
npm run fsh      # só o SUSHI: fsh-generated/resources
npm run build    # SUSHI + IG Publisher: output/
```

O `publisher.jar` fica em `~/.fhir/tools/publisher/` (baixe com `./_build.sh update` ou da [página de releases](https://github.com/HL7/fhir-ig-publisher/releases/latest)).

Para regenerar o modelo lógico e o Mapa de estrutura depois de alterar a planilha ou a lista de elementos:

```bash
python3 scripts/gerar_modelo_logico.py
python3 scripts/gerar_mapa_estrutura.py   # requer openpyxl
```

`fsh-generated/`, `output/`, `temp/`, `input-cache/` e `template/` são gerados e não são versionados.

## Pendências

- Publicação da correção do BR-Core e troca da dependência para a nova versão.
- Decisões no BR-Core: CPF 1..1 no `br-core-patient` (D-03), `dosageInstruction` (D-05), alérgenos sem SNOMED CT (D-06).
- Hierarquia do CBARA no OCL (D-37) e referências da TUSS 22 na `BRProcedimentosNacionais`.
- Definição oficial de `id` e `canonical` do guia (hoje `br.org.hsl.inspirasa` e `http://fhir.hsl.org.br/ig/inspirasa`, provisórios).
