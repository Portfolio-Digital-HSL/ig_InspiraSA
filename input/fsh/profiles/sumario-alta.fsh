Invariant: sa-1
Description: "Cada seção DEVE ter entradas ou informar o motivo de estar vazia (emptyReason)."
Expression: "entry.exists() or emptyReason.exists()"
Severity: #error

Invariant: sa-2
Description: "O Sumário de Alta DEVE referenciar uma internação encerrada."
Expression: "encounter.exists()"
Severity: #error

RuleSet: SecaoSA(fatia, codigo, titulo, perfil)
* section contains {fatia} 1..1 MS
* section[{fatia}] obeys sa-1
* section[{fatia}].title 1..1 MS
* section[{fatia}].title ^short = "{titulo}"
* section[{fatia}].code 1..1 MS
* section[{fatia}].code = $loinc#{codigo}
* section[{fatia}].text MS
* section[{fatia}].entry MS
* section[{fatia}].entry only Reference({perfil})
* section[{fatia}].emptyReason MS
* section[{fatia}].emptyReason ^comment = "Use list-empty-reason (nilknown, notasked, unavailable...). Substitui a seção vazia sem justificativa do SA-IG."

Profile: SumarioAlta
Parent: br-core-composition
Id: sumario-alta
Title: "Sumário de Alta"
Description: "Documento clínico emitido na alta hospitalar. Reproduz as sete seções do br-core-sumarioalta sobre o br-core-composition e substitui o perfil BRSumarioAlta do SA-IG legado. O resumo da evolução clínica, o contato assistencial e as informações adicionais deixam de ser seções e passam para a Internação (Composition.encounter)."
* ^status = #draft
* ^experimental = true
* obeys sa-2
* ^purpose = "Pai provisório: br-core-composition. O br-core-sumarioalta 1.3.0 não admite nenhuma instância válida (fatiamento de section por discriminador profile em code e sistema LOINC fixado como https://loinc.org/; ver débitos técnicos D-01 e D-02). Quando o BR-Core corrigir, basta trocar o Parent para br-core-sumarioalta."
* category 0..1
* section 7..7
* section ^slicing.discriminator.type = #pattern
* section ^slicing.discriminator.path = "code"
* section ^slicing.rules = #open
* section ^slicing.description = "Sete seções do br-core-sumarioalta, identificadas pelo código LOINC."
* identifier MS
* status MS
* status ^comment = "final na emissão; amended para retificação (com relatesTo); entered-in-error para anulação."
* type MS
* type = $loinc#18842-5 "Discharge summary"
* subject 1..1 MS
* encounter 1..1 MS
* encounter only Reference(InternacaoSumarioAlta)
* encounter ^comment = "Substitui as seções informacoesContatoAssistencial e informacoesAdicionais e o resumo da evolução clínica (ClinicalImpression) do SA-IG."
* date MS
* author 1..* MS
* title MS
* confidentiality MS
* attester MS
* custodian 1..1 MS
* custodian ^comment = "Estabelecimento (CNES) responsável pela guarda do documento."
* relatesTo MS
* insert SecaoSA(diagnosticosAdmissao, 42347-5, Diagnósticos da admissão, DiagnosticoSumarioAlta)
* insert SecaoSA(alergiasIntolerancias, 48765-2, Alergias e intolerâncias, AlergiaSumarioAlta)
* insert SecaoSA(diagnosticosAvaliados, 57852-6, Diagnósticos avaliados na internação, DiagnosticoSumarioAlta)
* insert SecaoSA(procedimentosRealizados, 47519-4, Procedimentos realizados, ProcedimentoSumarioAlta)
* insert SecaoSA(prescricaoAlta, 8654-6, Prescrição de alta, PrescricaoAltaSumarioAlta)
* insert SecaoSA(planoCuidados, 18776-5, Plano de cuidados, PlanoCuidadosSumarioAlta)
* insert SecaoSA(capacidadeFuncional, 54522-8, Capacidade funcional, br-core-capacidadefuncional)
* insert TraducaoPtBrSumarioAlta
