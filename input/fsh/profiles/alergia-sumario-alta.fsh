Profile: AlergiaSumarioAlta
Parent: br-core-allergyintolerance
Id: alergia-sumario-alta
Title: "Alergia ou Intolerância do Sumário de Alta"
Description: "Alergia ou intolerância registrada na internação. Agente e manifestação em SNOMED CT (base do CBARA), com códigos nacionais aceitos. O BR-Core mantém a ligação required com BRAlergenos; por isso o SNOMED CT entra como coding adicional enquanto o BRAlergenos não incluir SNOMED (ver débitos técnicos)."
* ^status = #draft
* ^experimental = true
* clinicalStatus MS
* verificationStatus MS
* type MS
* category MS
* criticality MS
* code 1..1 MS
* code.coding ^slicing.discriminator.type = #pattern
* code.coding ^slicing.discriminator.path = "system"
* code.coding ^slicing.rules = #open
* code.coding contains snomed 0..1 MS
* code.coding[snomed].system 1..1
* code.coding[snomed].system = $sct
* code.coding[snomed].code 1..1
* code.coding[snomed] from $BRAlergenosSNOMEDNacional-vs (preferred)
* code.coding[snomed] ^short = "Agente em SNOMED CT (CBARA)"
* patient MS
* encounter MS
* onset[x] MS
* recordedDate MS
* reaction MS
* reaction.manifestation MS
* reaction.manifestation from $BRManifestacaoReacaoSNOMED-vs (preferred)
* reaction.manifestation ^comment = "SNOMED CT é o padrão. MedDRA (usado pela Anvisa) pode vir como coding adicional; o ConceptMap BRMedDRAParaSNOMED converte."
* reaction.severity MS
* insert TraducaoPtBrAlergiaSumarioAlta
