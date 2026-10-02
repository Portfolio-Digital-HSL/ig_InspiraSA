Profile: ProcedimentoSumarioAlta
Parent: br-core-procedure
Id: procedimento-sumario-alta
Title: "Procedimento do Sumário de Alta"
Description: "Procedimento realizado na internação. Código da Tabela SUS (SIGTAP), TUSS ou CBHPM. A função do executante usa performer-role (SNOMED CT), não CBO."
* ^status = #draft
* ^experimental = true
* status MS
* code MS
* code from $BRProcedimentosSUSSaudeSuplementar-vs (extensible)
* subject MS
* encounter MS
* performed[x] 1..1 MS
* performer MS
* performer.function MS
* performer.function from $performer-role-vs (preferred)
* performer.actor MS
* insert TraducaoPtBrProcedimentoSumarioAlta
