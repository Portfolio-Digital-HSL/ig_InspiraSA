# Terminologia

Todas as terminologias são referenciadas pela URL do guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`). As novas ficam na pasta `terminologia/` do repositório, com JSON FHIR e o arquivo de importação do OCL; não são publicadas por este IG.

## Status: ValueSets do HL7 com suplementos pt-BR

O SA-IG criou CodeSystems nacionais que eram traduções dos códigos do HL7 (status de condição, alergia, procedimento, plano). Como esses elementos têm binding **required** no FHIR R4, os códigos nacionais não são conformes. Este guia usa os ValueSets do HL7 e publica a tradução como **CodeSystem supplement** (`content = supplement`), com uma designação `pt-BR` por código.

| Suplemento | Suplementa | Uso |
|---|---|---|
| BRSuplementoCondicaoClinica | condition-clinical | Condition.clinicalStatus |
| BRSuplementoCondicaoVerificacao | condition-ver-status | Condition.verificationStatus |
| BRSuplementoCategoriaCondicao | condition-category | Condition.category |
| BRSuplementoAlergiaClinica | allergyintolerance-clinical | AllergyIntolerance.clinicalStatus |
| BRSuplementoAlergiaVerificacao | allergyintolerance-verification | AllergyIntolerance.verificationStatus |
| BRSuplementoAlergiaTipo | allergy-intolerance-type | AllergyIntolerance.type |
| BRSuplementoAlergiaCategoria | allergy-intolerance-category | AllergyIntolerance.category |
| BRSuplementoAlergiaCriticidade | allergy-intolerance-criticality | AllergyIntolerance.criticality |
| BRSuplementoGravidadeReacao | reaction-event-severity | AllergyIntolerance.reaction.severity |
| BRSuplementoSituacaoEvento | event-status | Procedure.status |
| BRSuplementoSituacaoPrescricao | medicationrequest-status | MedicationRequest.status |
| BRSuplementoIntencaoPrescricao | medicationrequest-intent | MedicationRequest.intent |
| BRSuplementoSituacaoRequisicao | request-status | CarePlan.status |
| BRSuplementoIntencaoRequisicao | request-intent | CarePlan.intent |
| BRSuplementoSituacaoAtividadePlano | care-plan-activity-status | CarePlan.activity.detail.status |
| BRSuplementoSituacaoDocumento | composition-status | Composition.status |
| BRSuplementoMotivoSecaoVazia | list-empty-reason | Composition.section.emptyReason |

O sistema emissor envia o código do HL7; o display em português vem do suplemento no servidor de terminologia.

## Alergias: SNOMED CT

O CBARA tem códigos nacionais, cada um mapeado (SAME-AS) para um conceito SNOMED CT no OCL. Por isso o agente da alergia é codificado em SNOMED CT, e o código CBARA pode ir junto:

- **BRAlergenosSNOMEDNacional**: SNOMED CT (descendentes de 105590001 Substance e 373873005 Pharmaceutical / biologic product) + BRAlergenosCBARA + BRMedicamento + BRImunobiologico. Ligado como `preferred` na fatia `code.coding[snomed]`.
- O BR-Core mantém `AllergyIntolerance.code` required em **BRAlergenos**, que não tem SNOMED CT. Enquanto isso não mudar, envie também um coding de BRAlergenos (BRMedicamento, BRImunobiologico ou CBARA). Ver débito D-06.

## Manifestações: SNOMED CT, com MedDRA aceito

O MedDRA é usado pela Anvisa na farmacovigilância; o padrão clínico é o SNOMED CT.

- **BRManifestacaoReacaoSNOMED**: SNOMED CT, descendentes de 404684003 Clinical finding. Ligado como `preferred` em `reaction.manifestation` (o BR-Core tem só `example` para MedDRA).
- MedDRA (BRMedDRA) vai como coding adicional quando o emissor o tiver.
- **ConceptMap BRMedDRAParaSNOMED**: forma FHIR dos 25 mapeamentos SAME-AS que já existem no OCL, na Source MS/BRMedDRA, para SNOMED CT (`/orgs/SNOMED/sources/gps/`). O único código do BRMedDRA sem mapeamento no OCL, Angioedema (10002424), recebe aqui a proposta 41291007 Angioedema.

## Procedimentos: SIGTAP e TUSS 22

**BRProcedimentosNacionais** (mesmo nome e canonical do guia de terminologia), em nova versão proposta: Tabela SUS inteira (BRTabelaSUS, `MS/BRTabelaSUS` no OCL) e TUSS 22 inteira (`https://fhir.ans.gov.br/CodeSystem/tuss-22`, `ANS/tabela-22` no OCL). Ligado como `extensible` em `Procedure.code`. Hoje o guia de terminologia enumera 1000 códigos TUSS 22 e o OCL (`MS/BRProcedimentosNacionais-1.0`) tem 25 códigos da BRTabelaSUS (débito D-08).

O BRCBHPMTUSS sai do ValueSet. A CBHPM fica de fora: é propriedade da AMB, de uso licenciado e pago, e não está no OCL.

## Outras ligações

| Elemento | Terminologia |
|---|---|
| Condition.code | BRCID10 (preferred) |
| Procedure.performer.function | performer-role (SNOMED CT), não CBO |
| MedicationRequest.medication | br-core-medication com BRMedicamento |
| MedicationRequest.dosageInstruction.route | medicine-route-of-administration do IPS (EDQM), herdado do BR-Core |
| CarePlan.activity.detail.code | BRSubgrupoTabelaSUS (required, herdado do BR-Core) |
