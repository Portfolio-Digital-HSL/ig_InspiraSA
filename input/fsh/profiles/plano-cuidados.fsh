Profile: PlanoCuidadosSumarioAlta
Parent: br-core-careplan
Id: plano-cuidados-sumario-alta
Title: "Plano de Cuidados pós-alta"
Description: "Orientações e acompanhamento programados para depois da alta. Diferente do SA-IG, permite activity (o BR-Core a exige)."
* ^status = #draft
* ^experimental = true
* status MS
* intent = #plan
* intent MS
* description MS
* subject MS
* encounter MS
* period MS
* activity MS
* activity.detail.code MS
* activity.detail.status MS
* activity.detail.scheduled[x] MS
* activity.detail.description MS
* insert TraducaoPtBrPlanoCuidadosSumarioAlta
