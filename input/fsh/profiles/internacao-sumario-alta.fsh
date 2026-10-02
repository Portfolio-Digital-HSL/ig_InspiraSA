Invariant: isa-1
Description: "A internação do Sumário de Alta DEVE ter data de alta (period.end)."
Expression: "period.end.exists()"
Severity: #error

Profile: InternacaoSumarioAlta
Parent: br-core-encounter
Id: internacao-sumario-alta
Title: "Internação do Sumário de Alta"
Description: "Internação a que o Sumário de Alta se refere. Concentra o que no SA-IG estava em seções próprias: período, caráter, procedência, desfecho da alta, diagnósticos com papel (admissão, alta), profissional da alta e o resumo da evolução clínica (Encounter.text)."
* ^status = #draft
* ^experimental = true
* obeys isa-1
* text MS
* text ^short = "Resumo da evolução clínica"
* text ^comment = "Substitui o perfil ClinicalImpression (resumoEvolucaoClinica) do SA-IG. Texto livre, narrativa XHTML."
* identifier MS
* status = #finished
* status MS
* class MS
* class = $v3-ActCode#IMP
* priority MS
* subject MS
* participant MS
* participant.type MS
* participant.type ^comment = "Use BRResponsabilidadeParticipante: alta, admissao, atendimento. Substitui o BRIdentificacaoEquipe do SA-IG."
* participant.individual MS
* period MS
* period.start 1..1 MS
* period.end 1..1 MS
* reasonCode MS
* diagnosis MS
* diagnosis.condition MS
* diagnosis.use MS
* diagnosis.use ^comment = "AD (admissão), DD (alta), CC (comorbidade) do diagnosis-role."
* hospitalization 1..1 MS
* hospitalization.admitSource MS
* hospitalization.dischargeDisposition MS
* hospitalization.destination MS
* serviceProvider MS
* insert TraducaoPtBrInternacaoSumarioAlta
