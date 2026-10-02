# Mapeamento SA-IG

Correspondência entre os artefatos do SA-IG (`http://www.saude.gov.br/fhir/r4/StructureDefinition/...`) e este guia. Fonte: comparativo SA-IG x BR-Core (planilha `comparativo_sabr-core.xlsx`).

## Seções do documento

| SA-IG (9 seções) | Este guia |
|---|---|
| informacoesContatoAssistencial (BRContatoAssistencial-1.0) | `Composition.encounter` → [InternacaoSumarioAlta](StructureDefinition-internacao-sumario-alta.html) |
| problemasDiagnosticosAvaliados (BRProblemaDiagnostico) | duas seções: diagnosticosAdmissao (42347-5) e diagnosticosAvaliados (57852-6) |
| resumoEvolucaoClinica (BRResumoEvolucaoClinica, ClinicalImpression) | `Encounter.text` |
| alergiaReacaoAdversa (BRAlergiaReacaoAdversa-1.0) | alergiasIntolerancias → [AlergiaSumarioAlta](StructureDefinition-alergia-sumario-alta.html) |
| procedimentosRealizados (BRProcedimentoRealizado-1.0) | procedimentosRealizados → [ProcedimentoSumarioAlta](StructureDefinition-procedimento-sumario-alta.html) |
| prescricaoAlta (BRRegistroPrescricaoMedicamento → BRPrescricaoMedicamento) | prescricaoAlta → [PrescricaoAltaSumarioAlta](StructureDefinition-prescricao-alta-sumario-alta.html), sem Composition intermediária |
| planoCuidados (BRPlanoCuidados-1.0) | planoCuidados → [PlanoCuidadosSumarioAlta](StructureDefinition-plano-cuidados-sumario-alta.html) |
| restricaoFuncionalIncapacidadeSaude (0..1) | capacidadeFuncional (1..1) → br-core-capacidadefuncional |
| informacoesAdicionais (BROutrasInformacoes) | Internação (`Encounter`); sem seção própria |

## Perfis e extensões

| SA-IG | Este guia / BR-Core | Ação |
|---|---|---|
| BRSumarioAlta, BRConjuntoMinimoDados-1.1 | [SumarioAlta](StructureDefinition-sumario-alta.html) sobre br-core-sumarioalta | substitui |
| BRContatoAssistencial-1.0 | InternacaoSumarioAlta sobre br-core-encounter | substitui |
| BRProblemaDiagnostico | DiagnosticoSumarioAlta sobre br-core-condition | substitui |
| BRAlergiaReacaoAdversa-1.0 | AlergiaSumarioAlta sobre br-core-allergyintolerance | substitui |
| BRProcedimentoRealizado-1.0 | ProcedimentoSumarioAlta sobre br-core-procedure | substitui |
| BRPrescricaoMedicamento | PrescricaoAltaSumarioAlta sobre br-core-medicationrequest | substitui |
| BRRegistroPrescricaoMedicamento | — | descontinua |
| BRMedicamento | br-core-medication | substitui |
| BRPlanoCuidados-1.0 | PlanoCuidadosSumarioAlta sobre br-core-careplan | substitui |
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

| Elemento | SA-IG | Este guia |
|---|---|---|
| Composition.encounter | 0..0 | 1..1 MS |
| Composition.section | sem cardinalidade total | 7..7, cada seção 1..1 com entry ou emptyReason |
| Condition.code | BRProblemaDiagnostico, URL www.saude.gov.br | BRCID10 (preferred), URL terminologia.saude.gov.br |
| Condition/AllergyIntolerance/CarePlan/Procedure status | CodeSystems nacionais required | ValueSets HL7 required + suplementos pt-BR |
| AllergyIntolerance.code | BRAlergenos (URL antiga) | BRAlergenos (BR-Core) + coding SNOMED CT (BRAlergenosSNOMEDNacional) |
| AllergyIntolerance.reaction.manifestation | MedDRA required, max 1 | SNOMED CT preferred, 0..*, MedDRA como coding adicional |
| Procedure.code | BRProcedimentosNacionais (URL antiga) | BRProcedimentosNacionais, nova versão: BRTabelaSUS + TUSS 22 (extensible) |
| Procedure.identifier | número de autorização (type AUTH) | identificador do registro; autorização fica na camada financeira |
| Procedure.performer.function | CBO | performer-role (SNOMED CT) |
| MedicationRequest.medication[x] | CodeableConcept texto livre (BRPrescricaoNaoEstruturada) | Reference(br-core-medication) (invariante pa-1) |
| MedicationRequest.dosageInstruction.route | BRViaAdministracao required | IPS/EDQM (herdado do BR-Core) |
| MedicationRequest.category | — | discharge, fixo |
| CarePlan.activity, CarePlan.goal | 0..0 | activity 1..* (BR-Core) |
| *.subject.extension[unidentifiedPatient] | 0..* | não existe |
