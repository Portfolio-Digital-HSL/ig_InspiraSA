Invariant: pa-1
Description: "O medicamento DEVE ser informado por referência a br-core-medication (medicationReference)."
Expression: "medication.ofType(Reference).exists()"
Severity: #error

Profile: PrescricaoAltaSumarioAlta
Parent: br-core-medicationrequest
Id: prescricao-alta-sumario-alta
Title: "Prescrição de Alta"
Description: "Medicamento prescrito para uso após a alta. Cada item é um MedicationRequest ligado diretamente à seção prescricaoAlta, sem a Composition intermediária BRRegistroPrescricaoMedicamento do SA-IG. Turno e intervalo entre doses usam Dosage.timing (substituem BRTurno e BRIntervaloDoses)."
* ^status = #draft
* ^experimental = true
* identifier MS
* status MS
* intent = #order
* intent MS
* category 1..* MS
* category = $medicationrequest-category#discharge
* medication[x] MS
* obeys pa-1
* medicationReference MS
* medication[x] ^comment = "Sempre por referência a br-core-medication (invariante pa-1; substitui o CodeableConcept em texto livre BRPrescricaoNaoEstruturada do SA-IG). Prescrição não estruturada: Medication contido só com code.text. A restrição é feita por invariante e não por only Reference porque o binding herdado do BR-Core em medication[x] gera erro de perfil quando o tipo fica só Reference (ver débitos)."
* subject MS
* encounter MS
* authoredOn MS
* requester MS
* dosageInstruction 1..1 MS
* dosageInstruction ^comment = "O BR-Core limita dosageInstruction a 0..1: esquemas com mais de uma posologia (dose de ataque e manutenção) exigem um MedicationRequest por fase (ver débitos técnicos)."
* dosageInstruction.text MS
* dosageInstruction.timing MS
* dosageInstruction.route MS
* dosageInstruction.doseAndRate MS
* dispenseRequest MS
* insert TraducaoPtBrPrescricaoAltaSumarioAlta
