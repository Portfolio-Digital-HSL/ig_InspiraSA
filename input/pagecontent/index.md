# Guia de Implementação InspiraSA - Sumário de Alta

Guia de Implementação FHIR **R4 (4.0.1)** do Sumário de Alta hospitalar (Portaria SAES/MS nº 701/2022). Substitui o SA-IG legado da RNDS (`br.gov.saude.sa.fhir`, canonical `http://www.saude.gov.br/fhir/r4/...`), que herda do CMD, pelo uso direto dos perfis do **BR-Core 1.3.0**.

> Status `draft`. Proposta técnica para deliberação; não é especificação oficial da RNDS.

## Por que refatorar

O SA-IG da RNDS foi construído como um modelo próprio, à parte do BR-Core:

- **Herança errada.** O BRSumarioAlta herda do BRConjuntoMinimoDados (CMD), não do BR-Core, sob o canonical antigo `http://www.saude.gov.br/fhir/r4` e sem `dependsOn` do BR-Core. Nada que evolui no BR-Core chega ao SA-IG.
- **Restrições herdadas do CMD.** A maior parte das restrições do cabeçalho vem do CMD: documento sem identificador, sem atestação, sem custodiante e sem confidencialidade; título fixo "Conjunto Mínimo de Dados"; modalidade assistencial em `category`; paciente e autor só por identificador; `Composition.encounter` proibido.
- **Seções inválidas.** As seções não têm `code` nem `text` e são fatiadas pelo perfil de `entry.resolve()`, com uma seção por entrada. Contra o BR-Core, o documento não valida.
- **Remodelagem do que o FHIR já tem.** O contato assistencial vira seção em vez de `Composition.encounter`; o resumo da evolução vai num ClinicalImpression só para texto; a prescrição passa por uma Composition intermediária; os status do HL7, de binding required no R4, são recriados em CodeSystems nacionais; extensões duplicam elementos nativos (turno, intervalo entre doses, equipe, paciente não identificado).
- **Terminologia fechada e não resolvível.** Manifestação de alergia só em MedDRA, função do executante em CBO, URLs `www.saude.gov.br` que não resolvem.
- **Sem modelo lógico.** A página de modelo de informação do SA-IG está vazia, copiada do RIA-R.

O próprio `br-core-sumarioalta` 1.3.0 não aceita instância válida (AC-01, AC-02). A solução foi tirar o documento do BR-Core: a composição do Sumário de Alta passa ao perfil RNDS, sobre o `br-core-composition`.

## Princípio

A RNDS se ajusta aos perfis do BR-Core. Onde o BR-Core não tem perfil, usa as especificações internacionais do HL7 (para o documento, o [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/)) e, na falta delas, o recurso canônico do FHIR R4. Perfis próprios da RNDS, como os do SA-IG, deixam de existir.

## Perfis RNDS: o documento é da RNDS, os recursos são do BR-Core

Documento clínico é caso de uso, não core. Nenhum core nacional consultado (US, AU, CA, FR) define documentos clínicos, e o CH Core só define a Composition e o Bundle genéricos; os documentos suíços, como os de vacinação (CH VACD), são guias próprios que dependem do core. Por isso o Sumário de Alta deixou o BR-Core: o `br-core-sumarioalta` e o `br-core-registroatendimentoclinico` foram retirados do `main` do BR-Core, e a composição do documento é definida aqui, sobre o `br-core-composition`.

O perfil do documento mantém o nome do SA-IG, `BRSumarioAlta`; muda só a herança: deriva do `br-core-composition`, e não mais do `BRConjuntoMinimoDados` (CMD).

| Perfil RNDS | Deriva de | O que define |
|---|---|---|
| [BRSumarioAlta](StructureDefinition-BRSumarioAlta.html) (Composition) | `br-core-composition`, impondo `clinical-document-composition` | O documento: as sete seções (LOINC, perfis do BR-Core nas entradas) e as regras do Sumário de Alta |
| [rnds-internacao](StructureDefinition-rnds-internacao.html) (Encounter) | `br-core-encounter` | A internação encerrada, com resumo da evolução e alta |
| [rnds-documento-sumarioalta](StructureDefinition-rnds-documento-sumarioalta.html) (Bundle) | `clinical-document-bundle`; `br-core-bundle-documento` quando publicado | O documento para envio |

Os perfis RNDS não criam elementos, extensões, ValueSets nem CodeSystems. Diagnósticos, alergias, procedimentos, prescrição, plano de cuidados, capacidade funcional, paciente, profissional e estabelecimento usam os perfis do BR-Core sem restrição adicional. A [declaração de capacidades](CapabilityStatement-rnds-servidor-sumarioalta.html) do servidor da RNDS aponta o perfil do Bundle aceito.

A diferença para o SA-IG: o SA-IG tinha perfis paralelos, sobre o CMD, que não recebiam as evoluções do BR-Core. Os perfis RNDS herdam do BR-Core e mudam com ele. O mesmo modelo vale para o RAC e para o RIA (comprovante de vacinação).

O guia para implementadores está em [Implementação na RNDS](implementacao-rnds.html).

## Como foi feito

1. **Comparação dos snapshots em duas camadas.** CMD × `br-core-composition` e BRSumarioAlta × `br-core-sumarioalta`, elemento a elemento, com FHIR R4, BR-Core 1.3.0 e BR-Core corrigido, registrando a origem de cada restrição. O resultado é o [Mapa de estrutura](mapa-estrutura.html) e a planilha `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx`, cotejada com a planilha anterior do repositório sa-ig.
2. **Modelo lógico.** Os elementos de dados do Sumário de Alta foram reconstruídos dos perfis do SA-IG no [modelo lógico SumarioAltaML](StructureDefinition-sumario-alta-ml.html), mapeado para o BR-Core e para o SA-IG.
3. **Documento na RNDS, recursos do BR-Core.** O documento é o `BRSumarioAlta`, sobre o `br-core-composition`; cada perfil de recurso do SA-IG foi substituído pelo do BR-Core (`br-core-encounter`, `br-core-condition`, `br-core-allergyintolerance`, `br-core-procedure`, `br-core-medicationrequest`, `br-core-careplan`, `br-core-capacidadefuncional`). Seções sem equivalente foram para o Encounter da internação. As regras que o BR-Core não impõe viraram três perfis RNDS derivados e uma declaração de capacidades.
4. **Documento conforme ao HL7 internacional.** Composition e Bundle seguem também o `clinical-document-composition` e o `clinical-document-bundle` do FHIR Clinical Documents 1.0.1 (categoria LOINC 107903-7, atestador legal, `identifier` e `timestamp` do Bundle).
5. **Correção do BR-Core.** Branch `fix/sumarioalta-capacidadefuncional` do repositório br.org.hl7.fhir.core: discriminador `pattern` em `section.code`, LOINC `http://loinc.org`, `br-core-capacidadefuncional` revisto e o novo perfil `br-core-bundle-documento`. Com a correção, os exemplos validam sem erro.
6. **Terminologia.** Status pelos ValueSets do HL7 com suplementos pt-BR; alérgenos em SNOMED CT com CBARA (tipo e substância), manifestações em SNOMED CT com o mapa MedDRA → SNOMED CT; procedimentos pelo `BRProcedimentosNacionais` (Tabela SUS e TUSS 22). Os mapas CBARA → SNOMED CT foram revisados no OCL. As terminologias novas ficam na pasta `terminologia/`, para o OCL e o guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`), não neste guia. Ver [Terminologia](terminologia.html).
7. **Validação.** Exemplos validados com o validador FHIR e o IG Publisher contra o BR-Core 1.3.0, o BR-Core corrigido e o FHIR Clinical Documents. Resultado: 0 erros (ver [Estrutura do documento](estrutura.html)).
8. **Débitos e recomendações.** Cada divergência do `BRSumarioAlta` virou um débito técnico com grau e a correção feita ([Débitos técnicos](debitos-tecnicos.html)) e as mudanças propostas à RNDS e ao BR-Core ([Recomendações](recomendacoes-rnds.html)).

## O que este guia contém

- o que os implementadores enviam à RNDS e como validar ([Implementação na RNDS](implementacao-rnds.html));
- como preencher o Sumário de Alta com os perfis do BR-Core ([Estrutura do documento](estrutura.html));
- o modelo lógico e o mapa elemento a elemento entre SA-IG, BR-Core e R4 ([Mapa de estrutura](mapa-estrutura.html));
- onde foi parar cada seção, perfil e extensão do SA-IG ([Mapeamento SA-IG](mapeamento-sa.html));
- os débitos técnicos do SA-IG e do BR-Core e o que propor;
- exemplos validados, incluindo o documento completo (Bundle `document`).

## Leitura recomendada

1. [Implementação na RNDS](implementacao-rnds.html)
1. [Estrutura do documento](estrutura.html)
2. [Mapa de estrutura](mapa-estrutura.html) e [modelo lógico](StructureDefinition-sumario-alta-ml.html)
3. [Mapeamento SA-IG](mapeamento-sa.html)
4. [Débitos técnicos](debitos-tecnicos.html) e [Recomendações à RNDS](recomendacoes-rnds.html)
5. [Transição e convivência](transicao.html)

### Dependências

{% include dependency-table.xhtml %}

### Análise entre versões do FHIR

{% include cross-version-analysis.xhtml %}

### Propriedade intelectual

{% include ip-statements.xhtml %}
