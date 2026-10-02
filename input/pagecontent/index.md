# Guia de Implementação InspiraSA - Sumário de Alta

Guia de Implementação FHIR **R4 (4.0.1)** do Sumário de Alta hospitalar (Portaria GM/MS nº 701/2022). Substitui o SA-IG legado da RNDS (`br.gov.saude.sa.fhir`, canonical `http://www.saude.gov.br/fhir/r4/...`), que herda do CMD, pelo uso direto dos perfis do **BR-Core 1.3.0**.

> Status `draft`. Proposta técnica para deliberação; não é especificação oficial da RNDS.

## Por que refatorar

O SA-IG deriva direto dos recursos-base do FHIR, sob um canonical antigo e sem `dependsOn` do BR-Core. Nada que evolui no BR-Core chega ao SA-IG. Ao mesmo tempo, o SA-IG:

- zera elementos nativos (`Composition.encounter`) e os reimplementa como seções com perfil próprio;
- usa um ClinicalImpression só para carregar texto livre do resumo da evolução;
- prescreve por meio de uma Composition intermediária (`BRRegistroPrescricaoMedicamento`);
- recria em CodeSystems nacionais os status do HL7, que já têm binding required no R4;
- tem extensões sem necessidade: paciente não identificado, turno, intervalo entre doses e equipe.

## Princípio

A RNDS se ajusta aos perfis do BR-Core. Onde o BR-Core não tem perfil, usa as especificações internacionais do HL7 (para o documento, o [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/)) e, na falta delas, o recurso canônico do FHIR R4. Perfis próprios da RNDS, como os do SA-IG, deixam de existir.

## O que este guia faz

Não cria perfis: usa os do **BR-Core 1.3.0** (`br-core-sumarioalta` e os perfis de cada seção) e documenta:

- como preencher o Sumário de Alta com esses perfis ([Estrutura do documento](estrutura.html));
- onde foi parar cada seção, perfil e extensão do SA-IG ([Mapeamento SA-IG](mapeamento-sa.html));
- os defeitos do BR-Core e do SA-IG ([Débitos técnicos](debitos-tecnicos.html)) e o que propor ([Recomendações](recomendacoes-rnds.html));
- exemplos validados contra os perfis do BR-Core, incluindo o documento completo (Bundle `document`).

Resumo da evolução, contato assistencial e informações adicionais vão para o Encounter da internação (`Composition.encounter`). Status usam os ValueSets do HL7, com designações em português em suplementos. Alérgenos e manifestações em SNOMED CT, com CBARA e MedDRA. Procedimentos pelo `BRProcedimentosNacionais` (Tabela SUS e TUSS 22).

As terminologias novas **não** estão neste guia: ficam na pasta `terminologia/` do repositório, para o OCL e o guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`). Ver [Terminologia](terminologia.html).

## Leitura recomendada

1. [Estrutura do documento](estrutura.html)
2. [Mapeamento SA-IG](mapeamento-sa.html)
3. [Débitos técnicos](debitos-tecnicos.html) e [Recomendações à RNDS](recomendacoes-rnds.html)
4. [Transição e convivência](transicao.html)

### Dependências

{% include dependency-table.xhtml %}

### Análise entre versões do FHIR

{% include cross-version-analysis.xhtml %}

### Propriedade intelectual

{% include ip-statements.xhtml %}
