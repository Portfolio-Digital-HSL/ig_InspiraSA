// Perfil RNDS do contato assistencial da internação (BRInternacao).
// Deriva do br-core-encounter.
// Autoria: Jussara Macedo Pinho Rötzsch.

Profile: BRInternacao
Parent: br-core-encounter
Id: BRInternacao
Title: "BRInternacao: Internação (Sumário de Alta)"
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
