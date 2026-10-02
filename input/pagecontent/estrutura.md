# Estrutura do documento

Este guia não cria perfis. O Sumário de Alta usa os perfis do **BR-Core 1.3.0** como estão; onde o BR-Core não tem perfil, os do [FHIR Clinical Documents](https://hl7.org/fhir/uv/fhir-clinical-document/STU1.0.1/) 1.0.1 (HL7 internacional) e, na falta deles, o recurso canônico do FHIR R4; o guia diz como preenchê-los e registra o que precisa mudar no BR-Core.

O documento é enviado como **Bundle `document`** conforme ao `clinical-document-bundle`: a Composition (`br-core-sumarioalta` e `clinical-document-composition`) é a primeira entrada, seguida de todos os recursos referenciados. Ver o exemplo [documento-sumario-alta-ic](Bundle-documento-sumario-alta-ic.html).

## Perfis usados

| Conteúdo | Perfil BR-Core | Antes, no SA-IG |
|---|---|---|
| Documento | `br-core-sumarioalta` (herda de `br-core-composition`) e `clinical-document-composition` | BRSumarioAlta, sobre BRConjuntoMinimoDados (CMD) |
| Internação | `br-core-encounter` | BRContatoAssistencial-1.0 (seção própria) |
| Diagnósticos | `br-core-condition` | BRProblemaDiagnostico |
| Alergias e intolerâncias | `br-core-allergyintolerance` | BRAlergiaReacaoAdversa-1.0 |
| Procedimentos | `br-core-procedure` | BRProcedimentoRealizado-1.0 |
| Prescrição de alta | `br-core-medicationrequest` + `br-core-medication` | BRRegistroPrescricaoMedicamento → BRPrescricaoMedicamento |
| Plano de cuidados | `br-core-careplan` | BRPlanoCuidados-1.0 |
| Capacidade funcional | `br-core-capacidadefuncional` | BRRestricaoFuncionalIncapacidadeSaude-1.0 |
| Paciente, profissional, estabelecimento | `br-core-patient`, `br-core-practitioner`, `br-core-organization` | BRIndividuo, extensões próprias |
| Equipe | `br-core-careteam`, quando necessária | BRIdentificacaoEquipe-1.0 (extensão) |
| Documento para envio | `clinical-document-bundle` (FHIR Clinical Documents); o BR-Core não tem perfil de Bundle | — |

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
| `Composition.meta.profile` | `br-core-sumarioalta` e `clinical-document-composition` |
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

O `br-core-sumarioalta` 1.3.0 não aceita nenhuma instância válida (débitos [D-01 e D-02](debitos-tecnicos.html)): o discriminador `profile` em `section.code` faz cada seção casar com todas as fatias, e o sistema LOINC fixado como `https://loinc.org/` contradiz o binding required `doc-section-codes`. Os exemplos de Composition seguem o perfil e acusam esses erros até a correção no BR-Core. Os demais exemplos validam. Os perfis do FHIR Clinical Documents não acrescentam erros: as Compositions e o Bundle conformam a eles.
