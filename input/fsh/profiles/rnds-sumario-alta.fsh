// Perfil RNDS da composição do Sumário de Alta (BRSumarioAlta).
// Deriva do br-core-composition; documento de caso de uso da RNDS
// (Portaria SAES/MS nº 701/2022). Não cria elementos, extensões nem terminologia.
// Autoria: Jussara Macedo Pinho Rötzsch.

Profile: BRSumarioAlta
Parent: br-core-composition
Id: BRSumarioAlta
Title: "BRSumarioAlta: Sumário de Alta"
Description: "Composition do Sumário de Alta hospitalar enviado à RNDS (Portaria SAES/MS nº 701/2022). Mantém o nome do perfil do SA-IG (BRSumarioAlta) e muda a herança: deriva do br-core-composition, não mais do BRConjuntoMinimoDados (CMD) e exige conformidade ao clinical-document-composition (FHIR Clinical Documents). Define as sete seções do documento; os recursos de cada seção usam os perfis do BR-Core."
* ^status = #draft
* ^experimental = true
* ^extension[0].url = $imposeProfile
* ^extension[0].valueCanonical = $clindoc-composition
// identificador do documento, igual em todas as transmissões e na retificação
* identifier 1..1 MS
* identifier ^short = "Identificador do documento (estável entre versões)"
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* type = $loinc#18842-5
* category 1..1 MS
* category = $loinc#107903-7
* subject 1..1 MS
* encounter 1..1 MS
* encounter only Reference(RNDSInternacao)
* encounter ^short = "Internação a que o sumário se refere (substitui a seção de contato assistencial do SA-IG)"
* custodian 1..1 MS
* custodian ^short = "Estabelecimento (CNES) responsável pela guarda do documento"
* attester 1..* MS
* obeys rnds-sa-1
// Seções: fatiadas pelo código LOINC (pattern), uma de cada.
// Códigos do IPS onde o IPS tem a seção (alergias 48765-2, procedimentos 47519-4,
// plano de cuidados 18776-5, capacidade funcional 47420-5).
* section 7..7 MS
* section ^slicing.discriminator.type = #pattern
* section ^slicing.discriminator.path = "code"
* section ^slicing.rules = #open
* section ^short = "Seções do Sumário de Alta"
* section contains
    diagnosticosAdmissao 1..1 MS and
    alergiasIntolerancias 1..1 MS and
    diagnosticosAvaliados 1..1 MS and
    procedimentosRealizados 1..1 MS and
    prescricaoAlta 1..1 MS and
    planoCuidados 1..1 MS and
    capacidadeFuncional 1..1 MS
* insert SecaoRNDS(diagnosticosAdmissao, 42347-5, Diagnósticos da admissão, br-core-condition)
* insert SecaoRNDS(alergiasIntolerancias, 48765-2, Alergias e intolerâncias, br-core-allergyintolerance)
* insert SecaoRNDS(diagnosticosAvaliados, 57852-6, Diagnósticos avaliados, br-core-condition)
* insert SecaoRNDS(procedimentosRealizados, 47519-4, Procedimentos realizados, br-core-procedure)
* insert SecaoRNDS(prescricaoAlta, 8654-6, Prescrição de alta, br-core-medicationrequest)
* insert SecaoRNDS(planoCuidados, 18776-5, Plano de cuidados, br-core-careplan)
* insert SecaoRNDS(capacidadeFuncional, 47420-5, Capacidade funcional, br-core-capacidadefuncional)

RuleSet: SecaoRNDS(fatia, codigo, nome, perfil)
* section[{fatia}] ^short = "{nome}"
* section[{fatia}].title 1..1 MS
* section[{fatia}].code 1..1 MS
* section[{fatia}].code = $loinc#{codigo}
* section[{fatia}].text 1..1 MS
* section[{fatia}].entry MS
* section[{fatia}].entry only Reference({perfil})
* section[{fatia}].emptyReason MS
* section[{fatia}] obeys rnds-sa-2

Invariant: rnds-sa-1
Description: "O documento DEVE ter um atestador legal (attester.mode = legal) com data e profissional."
Severity: #error
Expression: "attester.where(mode = 'legal' and time.exists() and party.exists()).exists()"

Invariant: rnds-sa-2
Description: "A seção DEVE ter entradas ou a justificativa da ausência (emptyReason)."
Severity: #error
Expression: "entry.exists() or emptyReason.exists()"
