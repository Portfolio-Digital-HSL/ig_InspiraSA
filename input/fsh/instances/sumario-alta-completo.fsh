// Exemplo 1: internação por insuficiência cardíaca descompensada, com as sete
// seções preenchidas.

Instance: internacao-ic
InstanceOf: RNDSInternacao
Usage: #example
Title: "Internação por insuficiência cardíaca"
Description: "Exemplo: Internação por insuficiência cardíaca."
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Admitido pelo pronto-socorro com dispneia aos mínimos esforços e edema de membros inferiores. Tratado com diurético venoso, evoluiu com melhora da congestão. Ecocardiograma com fração de ejeção de 35%. Pneumonia comunitária tratada no 3º dia. Alta estável, em ar ambiente.</p></div>"
* identifier[0].system = "http://fhir.hsl.org.br/ig/inspirasa/sid/atendimento"
* identifier[0].value = "INT-2026-000123"
* status = #finished
* class = $v3-ActCode#IMP "inpatient encounter"
* priority = $BRCaraterAtendimento#06 "Demanda espontânea (DE): atendimento de urgência"
* subject = Reference(paciente-joao)
* participant[0].type = $BRResponsabilidadeParticipante#alta "Profissional que realizou a alta do indivíduo no Contato Assistencial"
* participant[0].individual = Reference(medica-alta)
* period.start = "2026-09-20T14:30:00-03:00"
* period.end = "2026-09-28T11:00:00-03:00"
* diagnosis[0].condition = Reference(diagnostico-ic)
* diagnosis[0].use = $diagnosis-role#AD "Admission diagnosis"
* diagnosis[1].condition = Reference(diagnostico-pneumonia)
* diagnosis[1].use = $diagnosis-role#DD "Discharge diagnosis"
* hospitalization.admitSource = $BRProcedencia#09 "Demanda espontânea"
* hospitalization.dischargeDisposition = $BRMotivoDesfecho#01 "Alta"
* serviceProvider = Reference(hospital-exemplo)

Instance: diagnostico-ic
InstanceOf: br-core-condition
Usage: #example
Title: "Insuficiência cardíaca congestiva (admissão)"
Description: "Exemplo: Insuficiência cardíaca congestiva (admissão)."
* clinicalStatus = $condition-clinical#active
* verificationStatus = $condition-ver-status#confirmed
* category[0] = $condition-category#encounter-diagnosis
* code = $BRCID10#I50.0 "Insuficiência cardíaca congestiva"
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* recordedDate = "2026-09-20"

Instance: diagnostico-pneumonia
InstanceOf: br-core-condition
Usage: #example
Title: "Pneumonia (avaliado na internação)"
Description: "Exemplo: Pneumonia (avaliado na internação)."
* clinicalStatus = $condition-clinical#resolved
* verificationStatus = $condition-ver-status#confirmed
* category[0] = $condition-category#encounter-diagnosis
* code = $BRCID10#J18.9 "Pneumonia não especificada"
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* onsetDateTime = "2026-09-23"
* recordedDate = "2026-09-23"

Instance: alergia-penicilina
InstanceOf: br-core-allergyintolerance
Usage: #example
Title: "Alergia a amoxicilina"
Description: "Exemplo: Alergia a amoxicilina."
* clinicalStatus = $allergy-clinical#active
* verificationStatus = $allergy-verification#confirmed
* type = #allergy
* category[0] = #medication
* criticality = #high
* code.coding[0] = $sct#372687004 "Amoxicillin (substance)"
* code.coding[1] = $BRMedicamento#BR0281135-3 "AMOXICILINA + CLAVULANATO DE POTÁSSIO 40+5,7 MG/ML SUSPENSÃO ORAL 70 ML"
* code.text = "Amoxicilina"
* patient = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* recordedDate = "2026-09-20"
* reaction[0].manifestation[0].coding[0] = $sct#41291007 "Angioedema (disorder)"
* reaction[0].manifestation[0].coding[1] = $BRMedDRA#10002424 "Angioedema"
* reaction[0].severity = #severe

Instance: alergia-soja
InstanceOf: br-core-allergyintolerance
Usage: #example
Title: "Alergia a soja"
Description: "Exemplo: substância do CBARA (grao-soja) com o SNOMED CT equivalente; o tipo (grao) vem da hierarquia do CBARA, não de um segundo coding."
* clinicalStatus = $allergy-clinical#active
* verificationStatus = $allergy-verification#confirmed
* type = #allergy
* category[0] = #food
* criticality = #low
* code.coding[0] = $BRAlergenosCBARA#grao-soja "Grãos de soja"
* code.coding[1] = $sct#256355007 "Glycine max (substance)"
* code.text = "Soja"
* patient = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* recordedDate = "2026-09-20"
* reaction[0].manifestation[0].coding[0] = $sct#126485001 "Urticaria (disorder)"
* reaction[0].manifestation[0].coding[1] = $BRMedDRA#10046735 "Urticária"
* reaction[0].severity = #mild

Instance: procedimento-tratamento-ic
InstanceOf: br-core-procedure
Usage: #example
Title: "Tratamento de insuficiência cardíaca"
Description: "Exemplo: Tratamento de insuficiência cardíaca."
* status = #completed
* code = $BRTabelaSUS#0303060212 "TRATAMENTO DE INSUFICIENCIA CARDIACA"
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* performedPeriod.start = "2026-09-20"
* performedPeriod.end = "2026-09-28"
* performer[0].function = $sct#309343006 "Physician (occupation)"
* performer[0].actor = Reference(medica-alta)

Instance: procedimento-ecocardiograma
InstanceOf: br-core-procedure
Usage: #example
Title: "Ecocardiografia transtorácica"
Description: "Exemplo: Ecocardiografia transtorácica."
* status = #completed
* code = $BRTabelaSUS#0205010032 "ECOCARDIOGRAFIA TRANSTORACICA"
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* performedDateTime = "2026-09-22"
* performer[0].actor = Reference(hospital-exemplo)

Instance: medicamento-losartana
InstanceOf: br-core-medication
Usage: #example
Title: "Losartana potássica 100 mg comprimido"
Description: "Exemplo: Losartana potássica 100 mg comprimido."
* code = $BRMedicamento#BR0287473 "LOSARTANA POTÁSSICA 100 MG COMPRIMIDO"

Instance: prescricao-losartana
InstanceOf: br-core-medicationrequest
Usage: #example
Title: "Losartana 100 mg, 1 comprimido ao dia"
Description: "Exemplo: Losartana 100 mg, 1 comprimido ao dia."
* identifier[0].system = "http://fhir.hsl.org.br/ig/inspirasa/sid/prescricao"
* identifier[0].value = "RX-2026-000456-1"
* status = #active
* intent = #order
* category[0] = $medicationrequest-category#discharge
* medicationReference = Reference(medicamento-losartana)
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* authoredOn = "2026-09-28"
* requester = Reference(medica-alta)
* dosageInstruction[0].text = "1 comprimido por via oral pela manhã, uso contínuo"
* dosageInstruction[0].timing.repeat.frequency = 1
* dosageInstruction[0].timing.repeat.period = 1
* dosageInstruction[0].timing.repeat.periodUnit = #d
* dosageInstruction[0].timing.repeat.when[0] = #MORN
* dosageInstruction[0].route = $edqm#20053000 "Oral use"
* dosageInstruction[0].doseAndRate[0].doseQuantity.value = 1
* dosageInstruction[0].doseAndRate[0].doseQuantity.unit = "comprimido"
* dispenseRequest.validityPeriod.start = "2026-09-28"
* dispenseRequest.validityPeriod.end = "2026-12-28"

Instance: plano-cuidados-ic
InstanceOf: br-core-careplan
Usage: #example
Title: "Plano de cuidados pós-alta"
Description: "Exemplo: Plano de cuidados pós-alta."
* status = #active
* intent = #plan
* description = "Restrição hídrica de 1,5 L/dia, pesagem diária e retorno ambulatorial com cardiologia."
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* period.start = "2026-09-28"
* activity[0].detail.code = $BRSubgrupoTabelaSUS#0301 "Consultas / Atendimentos / Acompanhamentos"
* activity[0].detail.status = #scheduled
* activity[0].detail.scheduledString = "Consulta de cardiologia em até 7 dias"
* activity[0].detail.description = "Retorno com cardiologia para ajuste de diurético e betabloqueador."

Instance: capacidade-funcional-ic
InstanceOf: br-core-capacidadefuncional
Usage: #example
Title: "Capacidade funcional na alta"
Description: "Exemplo: Capacidade funcional na alta."
* clinicalStatus = $condition-clinical#active
* category[0] = $BRCategoriaDiagnostico#02 "Secundário"
* code.coding[0] = $sct#228158008 "Walking disability (finding)"
* code.coding[1] = $BRCID10#Z74.0 "Mobilidade reduzida"
* subject = Reference(paciente-joao)
* subject.identifier.system = $sid-cns
* subject.identifier.value = "700000000000013"
* stage[0].summary.text = "Deambula com auxílio para distâncias acima de 50 m"

RuleSet: Secao(fatia, codigo, titulo, texto)
* section[{fatia}].title = "{titulo}"
// system conforme o patternUri do br-core-sumarioalta (débito D-02)
* section[{fatia}].code.coding[0].system = "https://loinc.org/"
* section[{fatia}].code.coding[0].code = #{codigo}
* section[{fatia}].text.status = #generated
* section[{fatia}].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>{texto}</p></div>"

Instance: sumario-alta-ic
InstanceOf: RNDSSumarioAlta
Usage: #example
Title: "Sumário de Alta: insuficiência cardíaca"
Description: "Exemplo: Sumário de Alta: insuficiência cardíaca."
// Conforme ao rnds-sumarioalta, que deriva do br-core-sumarioalta e impõe o clinical-document-composition
* meta.profile[0] = Canonical(RNDSSumarioAlta)
* meta.profile[1] = $clindoc-composition
* identifier.system = "http://fhir.hsl.org.br/ig/inspirasa/sid/documento"
* identifier.value = "SA-2026-000789"
* status = #final
* type = $loinc#18842-5 "Discharge summary"
* category[0] = $loinc#107903-7 "Clinical note"
* subject = Reference(paciente-joao)
* encounter = Reference(internacao-ic)
* date = "2026-09-28T11:30:00-03:00"
* author[0] = Reference(medica-alta)
* title = "Sumário de Alta"
* confidentiality = #N
* custodian = Reference(hospital-exemplo)
* attester[0].mode = #legal
* attester[0].time = "2026-09-28T11:30:00-03:00"
* attester[0].party = Reference(medica-alta)
* insert Secao(diagnosticosAdmissao, 42347-5, Diagnósticos da admissão, Insuficiência cardíaca congestiva (I50.0\).)
* section[diagnosticosAdmissao].entry[0] = Reference(diagnostico-ic)
* insert Secao(alergiasIntolerancias, 48765-2, Alergias e intolerâncias, Amoxicilina: angioedema (grave\). Soja: urticária (leve\).)
* section[alergiasIntolerancias].entry[0] = Reference(alergia-penicilina)
* section[alergiasIntolerancias].entry[+] = Reference(alergia-soja)
* insert Secao(diagnosticosAvaliados, 57852-6, Diagnósticos avaliados, Pneumonia (J18.9\) resolvida.)
* section[diagnosticosAvaliados].entry[0] = Reference(diagnostico-pneumonia)
* insert Secao(procedimentosRealizados, 47519-4, Procedimentos realizados, Tratamento de insuficiência cardíaca; ecocardiografia transtorácica.)
* section[procedimentosRealizados].entry[0] = Reference(procedimento-tratamento-ic)
* section[procedimentosRealizados].entry[+] = Reference(procedimento-ecocardiograma)
* insert Secao(prescricaoAlta, 8654-6, Prescrição de alta, Losartana 100 mg 1 comprimido pela manhã.)
* section[prescricaoAlta].entry[0] = Reference(prescricao-losartana)
* insert Secao(planoCuidados, 18776-5, Plano de cuidados, Restrição hídrica e retorno com cardiologia em até 7 dias.)
* section[planoCuidados].entry[0] = Reference(plano-cuidados-ic)
* insert Secao(capacidadeFuncional, 54522-8, Capacidade funcional, Deambula com auxílio.)
* section[capacidadeFuncional].entry[0] = Reference(capacidade-funcional-ic)
