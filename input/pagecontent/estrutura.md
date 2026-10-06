# Estrutura do documento

O Sumário de Alta usa os perfis do **BR-Core 1.3.0**, com três perfis RNDS que só os restringem ([Implementação na RNDS](implementacao-rnds.html)); onde o BR-Core não tem perfil, os do [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/) 1.0.1 (HL7 internacional) e, na falta deles, o recurso canônico do FHIR R4; o guia diz como preenchê-los e registra o que precisa mudar no BR-Core.

O documento é enviado como **Bundle `document`** conforme ao `rnds-documento-sumarioalta` (derivado do `clinical-document-bundle`): a Composition (`rnds-sumarioalta`, derivado do `br-core-sumarioalta`, e `clinical-document-composition`) é a primeira entrada, seguida de todos os recursos referenciados. Ver o exemplo [documento-sumario-alta-ic](Bundle-documento-sumario-alta-ic.html).

## Perfis usados

| Conteúdo | Perfil BR-Core | Antes, no SA-IG |
|---|---|---|
| Documento | `rnds-sumarioalta` (deriva de `br-core-sumarioalta`, que herda de `br-core-composition`) e `clinical-document-composition` | BRSumarioAlta, sobre BRConjuntoMinimoDados (CMD) |
| Internação | `rnds-internacao` (deriva de `br-core-encounter`) | BRContatoAssistencial-1.0 (seção própria) |
| Diagnósticos | `br-core-condition` | BRProblemaDiagnostico |
| Alergias e intolerâncias | `br-core-allergyintolerance` | BRAlergiaReacaoAdversa-1.0 |
| Procedimentos | `br-core-procedure` | BRProcedimentoRealizado-1.0 |
| Prescrição de alta | `br-core-medicationrequest` + `br-core-medication` | BRRegistroPrescricaoMedicamento → BRPrescricaoMedicamento |
| Plano de cuidados | `br-core-careplan` | BRPlanoCuidados-1.0 |
| Capacidade funcional | `br-core-capacidadefuncional` | BRRestricaoFuncionalIncapacidadeSaude-1.0 |
| Paciente, profissional, estabelecimento | `br-core-patient`, `br-core-practitioner`, `br-core-organization` | BRIndividuo, extensões próprias |
| Equipe | `br-core-careteam`, quando necessária | BRIdentificacaoEquipe-1.0 (extensão) |
| Documento para envio | `rnds-documento-sumarioalta` (deriva de `clinical-document-bundle`; de `br-core-bundle-documento` quando publicado) | — |

## Seções

O `br-core-sumarioalta` exige as sete seções (`section` 7..7, cada uma 1..1).

| Fatia | LOINC | Entradas |
|---|---|---|
| diagnosticosAdmissao | 42347-5 | br-core-condition |
| alergiasIntolerancias | 48765-2 | br-core-allergyintolerance |
| diagnosticosAvaliados | 57852-6 | br-core-condition |
| procedimentosRealizados | 47519-4 | br-core-procedure |
| prescricaoAlta | 8654-6 | br-core-medicationrequest |
| planoCuidados | 18776-5 | br-core-careplan |
| capacidadeFuncional | 54522-8 | br-core-capacidadefuncional |

## Regras de preenchimento

O BR-Core não impõe as regras abaixo; elas são orientação deste guia e estão propostas ao BR-Core em [Recomendações](recomendacoes-rnds.html).

| Elemento | Regra |
|---|---|
| `Composition.type` | LOINC 18842-5 Discharge summary |
| `Composition.meta.profile` | `rnds-sumarioalta` e `clinical-document-composition` |
| `Composition.category` | LOINC 107903-7 Clinical note (exigido pelo `clinical-document-composition`; o `br-core-sumarioalta` aceita uma categoria) |
| `Composition.attester` | atestador legal (`mode = legal`) com data, profissional responsável pela alta |
| `Bundle` | `clinical-document-bundle`: `identifier` (system e value), `timestamp` maior ou igual a `Composition.date`, Composition como primeira entrada |
| `Composition.encounter` | DEVE referenciar a internação (substitui a seção informacoesContatoAssistencial) |
| `Composition.custodian` | DEVE ser o estabelecimento (CNES) |
| `Composition.section` | cada seção DEVE ter `entry` ou `emptyReason` (`list-empty-reason`: nilknown, notasked, unavailable). Ver [sumario-alta-colecistectomia](Composition-sumario-alta-colecistectomia.html) |
| `Encounter.text` | resumo da evolução clínica (substitui o ClinicalImpression do SA-IG) |
| `Encounter.period.end` | data da alta, DEVE estar presente |
| `Encounter.hospitalization.dischargeDisposition` | motivo da alta (BRMotivoDesfecho) |
| `Encounter.diagnosis.use` | AD (admissão), DD (alta), CC (comorbidade) |
| `Encounter.participant.type` | `alta`, `admissao`, `atendimento` (BRResponsabilidadeParticipante); substitui BRIdentificacaoEquipe |
| `AllergyIntolerance.code` | coding SNOMED CT (ou CBARA) mais um coding de BRAlergenos, exigido pelo BR-Core |
| `AllergyIntolerance.reaction.manifestation` | SNOMED CT; MedDRA como coding adicional |
| `Procedure.code` | BRProcedimentosNacionais: Tabela SUS ou TUSS 22 |
| `Procedure.performer.function` | performer-role (SNOMED CT), não CBO |
| `MedicationRequest.category` | `discharge` |
| `MedicationRequest.medication[x]` | `medicationReference` para br-core-medication; prescrição não estruturada em `Medication.code.text` |
| `MedicationRequest.dosageInstruction.timing` | `repeat.when` (turno) e `repeat.period`/`periodUnit` (intervalo); substituem BRTurno e BRIntervaloDoses |
| `*.subject` / `patient` | sempre br-core-patient; sem a extensão unidentifiedPatient |

## Validação

O `br-core-sumarioalta` 1.3.0 não aceita nenhuma instância válida (débitos [D-01 e D-02](debitos-tecnicos.html)): o discriminador `profile` em `section.code` faz cada seção casar com todas as fatias, e o sistema fixado como `https://loinc.org/` não é o canonical do CodeSystem LOINC (`http://loinc.org`), de onde vêm os códigos do ValueSet `doc-section-codes`. Esse binding é required no `br-core-composition` 1.3.0, e três códigos de seção (42347-5, 8654-6, 54522-8) não estão no ValueSet (D-39); no `main` do BR-Core o binding passa a example, como no IPS. Os exemplos de Composition seguem o perfil e acusam esses erros até a correção no BR-Core. A correção está no `main` do repositório do BR-Core (HL7-BR, 9cf1bc9); com ela, e com `http://loinc.org` nas seções, a Composition e o Bundle validam sem erro contra o `br-core-sumarioalta` e o FHIR Clinical Documents. Os demais exemplos validam. No IG Publisher (06/10/2026, BR-Core 1.3.0) são 209 erros, todos nas duas Compositions e no Bundle, e todos causados por D-01 e D-02. Os perfis do FHIR Clinical Documents não acrescentam erros: as Compositions e o Bundle conformam a eles.
