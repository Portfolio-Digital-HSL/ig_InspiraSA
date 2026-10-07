// Aliases do guia. Use SEMPRE o alias, nunca a URL crua, nos arquivos .fsh.
// Terminologias brasileiras: URLs do guia de terminologia
// (https://terminologia.saude.gov.br/fhir/...). Os ValueSets e suplementos
// novos deste guia estão em terminologia/ e vão para o guia de terminologia;
// não são definidos aqui.

// ─── Terminologias externas ────────────────────────────────────────────────
Alias: $sct    = http://snomed.info/sct
Alias: $loinc  = http://loinc.org
Alias: $ucum   = http://unitsofmeasure.org
Alias: $edqm   = http://standardterms.edqm.eu

// ─── HL7 Terminology (THO) e FHIR R4 ───────────────────────────────────────
Alias: $v2-0203                 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v3-ActCode              = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v3-Confidentiality      = http://terminology.hl7.org/CodeSystem/v3-Confidentiality
Alias: $condition-clinical      = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-ver-status    = http://terminology.hl7.org/CodeSystem/condition-ver-status
Alias: $condition-category      = http://terminology.hl7.org/CodeSystem/condition-category
Alias: $allergy-clinical        = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical
Alias: $allergy-verification    = http://terminology.hl7.org/CodeSystem/allergyintolerance-verification
Alias: $list-empty-reason       = http://terminology.hl7.org/CodeSystem/list-empty-reason
Alias: $diagnosis-role          = http://terminology.hl7.org/CodeSystem/diagnosis-role
Alias: $medicationrequest-category = http://terminology.hl7.org/CodeSystem/medicationrequest-category
Alias: $performer-role-vs       = http://hl7.org/fhir/ValueSet/performer-role

// ─── Sistemas de identificação ─────────────────────────────────────────────
Alias: $iso3166  = urn:iso:std:iso:3166
Alias: $sid-cpf  = https://saude.gov.br/fhir/sid/cpf
Alias: $sid-cns  = https://saude.gov.br/fhir/sid/cns
Alias: $sid-cnes = https://saude.gov.br/fhir/sid/cnes

// ─── Guia de terminologia (terminologia.saude.gov.br) ──────────────────────
Alias: $BRCID10              = https://terminologia.saude.gov.br/fhir/CodeSystem/BRCID10
Alias: $BRCID10-vs           = https://terminologia.saude.gov.br/fhir/ValueSet/BRCID10
Alias: $BRTabelaSUS          = https://terminologia.saude.gov.br/fhir/CodeSystem/BRTabelaSUS
Alias: $BRSubgrupoTabelaSUS  = https://terminologia.saude.gov.br/fhir/CodeSystem/BRSubgrupoTabelaSUS
Alias: $BRMedicamento        = https://terminologia.saude.gov.br/fhir/CodeSystem/BRMedicamento
Alias: $BRCategoriaDiagnostico = https://terminologia.saude.gov.br/fhir/CodeSystem/BRCategoriaDiagnostico
Alias: $BRMotivoDesfecho     = https://terminologia.saude.gov.br/fhir/CodeSystem/BRMotivoDesfecho
Alias: $BRProcedencia        = https://terminologia.saude.gov.br/fhir/CodeSystem/BRProcedencia
Alias: $BRCaraterAtendimento = https://terminologia.saude.gov.br/fhir/CodeSystem/BRCaraterAtendimento
Alias: $BRResponsabilidadeParticipante = https://terminologia.saude.gov.br/fhir/CodeSystem/BRResponsabilidadeParticipante
Alias: $BRAlergenosCBARA     = https://terminologia.saude.gov.br/fhir/CodeSystem/BRAlergenosCBARA
Alias: $BRMedDRA             = https://terminologia.saude.gov.br/fhir/CodeSystem/BRMedDRA
// Novos (terminologia/ deste repositório, a publicar no guia de terminologia)
Alias: $BRAlergenosSNOMEDNacional-vs = https://terminologia.saude.gov.br/fhir/ValueSet/BRAlergenosSNOMEDNacional
Alias: $BRManifestacaoReacaoSNOMED-vs = https://terminologia.saude.gov.br/fhir/ValueSet/BRManifestacaoReacaoSNOMED
Alias: $BRProcedimentosNacionais-vs = https://terminologia.saude.gov.br/fhir/ValueSet/BRProcedimentosNacionais

// ─── FHIR Clinical Documents (hl7.fhir.uv.fhir-clinical-document 1.0.1) ─────
Alias: $clindoc-bundle      = http://hl7.org/fhir/uv/fhir-clinical-document/StructureDefinition/clinical-document-bundle
Alias: $clindoc-composition = http://hl7.org/fhir/uv/fhir-clinical-document/StructureDefinition/clinical-document-composition

// ─── Artefatos deste guia ──────────────────────────────────────────────────
Alias: $inspirasa = http://fhir.hsl.org.br/ig/inspirasa

// IPS-BR (extensões usadas pelo br-core-patient)
Alias: $raca-br-ips = https://ips.saude.gov.br/fhir/StructureDefinition/raca-br-ips
Alias: $BRRacaCor = https://terminologia.saude.gov.br/fhir/CodeSystem/BRRacaCor
Alias: $imposeProfile = http://hl7.org/fhir/StructureDefinition/structuredefinition-imposeProfile
