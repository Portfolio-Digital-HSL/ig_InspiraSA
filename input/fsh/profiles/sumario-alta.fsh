Invariant: sa-1
Description: "Cada seção DEVE ter entradas ou informar o motivo de estar vazia (emptyReason)."
Expression: "entry.exists() or emptyReason.exists()"
Severity: #error

Invariant: sa-2
Description: "O Sumário de Alta DEVE referenciar uma internação encerrada."
Expression: "encounter.exists()"
Severity: #error

RuleSet: SecaoSA(fatia, codigo, titulo, perfil)
* section[{fatia}] MS
* section[{fatia}] obeys sa-1
* section[{fatia}].title 1..1 MS
* section[{fatia}].title ^short = "{titulo}"
* section[{fatia}].code 1..1 MS
* section[{fatia}].code.coding 1..1 MS
* section[{fatia}].code.coding.code 1..1 MS
* section[{fatia}].code.coding.code = #{codigo}
* section[{fatia}].text MS
* section[{fatia}].entry MS
* section[{fatia}].entry only Reference({perfil})
* section[{fatia}].emptyReason MS
* section[{fatia}].emptyReason ^comment = "Use list-empty-reason (nilknown, notasked, unavailable...). Substitui a seção vazia sem justificativa do SA-IG."

Profile: SumarioAlta
Parent: br-core-sumarioalta
Id: sumario-alta
Title: "Sumário de Alta"
Description: "Documento clínico emitido na alta hospitalar. Deriva do br-core-sumarioalta (que deriva do br-core-composition) e substitui o perfil BRSumarioAlta do SA-IG legado. O resumo da evolução clínica, o contato assistencial e as informações adicionais deixam de ser seções e passam para a Internação (Composition.encounter)."
* ^status = #draft
* ^experimental = true
* obeys sa-2
* ^purpose = "Substitui o BRSumarioAlta do SA-IG, que deriva do BRConjuntoMinimoDados e não do BR-Core. Herda do br-core-sumarioalta 1.3.0 as sete seções e os dois defeitos que hoje impedem qualquer instância válida: discriminador profile em section.code e sistema LOINC fixado como https://loinc.org/ (débitos D-01 e D-02). Os exemplos seguem o pai e só validam quando o BR-Core corrigir."
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
