// GERADO por scripts/traducao_ptbr.py. Não edite à mão.
RuleSet: TraducaoPtBrPlanoCuidadosSumarioAlta
* . ^short = "Plano de Cuidados pós-alta"
* . ^definition = "Orientações e acompanhamento programados para depois da alta. Diferente do SA-IG, permite activity (o BR-Core a exige)."
* activity.detail.extension ^short = "Extensões adicionais"
* activity.detail.extension ^definition = "Extensões que acrescentam informação não prevista no modelo base."
* activity.detail.modifierExtension ^short = "Extensões que não podem ser ignoradas"
* activity.detail.doNotPerform ^short = "Não realizar"
* activity.detail.doNotPerform ^definition = "Indica que a ação NÃO deve ser realizada."
