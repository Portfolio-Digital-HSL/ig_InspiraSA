// Exemplo 2: colecistectomia eletiva. Mostra seções sem entradas, com o
// motivo em emptyReason (o SA-IG aceitava seção vazia sem justificativa).

Instance: paciente-lucia
InstanceOf: br-core-patient
Usage: #example
Title: "Paciente Lúcia Ramos"
Description: "Exemplo: Paciente Lúcia Ramos."
// raça/cor: extensão do IPS-BR, 1..1 no br-core-patient (FSH desde a 1.3.0)
* extension[0].url = $raca-br-ips
* extension[0].valueCodeableConcept = $BRRacaCor#01 "Branca"
* identifier[cpf].use = #official
* identifier[cpf].type = $v2-0203#TAX
* identifier[cpf].system = $sid-cpf
* identifier[cpf].value = "00000000353"
* identifier[cns].use = #official
* identifier[cns].type = $v2-0203#HC
* identifier[cns].system = $sid-cns
* identifier[cns].value = "700000000000048"
* name[0].given[0] = "Lúcia"
* name[0].family = "Ramos"
* gender = #female
* birthDate = "1979-02-05"

Instance: internacao-colecistectomia
InstanceOf: RNDSInternacao
Usage: #example
Title: "Internação para colecistectomia"
Description: "Exemplo: Internação para colecistectomia."
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Internação eletiva para colecistectomia videolaparoscópica. Pós-operatório sem intercorrências; alta no 1º dia com dieta oral.</p></div>"
* status = #finished
* class = $v3-ActCode#IMP "inpatient encounter"
* priority = $BRCaraterAtendimento#04 "Consulta agendada programada"
* subject = Reference(paciente-lucia)
* participant[0].type = $BRResponsabilidadeParticipante#alta "Profissional que realizou a alta do indivíduo no Contato Assistencial"
* participant[0].individual = Reference(medica-alta)
* period.start = "2026-09-24T07:00:00-03:00"
* period.end = "2026-09-25T10:00:00-03:00"
* diagnosis[0].condition = Reference(diagnostico-colelitiase)
* diagnosis[0].use = $diagnosis-role#AD "Admission diagnosis"
* hospitalization.admitSource = $BRProcedencia#12 "Demanda referenciada"
* hospitalization.dischargeDisposition = $BRMotivoDesfecho#01 "Alta"
* serviceProvider = Reference(hospital-exemplo)

Instance: diagnostico-colelitiase
InstanceOf: br-core-condition
Usage: #example
Title: "Calculose da vesícula biliar"
Description: "Exemplo: Calculose da vesícula biliar."
* clinicalStatus = $condition-clinical#resolved
* verificationStatus = $condition-ver-status#confirmed
* category[0] = $condition-category#encounter-diagnosis
* code = $BRCID10#K80.2 "Calculose da vesícula biliar sem colecistite"
* subject = Reference(paciente-lucia)
* encounter = Reference(internacao-colecistectomia)
* recordedDate = "2026-09-24"

Instance: procedimento-colecistectomia
InstanceOf: br-core-procedure
Usage: #example
Title: "Colecistectomia videolaparoscópica"
Description: "Exemplo: Colecistectomia videolaparoscópica."
* status = #completed
* code = $BRTabelaSUS#0407030034 "COLECISTECTOMIA VIDEOLAPAROSCOPICA"
* subject = Reference(paciente-lucia)
* encounter = Reference(internacao-colecistectomia)
* performedDateTime = "2026-09-24T09:00:00-03:00"
* performer[0].function = $sct#304292004 "Surgeon (occupation)"
* performer[0].actor = Reference(medica-alta)

Instance: plano-cuidados-colecistectomia
InstanceOf: br-core-careplan
Usage: #example
Title: "Plano de cuidados pós-colecistectomia"
Description: "Exemplo: Plano de cuidados pós-colecistectomia."
* status = #active
* intent = #plan
* description = "Curativo diário, evitar esforço por 30 dias e retorno ambulatorial para retirada de pontos."
* subject = Reference(paciente-lucia)
* encounter = Reference(internacao-colecistectomia)
* activity[0].detail.code = $BRSubgrupoTabelaSUS#0301 "Consultas / Atendimentos / Acompanhamentos"
* activity[0].detail.status = #scheduled
* activity[0].detail.scheduledString = "Retorno em 10 dias"
* activity[0].detail.description = "Consulta com cirurgia geral para retirada de pontos."

RuleSet: SecaoVazia(fatia, codigo, titulo, motivo, texto)
* section[{fatia}].title = "{titulo}"
* section[{fatia}].code.coding[0].system = "https://loinc.org/"
* section[{fatia}].code.coding[0].code = #{codigo}
* section[{fatia}].text.status = #generated
* section[{fatia}].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>{texto}</p></div>"
* section[{fatia}].emptyReason = $list-empty-reason#{motivo}

Instance: sumario-alta-colecistectomia
InstanceOf: RNDSSumarioAlta
Usage: #example
Title: "Sumário de Alta com seções vazias justificadas"
Description: "Exemplo: Sumário de Alta com seções vazias justificadas."
// Conforme ao rnds-sumarioalta, que deriva do br-core-sumarioalta e impõe o clinical-document-composition
* meta.profile[0] = Canonical(RNDSSumarioAlta)
* meta.profile[1] = $clindoc-composition
* identifier.system = "http://fhir.hsl.org.br/ig/inspirasa/sid/documento"
* identifier.value = "SA-2026-000790"
* status = #final
* type = $loinc#18842-5 "Discharge summary"
* category[0] = $loinc#107903-7 "Clinical note"
* subject = Reference(paciente-lucia)
* encounter = Reference(internacao-colecistectomia)
* date = "2026-09-25T10:30:00-03:00"
* author[0] = Reference(medica-alta)
* title = "Sumário de Alta"
* confidentiality = #N
* custodian = Reference(hospital-exemplo)
* attester[0].mode = #legal
* attester[0].time = "2026-09-25T10:30:00-03:00"
* attester[0].party = Reference(medica-alta)
* insert Secao(diagnosticosAdmissao, 42347-5, Diagnósticos da admissão, Calculose da vesícula biliar (K80.2\).)
* section[diagnosticosAdmissao].entry[0] = Reference(diagnostico-colelitiase)
* insert SecaoVazia(alergiasIntolerancias, 48765-2, Alergias e intolerâncias, nilknown, Nega alergias.)
* insert Secao(diagnosticosAvaliados, 57852-6, Diagnósticos avaliados, Calculose da vesícula biliar (K80.2\) tratada.)
* section[diagnosticosAvaliados].entry[0] = Reference(diagnostico-colelitiase)
* insert Secao(procedimentosRealizados, 47519-4, Procedimentos realizados, Colecistectomia videolaparoscópica.)
* section[procedimentosRealizados].entry[0] = Reference(procedimento-colecistectomia)
* insert SecaoVazia(prescricaoAlta, 8654-6, Prescrição de alta, nilknown, Sem medicamentos de uso contínuo.)
* insert Secao(planoCuidados, 18776-5, Plano de cuidados, Curativo diário e retorno em 10 dias.)
* section[planoCuidados].entry[0] = Reference(plano-cuidados-colecistectomia)
* insert SecaoVazia(capacidadeFuncional, 54522-8, Capacidade funcional, notasked, Não avaliada.)
