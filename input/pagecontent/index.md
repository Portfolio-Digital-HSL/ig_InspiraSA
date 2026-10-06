# Guia de Implementação InspiraSA - Sumário de Alta

Guia de Implementação FHIR **R4 (4.0.1)** do Sumário de Alta hospitalar (Portaria GM/MS nº 701/2022). Substitui o SA-IG legado da RNDS (`br.gov.saude.sa.fhir`, canonical `http://www.saude.gov.br/fhir/r4/...`), que herda do CMD, pelo uso direto dos perfis do **BR-Core 1.3.0**.

> Status `draft`. Proposta técnica para deliberação; não é especificação oficial da RNDS.

## Por que refatorar

O SA-IG da RNDS foi construído como um modelo próprio, à parte do BR-Core:

- **Herança errada.** O BRSumarioAlta herda do BRConjuntoMinimoDados (CMD), não do BR-Core, sob o canonical antigo `http://www.saude.gov.br/fhir/r4` e sem `dependsOn` do BR-Core. Nada que evolui no BR-Core chega ao SA-IG.
- **Restrições herdadas do CMD.** A maior parte das restrições do cabeçalho vem do CMD: documento sem identificador, sem atestação, sem custodiante e sem confidencialidade; título fixo "Conjunto Mínimo de Dados"; modalidade assistencial em `category`; paciente e autor só por identificador; `Composition.encounter` proibido.
- **Seções inválidas.** As seções não têm `code` nem `text` e são fatiadas pelo perfil de `entry.resolve()`, com uma seção por entrada. Contra o BR-Core, o documento não valida.
- **Remodelagem do que o FHIR já tem.** O contato assistencial vira seção em vez de `Composition.encounter`; o resumo da evolução vai num ClinicalImpression só para texto; a prescrição passa por uma Composition intermediária; os status do HL7, de binding required no R4, são recriados em CodeSystems nacionais; extensões duplicam elementos nativos (turno, intervalo entre doses, equipe, paciente não identificado).
- **Terminologia fechada e não resolvível.** Manifestação de alergia só em MedDRA, função do executante em CBO, URLs `www.saude.gov.br` que não resolvem.
- **Sem modelo lógico.** A página de modelo de informação do SA-IG está vazia, copiada do RIA-R.

O próprio `br-core-sumarioalta` 1.3.0 também não aceita instância válida (D-01, D-02). Por isso a refatoração corrige o BR-Core em vez de contorná-lo.

## Princípio

A RNDS se ajusta aos perfis do BR-Core. Onde o BR-Core não tem perfil, usa as especificações internacionais do HL7 (para o documento, o [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/)) e, na falta delas, o recurso canônico do FHIR R4. Perfis próprios da RNDS, como os do SA-IG, deixam de existir.

## Por que este guia não tem perfis

Nenhum perfil, extensão, ValueSet ou CodeSystem precisou ser criado neste guia. O conteúdo do Sumário de Alta é coberto assim:

| Necessidade | Onde está |
|---|---|
| Documento e seções | `br-core-sumarioalta` (BR-Core), conforme também ao `clinical-document-composition` (FHIR Clinical Documents) |
| Envio do documento | `clinical-document-bundle` (FHIR Clinical Documents); `br-core-bundle-documento`, criado no BR-Core |
| Internação, diagnósticos, alergias, procedimentos, prescrição, plano de cuidados, capacidade funcional | perfis do BR-Core (`br-core-encounter`, `br-core-condition`, `br-core-allergyintolerance`, `br-core-procedure`, `br-core-medicationrequest`, `br-core-careplan`, `br-core-capacidadefuncional`) |
| Paciente, profissional, estabelecimento | `br-core-patient`, `br-core-practitioner`, `br-core-organization` |
| Status em português | suplementos pt-BR dos CodeSystems do HL7, no guia de terminologia |
| Alérgenos, manifestações, procedimentos, capacidade funcional | ValueSets e ConceptMaps no guia de terminologia e no OCL |

O que estava errado ou faltava foi corrigido na origem, no repositório do BR-Core ([HL7-BR/br.org.hl7.fhir.core](https://github.com/HL7-BR/br.org.hl7.fhir.core)): fatiamento e códigos das seções, LOINC, binding de `section.code`, `br-core-capacidadefuncional` e o novo `br-core-bundle-documento`. Um perfil próprio aqui repetiria o erro do SA-IG: uma camada nacional paralela que não recebe as evoluções do BR-Core.

Por isso o código FSH deste guia tem só exemplos (`input/fsh/instances/`) e o modelo lógico (`input/fsh/logicos/`). As regras que o BR-Core ainda não impõe estão em [Estrutura do documento](estrutura.html), como regras de preenchimento, e em [Recomendações](recomendacoes-rnds.html), como mudanças propostas ao BR-Core.

## Como foi feito

1. **Comparação dos snapshots em duas camadas.** CMD × `br-core-composition` e BRSumarioAlta × `br-core-sumarioalta`, elemento a elemento, com FHIR R4, BR-Core 1.3.0 e BR-Core corrigido, registrando a origem de cada restrição. O resultado é o [Mapa de estrutura](mapa-estrutura.html) e a planilha `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx`, cotejada com a planilha anterior do repositório sa-ig.
2. **Modelo lógico.** Os elementos de dados do Sumário de Alta foram reconstruídos dos perfis do SA-IG no [modelo lógico SumarioAltaML](StructureDefinition-sumario-alta-ml.html), mapeado para o BR-Core e para o SA-IG.
3. **Perfis do BR-Core, sem perfis próprios.** Cada perfil do SA-IG foi substituído pelo do BR-Core (`br-core-sumarioalta`, `br-core-encounter`, `br-core-condition`, `br-core-allergyintolerance`, `br-core-procedure`, `br-core-medicationrequest`, `br-core-careplan`, `br-core-capacidadefuncional`). Seções sem equivalente foram para o Encounter da internação.
4. **Documento conforme ao HL7 internacional.** Composition e Bundle seguem também o `clinical-document-composition` e o `clinical-document-bundle` do FHIR Clinical Documents 1.0.1 (categoria LOINC 107903-7, atestador legal, `identifier` e `timestamp` do Bundle).
5. **Correção do BR-Core.** Branch `fix/sumarioalta-capacidadefuncional` do repositório br.org.hl7.fhir.core: discriminador `pattern` em `section.code`, LOINC `http://loinc.org`, `br-core-capacidadefuncional` revisto e o novo perfil `br-core-bundle-documento`. Com a correção, os exemplos validam sem erro.
6. **Terminologia.** Status pelos ValueSets do HL7 com suplementos pt-BR; alérgenos em SNOMED CT com CBARA (tipo e substância), manifestações em SNOMED CT com o mapa MedDRA → SNOMED CT; procedimentos pelo `BRProcedimentosNacionais` (Tabela SUS e TUSS 22). Os mapas CBARA → SNOMED CT foram revisados no OCL. As terminologias novas ficam na pasta `terminologia/`, para o OCL e o guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`), não neste guia. Ver [Terminologia](terminologia.html).
7. **Validação.** Exemplos validados com o validador FHIR e o IG Publisher contra o BR-Core 1.3.0, o BR-Core corrigido e o FHIR Clinical Documents. Os erros restantes vêm só de D-01 e D-02 do BR-Core 1.3.0 (ver [Estrutura do documento](estrutura.html)).
8. **Débitos e recomendações.** Cada divergência virou um débito técnico com grau e tratamento ([Débitos técnicos](debitos-tecnicos.html)) e as mudanças propostas à RNDS e ao BR-Core ([Recomendações](recomendacoes-rnds.html)).

## O que este guia contém

- como preencher o Sumário de Alta com os perfis do BR-Core ([Estrutura do documento](estrutura.html));
- o modelo lógico e o mapa elemento a elemento entre SA-IG, BR-Core e R4 ([Mapa de estrutura](mapa-estrutura.html));
- onde foi parar cada seção, perfil e extensão do SA-IG ([Mapeamento SA-IG](mapeamento-sa.html));
- os débitos técnicos do SA-IG e do BR-Core e o que propor;
- exemplos validados, incluindo o documento completo (Bundle `document`).

## Leitura recomendada

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
