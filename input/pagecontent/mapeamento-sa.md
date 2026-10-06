# Mapeamento SA-IG

Correspondência entre os artefatos do SA-IG (`http://www.saude.gov.br/fhir/r4/StructureDefinition/...`) e os perfis do BR-Core usados por este guia. Fonte: comparativo SA-IG x BR-Core (planilha `comparativo_sabr-core.xlsx`).

## Seções do documento

| SA-IG (9 seções) | BR-Core (`br-core-sumarioalta`) |
|---|---|
| informacoesContatoAssistencial (BRContatoAssistencial-1.0) | `Composition.encounter` → br-core-encounter |
| problemasDiagnosticosAvaliados (BRProblemaDiagnostico) | duas seções: diagnosticosAdmissao (42347-5) e diagnosticosAvaliados (57852-6) |
| resumoEvolucaoClinica (BRResumoEvolucaoClinica, ClinicalImpression) | `Encounter.text` |
| alergiaReacaoAdversa (BRAlergiaReacaoAdversa-1.0) | alergiasIntolerancias → br-core-allergyintolerance |
| procedimentosRealizados (BRProcedimentoRealizado-1.0) | procedimentosRealizados → br-core-procedure |
| prescricaoAlta (BRRegistroPrescricaoMedicamento → BRPrescricaoMedicamento) | prescricaoAlta → br-core-medicationrequest, sem Composition intermediária |
| planoCuidados (BRPlanoCuidados-1.0) | planoCuidados → br-core-careplan |
| restricaoFuncionalIncapacidadeSaude (0..1) | capacidadeFuncional (1..1) → br-core-capacidadefuncional |
| informacoesAdicionais (BROutrasInformacoes) | Internação (`Encounter`); sem seção própria |

## Perfis e extensões

| SA-IG | BR-Core | Ação |
|---|---|---|
| BRSumarioAlta, BRConjuntoMinimoDados-1.1 | br-core-sumarioalta | substitui |
| BRContatoAssistencial-1.0 | br-core-encounter | substitui |
| BRProblemaDiagnostico | br-core-condition | substitui |
| BRAlergiaReacaoAdversa-1.0 | br-core-allergyintolerance | substitui |
| BRProcedimentoRealizado-1.0 | br-core-procedure | substitui |
| BRPrescricaoMedicamento | br-core-medicationrequest | substitui |
| BRRegistroPrescricaoMedicamento | — | descontinua |
| BRMedicamento | br-core-medication | substitui |
| BRPlanoCuidados-1.0 | br-core-careplan | substitui |
| BRRestricaoFuncionalIncapacidadeSaude-1.0 | br-core-capacidadefuncional | substitui |
| BRResumoEvolucaoClinica | `Encounter.text` | descontinua |
| BRLocalAtendimento-1.0 | br-core-location | substitui |
| BRObservacaoDescritiva-1.0 | br-core-observation | substitui |
| BRIndividuoNaoIdentificado-1.0 (unidentifiedPatient) | br-core-patient com CNS provisório | descontinua |
| BRIdentificacaoEquipe-1.0 (healthcareTeam) | `Encounter.participant`, `Procedure.performer` ou CareTeam | descontinua |
| BRTurno | `Timing.repeat.when` | descontinua |
| BRIntervaloDoses | `Timing.repeat.period` + `periodUnit` | descontinua |
| BROcupacao-1.0 | `Practitioner.qualification` / PractitionerRole (CBO) | descontinua como extensão |
| BRQuantidade-1.0 | — (fora do escopo; avaliar uso) | pendente |
| BRFinanciamento-1.0 | fora do Sumário de Alta (camada financeira: AIH no InspiraRIRA) | pendente |
| BRCodigoSerialMedicamento | — | pendente |

## Elementos com mudança de regra

| Elemento | SA-IG | BR-Core + regra de preenchimento deste guia |
|---|---|---|
| Composition.identifier | 0..0 (CMD) | identifier do documento; Bundle com identifier persistente |
| Composition.attester | 0..0 (CMD) | atestador legal (clinical-document-composition) |
| Composition.custodian | 0..0 (CMD) | estabelecimento (CNES) |
| Composition.title | fixo "Conjunto Mínimo de Dados" (CMD) | livre ("Sumário de Alta") |
| Composition.category | modalidade assistencial, required (CMD) | LOINC 107903-7 Clinical note |
| Composition.subject / author | só identifier, sem reference (CMD) | reference a br-core-patient / br-core-practitioner |
| Composition.section.code / text / emptyReason | 0..0 | LOINC por seção, narrativa, emptyReason |
| Composition.encounter | 0..0 | 0..1 no BR-Core; preenchimento obrigatório por este guia |
| Composition.section | sem cardinalidade total | 7..7, cada seção 1..1 (BR-Core); entry ou emptyReason (regra deste guia) |
| Condition.code | BRProblemaDiagnostico, URL www.saude.gov.br | BRCID10 (preferred), URL terminologia.saude.gov.br |
| Condition/AllergyIntolerance/CarePlan/Procedure status | CodeSystems nacionais required | ValueSets HL7 required + suplementos pt-BR |
| AllergyIntolerance.code | BRAlergenos (URL antiga) | BRAlergenos (BR-Core) + coding SNOMED CT ou CBARA |
| AllergyIntolerance.reaction.manifestation | MedDRA required, max 1 | SNOMED CT (BR-Core: example MedDRA), MedDRA como coding adicional |
| Procedure.code | BRProcedimentosNacionais (URL antiga) | BRProcedimentosNacionais, nova versão: BRTabelaSUS + TUSS 22 (extensible) |
| Procedure.identifier | número de autorização (type AUTH) | identificador do registro; autorização fica na camada financeira |
| Procedure.performer.function | CBO | performer-role (SNOMED CT) |
| MedicationRequest.medication[x] | CodeableConcept texto livre (BRPrescricaoNaoEstruturada) | medicationReference para br-core-medication (regra de preenchimento) |
| MedicationRequest.dosageInstruction.route | BRViaAdministracao required | IPS/EDQM (herdado do BR-Core) |
| MedicationRequest.category | — | discharge |
| CarePlan.activity, CarePlan.goal | 0..0 | activity 1..* (BR-Core) |
| *.subject.extension[unidentifiedPatient] | 0..* | não existe |
