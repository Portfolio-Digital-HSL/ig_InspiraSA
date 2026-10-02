// Suplementos pt-BR de CodeSystems HL7 usados pelo Sumário de Alta.
// Substituem os CodeSystems nacionais que eram traduções (BRStatusAlergia,
// BRCriticidadeAlergiasReacoesAdversas etc.): o código continua o do HL7 e o
// texto em português vem como designation. Para gerar: ./scripts/gerar.sh

RuleSet: SuplementoPtBr(id, base)
* ^url = "https://terminologia.saude.gov.br/fhir/CodeSystem/{id}"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = true
* ^publisher = "Ministério da Saúde"
* ^language = #pt-BR
* ^content = #supplement
* ^supplements = "{base}"
* ^caseSensitive = true

CodeSystem: BRSuplementoCondicaoClinica
Id: BRSuplementoCondicaoClinica
Title: "Suplemento pt-BR: condition-clinical"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/condition-clinical (uso: Condition.clinicalStatus). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoCondicaoClinica, http://terminology.hl7.org/CodeSystem/condition-clinical)
* #active "Active"
* #active ^designation[+].language = #pt-BR
* #active ^designation[=].use = $designation-usage#display
* #active ^designation[=].value = "Ativa"
* #recurrence "Recurrence"
* #recurrence ^designation[+].language = #pt-BR
* #recurrence ^designation[=].use = $designation-usage#display
* #recurrence ^designation[=].value = "Recorrência"
* #relapse "Relapse"
* #relapse ^designation[+].language = #pt-BR
* #relapse ^designation[=].use = $designation-usage#display
* #relapse ^designation[=].value = "Recaída"
* #inactive "Inactive"
* #inactive ^designation[+].language = #pt-BR
* #inactive ^designation[=].use = $designation-usage#display
* #inactive ^designation[=].value = "Inativa"
* #remission "Remission"
* #remission ^designation[+].language = #pt-BR
* #remission ^designation[=].use = $designation-usage#display
* #remission ^designation[=].value = "Remissão"
* #resolved "Resolved"
* #resolved ^designation[+].language = #pt-BR
* #resolved ^designation[=].use = $designation-usage#display
* #resolved ^designation[=].value = "Resolvida"

CodeSystem: BRSuplementoCondicaoVerificacao
Id: BRSuplementoCondicaoVerificacao
Title: "Suplemento pt-BR: condition-ver-status"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/condition-ver-status (uso: Condition.verificationStatus). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoCondicaoVerificacao, http://terminology.hl7.org/CodeSystem/condition-ver-status)
* #unconfirmed "Unconfirmed"
* #unconfirmed ^designation[+].language = #pt-BR
* #unconfirmed ^designation[=].use = $designation-usage#display
* #unconfirmed ^designation[=].value = "Não confirmada"
* #provisional "Provisional"
* #provisional ^designation[+].language = #pt-BR
* #provisional ^designation[=].use = $designation-usage#display
* #provisional ^designation[=].value = "Provisória"
* #differential "Differential"
* #differential ^designation[+].language = #pt-BR
* #differential ^designation[=].use = $designation-usage#display
* #differential ^designation[=].value = "Diferencial"
* #confirmed "Confirmed"
* #confirmed ^designation[+].language = #pt-BR
* #confirmed ^designation[=].use = $designation-usage#display
* #confirmed ^designation[=].value = "Confirmada"
* #refuted "Refuted"
* #refuted ^designation[+].language = #pt-BR
* #refuted ^designation[=].use = $designation-usage#display
* #refuted ^designation[=].value = "Refutada"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrada por erro"

CodeSystem: BRSuplementoCategoriaCondicao
Id: BRSuplementoCategoriaCondicao
Title: "Suplemento pt-BR: condition-category"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/condition-category (uso: Condition.category). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoCategoriaCondicao, http://terminology.hl7.org/CodeSystem/condition-category)
* #problem-list-item "Problem List Item"
* #problem-list-item ^designation[+].language = #pt-BR
* #problem-list-item ^designation[=].use = $designation-usage#display
* #problem-list-item ^designation[=].value = "Item da lista de problemas"
* #encounter-diagnosis "Encounter Diagnosis"
* #encounter-diagnosis ^designation[+].language = #pt-BR
* #encounter-diagnosis ^designation[=].use = $designation-usage#display
* #encounter-diagnosis ^designation[=].value = "Diagnóstico do atendimento"

CodeSystem: BRSuplementoAlergiaClinica
Id: BRSuplementoAlergiaClinica
Title: "Suplemento pt-BR: allergyintolerance-clinical"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical (uso: AllergyIntolerance.clinicalStatus). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoAlergiaClinica, http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical)
* #active "Active"
* #active ^designation[+].language = #pt-BR
* #active ^designation[=].use = $designation-usage#display
* #active ^designation[=].value = "Ativa"
* #inactive "Inactive"
* #inactive ^designation[+].language = #pt-BR
* #inactive ^designation[=].use = $designation-usage#display
* #inactive ^designation[=].value = "Inativa"
* #resolved "Resolved"
* #resolved ^designation[+].language = #pt-BR
* #resolved ^designation[=].use = $designation-usage#display
* #resolved ^designation[=].value = "Resolvida"

CodeSystem: BRSuplementoAlergiaVerificacao
Id: BRSuplementoAlergiaVerificacao
Title: "Suplemento pt-BR: allergyintolerance-verification"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/allergyintolerance-verification (uso: AllergyIntolerance.verificationStatus). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoAlergiaVerificacao, http://terminology.hl7.org/CodeSystem/allergyintolerance-verification)
* #unconfirmed "Unconfirmed"
* #unconfirmed ^designation[+].language = #pt-BR
* #unconfirmed ^designation[=].use = $designation-usage#display
* #unconfirmed ^designation[=].value = "Não confirmada"
* #confirmed "Confirmed"
* #confirmed ^designation[+].language = #pt-BR
* #confirmed ^designation[=].use = $designation-usage#display
* #confirmed ^designation[=].value = "Confirmada"
* #refuted "Refuted"
* #refuted ^designation[+].language = #pt-BR
* #refuted ^designation[=].use = $designation-usage#display
* #refuted ^designation[=].value = "Refutada"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrada por erro"

CodeSystem: BRSuplementoAlergiaTipo
Id: BRSuplementoAlergiaTipo
Title: "Suplemento pt-BR: allergy-intolerance-type"
Description: "Designações em português do Brasil para http://hl7.org/fhir/allergy-intolerance-type (uso: AllergyIntolerance.type). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoAlergiaTipo, http://hl7.org/fhir/allergy-intolerance-type)
* #allergy "Allergy"
* #allergy ^designation[+].language = #pt-BR
* #allergy ^designation[=].use = $designation-usage#display
* #allergy ^designation[=].value = "Alergia"
* #intolerance "Intolerance"
* #intolerance ^designation[+].language = #pt-BR
* #intolerance ^designation[=].use = $designation-usage#display
* #intolerance ^designation[=].value = "Intolerância"

CodeSystem: BRSuplementoAlergiaCategoria
Id: BRSuplementoAlergiaCategoria
Title: "Suplemento pt-BR: allergy-intolerance-category"
Description: "Designações em português do Brasil para http://hl7.org/fhir/allergy-intolerance-category (uso: AllergyIntolerance.category). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoAlergiaCategoria, http://hl7.org/fhir/allergy-intolerance-category)
* #food "Food"
* #food ^designation[+].language = #pt-BR
* #food ^designation[=].use = $designation-usage#display
* #food ^designation[=].value = "Alimento"
* #medication "Medication"
* #medication ^designation[+].language = #pt-BR
* #medication ^designation[=].use = $designation-usage#display
* #medication ^designation[=].value = "Medicamento"
* #environment "Environment"
* #environment ^designation[+].language = #pt-BR
* #environment ^designation[=].use = $designation-usage#display
* #environment ^designation[=].value = "Ambiental"
* #biologic "Biologic"
* #biologic ^designation[+].language = #pt-BR
* #biologic ^designation[=].use = $designation-usage#display
* #biologic ^designation[=].value = "Biológico"

CodeSystem: BRSuplementoAlergiaCriticidade
Id: BRSuplementoAlergiaCriticidade
Title: "Suplemento pt-BR: allergy-intolerance-criticality"
Description: "Designações em português do Brasil para http://hl7.org/fhir/allergy-intolerance-criticality (uso: AllergyIntolerance.criticality). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoAlergiaCriticidade, http://hl7.org/fhir/allergy-intolerance-criticality)
* #low "Low Risk"
* #low ^designation[+].language = #pt-BR
* #low ^designation[=].use = $designation-usage#display
* #low ^designation[=].value = "Baixo risco"
* #high "High Risk"
* #high ^designation[+].language = #pt-BR
* #high ^designation[=].use = $designation-usage#display
* #high ^designation[=].value = "Alto risco"
* #unable-to-assess "Unable to Assess Risk"
* #unable-to-assess ^designation[+].language = #pt-BR
* #unable-to-assess ^designation[=].use = $designation-usage#display
* #unable-to-assess ^designation[=].value = "Risco não avaliável"

CodeSystem: BRSuplementoGravidadeReacao
Id: BRSuplementoGravidadeReacao
Title: "Suplemento pt-BR: reaction-event-severity"
Description: "Designações em português do Brasil para http://hl7.org/fhir/reaction-event-severity (uso: AllergyIntolerance.reaction.severity). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoGravidadeReacao, http://hl7.org/fhir/reaction-event-severity)
* #mild "Mild"
* #mild ^designation[+].language = #pt-BR
* #mild ^designation[=].use = $designation-usage#display
* #mild ^designation[=].value = "Leve"
* #moderate "Moderate"
* #moderate ^designation[+].language = #pt-BR
* #moderate ^designation[=].use = $designation-usage#display
* #moderate ^designation[=].value = "Moderada"
* #severe "Severe"
* #severe ^designation[+].language = #pt-BR
* #severe ^designation[=].use = $designation-usage#display
* #severe ^designation[=].value = "Grave"

CodeSystem: BRSuplementoSituacaoEvento
Id: BRSuplementoSituacaoEvento
Title: "Suplemento pt-BR: event-status"
Description: "Designações em português do Brasil para http://hl7.org/fhir/event-status (uso: Procedure.status). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoSituacaoEvento, http://hl7.org/fhir/event-status)
* #preparation "Preparation"
* #preparation ^designation[+].language = #pt-BR
* #preparation ^designation[=].use = $designation-usage#display
* #preparation ^designation[=].value = "Em preparo"
* #in-progress "In Progress"
* #in-progress ^designation[+].language = #pt-BR
* #in-progress ^designation[=].use = $designation-usage#display
* #in-progress ^designation[=].value = "Em andamento"
* #not-done "Not Done"
* #not-done ^designation[+].language = #pt-BR
* #not-done ^designation[=].use = $designation-usage#display
* #not-done ^designation[=].value = "Não realizado"
* #on-hold "On Hold"
* #on-hold ^designation[+].language = #pt-BR
* #on-hold ^designation[=].use = $designation-usage#display
* #on-hold ^designation[=].value = "Suspenso"
* #stopped "Stopped"
* #stopped ^designation[+].language = #pt-BR
* #stopped ^designation[=].use = $designation-usage#display
* #stopped ^designation[=].value = "Interrompido"
* #completed "Completed"
* #completed ^designation[+].language = #pt-BR
* #completed ^designation[=].use = $designation-usage#display
* #completed ^designation[=].value = "Concluído"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrado por erro"
* #unknown "Unknown"
* #unknown ^designation[+].language = #pt-BR
* #unknown ^designation[=].use = $designation-usage#display
* #unknown ^designation[=].value = "Desconhecido"

CodeSystem: BRSuplementoSituacaoPrescricao
Id: BRSuplementoSituacaoPrescricao
Title: "Suplemento pt-BR: medicationrequest-status"
Description: "Designações em português do Brasil para http://hl7.org/fhir/CodeSystem/medicationrequest-status (uso: MedicationRequest.status). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoSituacaoPrescricao, http://hl7.org/fhir/CodeSystem/medicationrequest-status)
* #active "Active"
* #active ^designation[+].language = #pt-BR
* #active ^designation[=].use = $designation-usage#display
* #active ^designation[=].value = "Ativa"
* #on-hold "On Hold"
* #on-hold ^designation[+].language = #pt-BR
* #on-hold ^designation[=].use = $designation-usage#display
* #on-hold ^designation[=].value = "Suspensa"
* #cancelled "Cancelled"
* #cancelled ^designation[+].language = #pt-BR
* #cancelled ^designation[=].use = $designation-usage#display
* #cancelled ^designation[=].value = "Cancelada"
* #completed "Completed"
* #completed ^designation[+].language = #pt-BR
* #completed ^designation[=].use = $designation-usage#display
* #completed ^designation[=].value = "Concluída"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrada por erro"
* #stopped "Stopped"
* #stopped ^designation[+].language = #pt-BR
* #stopped ^designation[=].use = $designation-usage#display
* #stopped ^designation[=].value = "Interrompida"
* #draft "Draft"
* #draft ^designation[+].language = #pt-BR
* #draft ^designation[=].use = $designation-usage#display
* #draft ^designation[=].value = "Rascunho"
* #unknown "Unknown"
* #unknown ^designation[+].language = #pt-BR
* #unknown ^designation[=].use = $designation-usage#display
* #unknown ^designation[=].value = "Desconhecida"

CodeSystem: BRSuplementoIntencaoPrescricao
Id: BRSuplementoIntencaoPrescricao
Title: "Suplemento pt-BR: medicationrequest-intent"
Description: "Designações em português do Brasil para http://hl7.org/fhir/CodeSystem/medicationrequest-intent (uso: MedicationRequest.intent). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoIntencaoPrescricao, http://hl7.org/fhir/CodeSystem/medicationrequest-intent)
* #proposal "Proposal"
* #proposal ^designation[+].language = #pt-BR
* #proposal ^designation[=].use = $designation-usage#display
* #proposal ^designation[=].value = "Proposta"
* #plan "Plan"
* #plan ^designation[+].language = #pt-BR
* #plan ^designation[=].use = $designation-usage#display
* #plan ^designation[=].value = "Plano"
* #order "Order"
* #order ^designation[+].language = #pt-BR
* #order ^designation[=].use = $designation-usage#display
* #order ^designation[=].value = "Prescrição"
* #original-order "Original Order"
* #original-order ^designation[+].language = #pt-BR
* #original-order ^designation[=].use = $designation-usage#display
* #original-order ^designation[=].value = "Prescrição original"
* #reflex-order "Reflex Order"
* #reflex-order ^designation[+].language = #pt-BR
* #reflex-order ^designation[=].use = $designation-usage#display
* #reflex-order ^designation[=].value = "Prescrição reflexa"
* #filler-order "Filler Order"
* #filler-order ^designation[+].language = #pt-BR
* #filler-order ^designation[=].use = $designation-usage#display
* #filler-order ^designation[=].value = "Prescrição do executante"
* #instance-order "Instance Order"
* #instance-order ^designation[+].language = #pt-BR
* #instance-order ^designation[=].use = $designation-usage#display
* #instance-order ^designation[=].value = "Prescrição de instância"
* #option "Option"
* #option ^designation[+].language = #pt-BR
* #option ^designation[=].use = $designation-usage#display
* #option ^designation[=].value = "Opção"

CodeSystem: BRSuplementoSituacaoRequisicao
Id: BRSuplementoSituacaoRequisicao
Title: "Suplemento pt-BR: request-status"
Description: "Designações em português do Brasil para http://hl7.org/fhir/request-status (uso: CarePlan.status). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoSituacaoRequisicao, http://hl7.org/fhir/request-status)
* #draft "Draft"
* #draft ^designation[+].language = #pt-BR
* #draft ^designation[=].use = $designation-usage#display
* #draft ^designation[=].value = "Rascunho"
* #active "Active"
* #active ^designation[+].language = #pt-BR
* #active ^designation[=].use = $designation-usage#display
* #active ^designation[=].value = "Ativo"
* #on-hold "On Hold"
* #on-hold ^designation[+].language = #pt-BR
* #on-hold ^designation[=].use = $designation-usage#display
* #on-hold ^designation[=].value = "Suspenso"
* #revoked "Revoked"
* #revoked ^designation[+].language = #pt-BR
* #revoked ^designation[=].use = $designation-usage#display
* #revoked ^designation[=].value = "Revogado"
* #completed "Completed"
* #completed ^designation[+].language = #pt-BR
* #completed ^designation[=].use = $designation-usage#display
* #completed ^designation[=].value = "Concluído"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrado por erro"
* #unknown "Unknown"
* #unknown ^designation[+].language = #pt-BR
* #unknown ^designation[=].use = $designation-usage#display
* #unknown ^designation[=].value = "Desconhecido"

CodeSystem: BRSuplementoIntencaoRequisicao
Id: BRSuplementoIntencaoRequisicao
Title: "Suplemento pt-BR: request-intent"
Description: "Designações em português do Brasil para http://hl7.org/fhir/request-intent (uso: CarePlan.intent). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoIntencaoRequisicao, http://hl7.org/fhir/request-intent)
* #proposal "Proposal"
* #proposal ^designation[+].language = #pt-BR
* #proposal ^designation[=].use = $designation-usage#display
* #proposal ^designation[=].value = "Proposta"
* #plan "Plan"
* #plan ^designation[+].language = #pt-BR
* #plan ^designation[=].use = $designation-usage#display
* #plan ^designation[=].value = "Plano"
* #directive "Directive"
* #directive ^designation[+].language = #pt-BR
* #directive ^designation[=].use = $designation-usage#display
* #directive ^designation[=].value = "Diretiva"
* #order "Order"
* #order ^designation[+].language = #pt-BR
* #order ^designation[=].use = $designation-usage#display
* #order ^designation[=].value = "Ordem"
* #original-order "Original Order"
* #original-order ^designation[+].language = #pt-BR
* #original-order ^designation[=].use = $designation-usage#display
* #original-order ^designation[=].value = "Ordem original"
* #reflex-order "Reflex Order"
* #reflex-order ^designation[+].language = #pt-BR
* #reflex-order ^designation[=].use = $designation-usage#display
* #reflex-order ^designation[=].value = "Ordem reflexa"
* #filler-order "Filler Order"
* #filler-order ^designation[+].language = #pt-BR
* #filler-order ^designation[=].use = $designation-usage#display
* #filler-order ^designation[=].value = "Ordem do executante"
* #instance-order "Instance Order"
* #instance-order ^designation[+].language = #pt-BR
* #instance-order ^designation[=].use = $designation-usage#display
* #instance-order ^designation[=].value = "Ordem de instância"
* #option "Option"
* #option ^designation[+].language = #pt-BR
* #option ^designation[=].use = $designation-usage#display
* #option ^designation[=].value = "Opção"

CodeSystem: BRSuplementoSituacaoAtividadePlano
Id: BRSuplementoSituacaoAtividadePlano
Title: "Suplemento pt-BR: care-plan-activity-status"
Description: "Designações em português do Brasil para http://hl7.org/fhir/care-plan-activity-status (uso: CarePlan.activity.detail.status). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoSituacaoAtividadePlano, http://hl7.org/fhir/care-plan-activity-status)
* #not-started "Not Started"
* #not-started ^designation[+].language = #pt-BR
* #not-started ^designation[=].use = $designation-usage#display
* #not-started ^designation[=].value = "Não iniciada"
* #scheduled "Scheduled"
* #scheduled ^designation[+].language = #pt-BR
* #scheduled ^designation[=].use = $designation-usage#display
* #scheduled ^designation[=].value = "Agendada"
* #in-progress "In Progress"
* #in-progress ^designation[+].language = #pt-BR
* #in-progress ^designation[=].use = $designation-usage#display
* #in-progress ^designation[=].value = "Em andamento"
* #on-hold "On Hold"
* #on-hold ^designation[+].language = #pt-BR
* #on-hold ^designation[=].use = $designation-usage#display
* #on-hold ^designation[=].value = "Suspensa"
* #completed "Completed"
* #completed ^designation[+].language = #pt-BR
* #completed ^designation[=].use = $designation-usage#display
* #completed ^designation[=].value = "Concluída"
* #cancelled "Cancelled"
* #cancelled ^designation[+].language = #pt-BR
* #cancelled ^designation[=].use = $designation-usage#display
* #cancelled ^designation[=].value = "Cancelada"
* #stopped "Stopped"
* #stopped ^designation[+].language = #pt-BR
* #stopped ^designation[=].use = $designation-usage#display
* #stopped ^designation[=].value = "Interrompida"
* #unknown "Unknown"
* #unknown ^designation[+].language = #pt-BR
* #unknown ^designation[=].use = $designation-usage#display
* #unknown ^designation[=].value = "Desconhecida"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrada por erro"

CodeSystem: BRSuplementoSituacaoDocumento
Id: BRSuplementoSituacaoDocumento
Title: "Suplemento pt-BR: composition-status"
Description: "Designações em português do Brasil para http://hl7.org/fhir/composition-status (uso: Composition.status). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoSituacaoDocumento, http://hl7.org/fhir/composition-status)
* #preliminary "Preliminary"
* #preliminary ^designation[+].language = #pt-BR
* #preliminary ^designation[=].use = $designation-usage#display
* #preliminary ^designation[=].value = "Preliminar"
* #final "Final"
* #final ^designation[+].language = #pt-BR
* #final ^designation[=].use = $designation-usage#display
* #final ^designation[=].value = "Final"
* #amended "Amended"
* #amended ^designation[+].language = #pt-BR
* #amended ^designation[=].use = $designation-usage#display
* #amended ^designation[=].value = "Retificado"
* #entered-in-error "Entered in Error"
* #entered-in-error ^designation[+].language = #pt-BR
* #entered-in-error ^designation[=].use = $designation-usage#display
* #entered-in-error ^designation[=].value = "Registrado por erro"

CodeSystem: BRSuplementoMotivoSecaoVazia
Id: BRSuplementoMotivoSecaoVazia
Title: "Suplemento pt-BR: list-empty-reason"
Description: "Designações em português do Brasil para http://terminology.hl7.org/CodeSystem/list-empty-reason (uso: Composition.section.emptyReason). Não cria códigos novos."
* insert SuplementoPtBr(BRSuplementoMotivoSecaoVazia, http://terminology.hl7.org/CodeSystem/list-empty-reason)
* #nilknown "Nil Known"
* #nilknown ^designation[+].language = #pt-BR
* #nilknown ^designation[=].use = $designation-usage#display
* #nilknown ^designation[=].value = "Nada conhecido"
* #notasked "Not Asked"
* #notasked ^designation[+].language = #pt-BR
* #notasked ^designation[=].use = $designation-usage#display
* #notasked ^designation[=].value = "Não perguntado"
* #withheld "Information Withheld"
* #withheld ^designation[+].language = #pt-BR
* #withheld ^designation[=].use = $designation-usage#display
* #withheld ^designation[=].value = "Informação retida"
* #unavailable "Unavailable"
* #unavailable ^designation[+].language = #pt-BR
* #unavailable ^designation[=].use = $designation-usage#display
* #unavailable ^designation[=].value = "Indisponível"
* #notstarted "Not Started"
* #notstarted ^designation[+].language = #pt-BR
* #notstarted ^designation[=].use = $designation-usage#display
* #notstarted ^designation[=].value = "Não iniciado"
* #closed "Closed"
* #closed ^designation[+].language = #pt-BR
* #closed ^designation[=].use = $designation-usage#display
* #closed ^designation[=].value = "Encerrado"
