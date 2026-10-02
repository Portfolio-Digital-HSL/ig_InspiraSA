# Guia de Implementação InspiraSA - Sumário de Alta

Guia de Implementação FHIR **R4 (4.0.1)** do Sumário de Alta hospitalar (Portaria GM/MS nº 701/2022). Substitui o SA-IG legado da RNDS (`br.gov.saude.sa.fhir`, canonical `http://www.saude.gov.br/fhir/r4/...`) por perfis derivados do **BR-Core 1.3.0**.

> Status `draft`. Proposta técnica para deliberação; não é especificação oficial da RNDS.

## Por que refatorar

O SA-IG deriva direto dos recursos-base do FHIR, sob um canonical antigo e sem `dependsOn` do BR-Core. Nada que evolui no BR-Core chega ao SA-IG. Ao mesmo tempo, o SA-IG:

- zera elementos nativos (`Composition.encounter`) e os reimplementa como seções com perfil próprio;
- usa um ClinicalImpression só para carregar texto livre do resumo da evolução;
- prescreve por meio de uma Composition intermediária (`BRRegistroPrescricaoMedicamento`);
- recria em CodeSystems nacionais os status do HL7, que já têm binding required no R4;
- tem extensões sem necessidade: paciente não identificado, turno, intervalo entre doses e equipe.

## O que este guia faz

- Documento [SumarioAlta](StructureDefinition-sumario-alta.html) com as **sete seções** do `br-core-sumarioalta`, cada uma com entradas ou `emptyReason`.
- Resumo da evolução, contato assistencial e informações adicionais levados para a [Internação](StructureDefinition-internacao-sumario-alta.html) (`Composition.encounter`).
- Perfis por seção derivados do BR-Core: [Diagnóstico](StructureDefinition-diagnostico-sumario-alta.html), [Alergia](StructureDefinition-alergia-sumario-alta.html), [Procedimento](StructureDefinition-procedimento-sumario-alta.html), [Prescrição de Alta](StructureDefinition-prescricao-alta-sumario-alta.html), [Plano de Cuidados](StructureDefinition-plano-cuidados-sumario-alta.html). A capacidade funcional usa o `br-core-capacidadefuncional` sem especialização.
- Status pelos ValueSets do HL7, com designações em português em suplementos do guia de terminologia.
- Alérgenos e manifestações em SNOMED CT (base do CBARA), com códigos nacionais e MedDRA aceitos.
- Procedimentos pelo `BRProcedimentosNacionais`, com proposta de nova versão que reúne Tabela SUS (SIGTAP) e TUSS 22.

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
