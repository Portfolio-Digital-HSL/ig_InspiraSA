# Terminologia

Todas as terminologias são referenciadas pela URL do guia de terminologia (`https://terminologia.saude.gov.br/fhir/...`). As novas ficam na pasta `terminologia/` do repositório, com JSON FHIR e o arquivo de importação do OCL; não são publicadas por este IG.

## Status: ValueSets do HL7 com suplementos pt-BR

O SA-IG criou CodeSystems nacionais que eram traduções dos códigos do HL7 (status de condição, alergia, procedimento, plano). Como esses elementos têm binding **required** no FHIR R4, os códigos nacionais não são conformes. O BR-Core já usa os ValueSets do HL7; este guia e publica a tradução como **CodeSystem supplement** (`content = supplement`), com uma designação `pt-BR` por código.

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

## Alergias: SNOMED CT e CBARA

O CBARA tem 152 códigos nacionais no OCL (`MS/BRAlergenosCBARA`), todos mapeados para SNOMED CT na Source `gps` (153 mapeamentos, conferidos em 06/10/2026). O agente da alergia vai em SNOMED CT, e o código CBARA pode ir junto no mesmo `code`, porque os dois são equivalentes (SAME-AS).

- **BRAlergenosSNOMEDNacional**: SNOMED CT (descendentes de 105590001 Substance e 373873005 Pharmaceutical / biologic product) + BRAlergenosCBARA + BRMedicamento + BRImunobiologico. Usado como coding adicional; o BR-Core não liga este ValueSet.
- O BR-Core mantém `AllergyIntolerance.code` required em **BRAlergenos**, que não tem SNOMED CT. Enquanto isso não mudar, envie também um coding de BRAlergenos (BRMedicamento, BRImunobiologico ou CBARA). Ver débito AC-06.

### Tipo e substância

O modelo de informação da RNDS tem dois elementos: o tipo do agente e a substância. O CBARA mistura os dois níveis numa lista sem hierarquia: `cereal`, `leguminosa`, `fruta-citrica`, `contato-metal`, `polen` e `grao` são tipos; `trigo`, `feijao`, `grao-soja`, `laranja`, `lima`, `niquel` e `polen-grama` são substâncias.

No FHIR, tipo e substância não cabem juntos em `AllergyIntolerance.code`: os codings de um CodeableConcept têm de ser equivalentes. A regra deste guia:

- `code` leva a substância, com CBARA e SNOMED CT (exemplo: `grao-soja` e 256355007 *Glycine max*);
- quando a substância não é conhecida, `code` leva o tipo (exemplo: `grao` e 264331002 Grain);
- `category` leva a categoria do HL7 (food, medication, environment, biologic);
- o tipo de uma substância vem da hierarquia do CBARA, que precisa ser criada no OCL (débito AC-12).

### Decisões de mapeamento (05 e 06/10/2026)

| CBARA | SNOMED CT | Observação |
|---|---|---|
| `lima` | 1285547006 *Citrus X latifolia* | limão-taiti (lima ácida Tahiti), sinônimo Seedless lime |
| `grama` | 422304003 Family Poaceae (organism) | contato com a planta; o SNOMED CT não tem substância Grass; o pólen é `polen-grama` (256277009) |
| `contato-metal` | 767098004 Metal and/or metal compound | tipo; as substâncias são `niquel`, `cobre`, `ferro` etc. |
| `grao` | 264331002 Grain | tipo; a substância é `grao-soja` |
| `glutamato` | 430503006 Glutamate | |
| `sepia` | 726759005 Cuttlefish | antes duplicava `lula` (735006003 Squid) |
| `veneno-vespa` | 256440004 Wasp venom | mapeamento recriado (298); o anterior levava ao 260176001 Kiwi fruit |
| `outro-agente-substancia` | 105590001 Substance | categoria de resto |

## Manifestações: SNOMED CT, com MedDRA aceito

O MedDRA é usado pela Anvisa na farmacovigilância; o padrão clínico é o SNOMED CT.

- **BRManifestacaoReacaoSNOMED**: SNOMED CT, descendentes de 404684003 Clinical finding. O BR-Core liga `reaction.manifestation` ao BRReacoesAdversasMedDRA como `example`, o que permite SNOMED CT; proposta: `preferred` SNOMED CT.
- MedDRA (BRMedDRA) vai como coding adicional quando o emissor o tiver.
- **ConceptMap BRMedDRAParaSNOMED**: forma FHIR dos 28 mapeamentos SAME-AS que existem no OCL, na Source MS/BRMedDRA, para SNOMED CT (`/orgs/SNOMED/sources/gps/`). Todos os códigos do BRMedDRA estão mapeados.

## Procedimentos: SIGTAP e TUSS 22

**BRProcedimentosNacionais** (mesmo nome e canonical do guia de terminologia), em nova versão proposta: Tabela SUS inteira (BRTabelaSUS, `MS/BRTabelaSUS` no OCL) e TUSS 22 inteira (`https://fhir.ans.gov.br/CodeSystem/tuss-22`, `ANS/tabela-22` no OCL). O BR-Core liga `Procedure.code` ao BRProcedimentosNacionais como `example`; proposta: `extensible`. No OCL (`MS/BRProcedimentosNacionais-1.0`) a coleção já referencia a BRTabelaSUS inteira e a TUSS 22, mas as referências da TUSS apontam para uma Source inexistente; o guia de terminologia enumera só 1000 códigos TUSS 22 (débito AC-08).

O BRCBHPMTUSS sai do ValueSet. A CBHPM fica de fora: é propriedade da AMB, de uso licenciado e pago, e não está no OCL.

## Capacidade funcional: SNOMED CT

**BRCapacidadeFuncional**: SNOMED CT, descendentes de 118228005 Functional finding. Proposto para `br-core-capacidadefuncional.code` (preferred) na correção do BR-Core. Hoje a 1.3.0 exige CID-10 (`BRTerminologiaSuspeitaDiagnostica`, required); o exemplo envia os dois.

## Outras ligações

| Elemento | Terminologia |
|---|---|
| Condition.code | BRCID10 (preferred) |
| Procedure.performer.function | performer-role (SNOMED CT), não CBO |
| MedicationRequest.medication | br-core-medication com BRMedicamento |
| MedicationRequest.dosageInstruction.route | medicine-route-of-administration do IPS (EDQM), herdado do BR-Core |
| CarePlan.activity.detail.code | BRSubgrupoTabelaSUS (required, herdado do BR-Core) |
