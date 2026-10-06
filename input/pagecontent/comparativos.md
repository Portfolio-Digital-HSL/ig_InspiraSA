# Comparativos

Duas planilhas sustentam as decisões deste guia.

| Planilha | Conteúdo |
|---|---|
| `comparativo_sa.xlsx` (repositório sa-ig, pasta `Claude outputs`) | Seções do SA-IG × br-core-sumarioalta, cinco recursos clínicos (Condition, AllergyIntolerance, Procedure, MedicationRequest, CarePlan) elemento a elemento e inventário dos 24 perfis do SA-IG. Fonte: JSON do SA-IG e FSH do BR-Core. |
| `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx` (este repositório) | Duas camadas: BRConjuntoMinimoDados × br-core-composition e BRSumarioAlta × br-core-sumarioalta, elemento a elemento, com FHIR R4, BR-Core 1.3.0, BR-Core corrigido e a origem de cada restrição. Inclui o cotejo com a planilha anterior. Fonte: snapshots. |

## Herança

| Modelo | Cadeia |
|---|---|
| SA-IG da RNDS | BRSumarioAlta → BRConjuntoMinimoDados-1.1 (CMD) → Composition |
| BR-Core | br-core-sumarioalta → br-core-composition → Composition |
| Este guia | br-core-sumarioalta (sem perfil próprio) → br-core-composition → Composition; documento em br-core-bundle-documento (proposto) ou clinical-document-bundle |

## Resultado

- **Documento-base (CMD × br-core-composition):** o status não é conforme (ValueSet nacional onde o R4 é required). Quase todas as restrições do cabeçalho do SA-IG vêm do CMD: identificador, atestação, custodiante e confidencialidade proibidos; título fixo; modalidade em `category`; paciente e autor só por identificador; seções sem `code` nem `text`.
- **Sumário de Alta (BRSumarioAlta × br-core-sumarioalta):** 2 elementos do cabeçalho e 7 subelementos de seção não conformes; 3 seções só no SA-IG (contato assistencial, resumo da evolução, informações adicionais).
- **Cotejo com a planilha anterior:** concordam na correspondência das seções; a anterior não registrou a obrigatoriedade das seções vinda do CMD, os elementos proibidos nas seções, o fatiamento por `entry.resolve()` nem os defeitos do br-core-sumarioalta (D-01, D-02), porque leu o differential e o FSH, não os snapshots.

Os débitos estão consolidados em [Débitos técnicos](debitos-tecnicos.html).
