// Exemplo 3: o Sumário de Alta do exemplo 1 como documento FHIR (Bundle
// document), forma de envio à RNDS. A Composition é a primeira entrada.

RuleSet: Entrada(tipo, id)
* entry[+].fullUrl = "http://fhir.hsl.org.br/ig/inspirasa/{tipo}/{id}"
* entry[=].resource = {id}

Instance: documento-sumario-alta-ic
InstanceOf: Bundle
Usage: #example
Title: "Documento do Sumário de Alta (insuficiência cardíaca)"
Description: "Exemplo: Documento do Sumário de Alta (insuficiência cardíaca)."
* identifier.system = "http://fhir.hsl.org.br/ig/inspirasa/sid/documento"
* identifier.value = "SA-2026-000789"
* type = #document
* timestamp = "2026-09-28T11:30:00-03:00"
* insert Entrada(Composition, sumario-alta-ic)
* insert Entrada(Patient, paciente-joao)
* insert Entrada(Encounter, internacao-ic)
* insert Entrada(Practitioner, medica-alta)
* insert Entrada(Organization, hospital-exemplo)
* insert Entrada(Condition, diagnostico-ic)
* insert Entrada(Condition, diagnostico-pneumonia)
* insert Entrada(AllergyIntolerance, alergia-penicilina)
* insert Entrada(Procedure, procedimento-tratamento-ic)
* insert Entrada(Procedure, procedimento-ecocardiograma)
* insert Entrada(MedicationRequest, prescricao-losartana)
* insert Entrada(Medication, medicamento-losartana)
* insert Entrada(CarePlan, plano-cuidados-ic)
* insert Entrada(Condition, capacidade-funcional-ic)
