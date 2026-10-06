// Perfis RNDS do Sumário de Alta.
// Só restringem perfis do BR-Core e do FHIR Clinical Documents: não criam elementos,
// extensões nem terminologia. Cada restrição está classificada como
// [BR-Core] (proposta ao BR-Core; sai daqui quando o BR-Core publicar) ou
// [RNDS] (regra operacional da RNDS, fica aqui).
// Autoria: Jussara Macedo Pinho Rötzsch.

Alias: $imposeProfile = http://hl7.org/fhir/StructureDefinition/structuredefinition-imposeProfile

// ---------------------------------------------------------------------------
Profile: RNDSSumarioAlta
Parent: br-core-sumarioalta
Id: rnds-sumarioalta
Title: "RNDS Sumário de Alta"
Description: "Composition do Sumário de Alta enviado à RNDS. Restringe o br-core-sumarioalta e exige conformidade ao clinical-document-composition (FHIR Clinical Documents). Não acrescenta elementos."
* ^status = #draft
* ^experimental = true
* ^extension[0].url = $imposeProfile
* ^extension[0].valueCanonical = $clindoc-composition
// [RNDS] identificador do documento, igual em todas as transmissões e na retificação
* identifier 1..1 MS
* identifier ^short = "Identificador do documento (estável entre versões)"
* identifier.system 1..1 MS
* identifier.value 1..1 MS
// [BR-Core] tipo de documento
* type = $loinc#18842-5
// [RNDS] categoria do FHIR Clinical Documents
* category 1..1 MS
* category = $loinc#107903-7
// [BR-Core] paciente, internação e custodiante obrigatórios
* subject 1..1 MS
* encounter 1..1 MS
* encounter only Reference(RNDSInternacao)
* encounter ^short = "Internação a que o sumário se refere (substitui a seção de contato assistencial do SA-IG)"
* custodian 1..1 MS
* custodian ^short = "Estabelecimento (CNES) responsável pela guarda do documento"
// [RNDS] atestador legal: profissional responsável pela alta
* attester 1..* MS
* obeys rnds-sa-1
// [BR-Core] toda seção com entradas ou com justificativa de ausência
* section[diagnosticosAdmissao] obeys rnds-sa-2
* section[alergiasIntolerancias] obeys rnds-sa-2
* section[diagnosticosAvaliados] obeys rnds-sa-2
* section[procedimentosRealizados] obeys rnds-sa-2
* section[prescricaoAlta] obeys rnds-sa-2
* section[planoCuidados] obeys rnds-sa-2
* section[capacidadeFuncional] obeys rnds-sa-2

Invariant: rnds-sa-1
Description: "O documento DEVE ter um atestador legal (attester.mode = legal) com data e profissional."
Severity: #error
Expression: "attester.where(mode = 'legal' and time.exists() and party.exists()).exists()"

Invariant: rnds-sa-2
Description: "A seção DEVE ter entradas ou a justificativa da ausência (emptyReason)."
Severity: #error
Expression: "entry.exists() or emptyReason.exists()"

// ---------------------------------------------------------------------------
Profile: RNDSInternacao
Parent: br-core-encounter
Id: rnds-internacao
Title: "RNDS Internação (Sumário de Alta)"
Description: "Encounter da internação referenciado pelo Sumário de Alta enviado à RNDS. Restringe o br-core-encounter; carrega o contato assistencial e o resumo da evolução clínica, que no SA-IG eram seções próprias."
* ^status = #draft
* ^experimental = true
// [RNDS] o sumário é emitido na alta: internação encerrada
* status = #finished
* class = $v3-ActCode#IMP
// [RNDS] resumo da evolução clínica na narrativa do Encounter
* text 1..1 MS
* text ^short = "Resumo da evolução clínica durante a internação"
// [RNDS] data da alta
* period.end 1..1 MS
// [RNDS] profissional da alta
* participant 1..* MS
* obeys rnds-int-1
// [RNDS] motivo da alta
* hospitalization 1..1 MS

Invariant: rnds-int-1
Description: "A internação DEVE identificar o profissional que realizou a alta (participant.type = alta)."
Severity: #error
Expression: "participant.where(type.coding.where(system = 'https://terminologia.saude.gov.br/fhir/CodeSystem/BRResponsabilidadeParticipante' and code = 'alta').exists() and individual.exists()).exists()"

// ---------------------------------------------------------------------------
Profile: RNDSDocumentoSumarioAlta
Parent: $clindoc-bundle
Id: rnds-documento-sumarioalta
Title: "RNDS Documento do Sumário de Alta"
Description: "Bundle document com que o Sumário de Alta é enviado à RNDS. Restringe o clinical-document-bundle (FHIR Clinical Documents); passa a derivar do br-core-bundle-documento quando ele for publicado."
* ^status = #draft
* ^experimental = true
* identifier 1..1 MS
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* timestamp 1..1 MS
* identifier ^short = "Identificador desta instância do documento (muda a cada emissão; o identificador estável é Composition.identifier)"
* obeys rnds-doc-1 and rnds-doc-3

Invariant: rnds-doc-1
Description: "A primeira entrada DEVE ser a Composition conforme ao rnds-sumarioalta."
Severity: #error
Expression: "entry.first().resource.is(Composition) and entry.first().resource.conformsTo('http://fhir.hsl.org.br/ig/inspirasa/StructureDefinition/rnds-sumarioalta')"

Invariant: rnds-doc-3
Description: "Bundle.timestamp DEVE ser maior ou igual a Composition.date."
Severity: #error
Expression: "timestamp >= entry.first().resource.date"
