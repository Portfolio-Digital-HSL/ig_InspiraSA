Profile: DiagnosticoSumarioAlta
Parent: br-core-condition
Id: diagnostico-sumario-alta
Title: "Diagnóstico do Sumário de Alta"
Description: "Diagnóstico de admissão ou avaliado durante a internação. Os status usam os ValueSets obrigatórios do HL7, com designações em português dos suplementos do guia de terminologia (substituem BRStatusDiagnostico e similares do SA-IG)."
* ^status = #draft
* ^experimental = true
* clinicalStatus MS
* verificationStatus 1..1 MS
* category MS
* category ^comment = "encounter-diagnosis para diagnósticos da internação."
* code 1..1 MS
* code from $BRCID10-vs (preferred)
* code ^comment = "CID-10 (BRCID10). SNOMED CT pode ser enviado como coding adicional."
* subject MS
* encounter MS
* onset[x] MS
* recordedDate MS
* insert TraducaoPtBrDiagnosticoSumarioAlta
