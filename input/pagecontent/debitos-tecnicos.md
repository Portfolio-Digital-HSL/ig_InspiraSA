# Débitos técnicos

Achados do comparativo SA-IG x BR-Core x FHIR R4 e da construção deste guia, com o tratamento dado aqui. Grau: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; **Médio** gera ambiguidade; **Baixo** é ajuste de documentação.

## BR-Core 1.3.0 (encontrados na construção)

| # | Débito | Grau | Tratamento neste guia |
|---|---|---|---|
| D-01 | `br-core-sumarioalta` fatia `section` com discriminador `profile` em `code`. `code` não tem perfil, então toda seção casa com todas as fatias e o validador acusa "matches more than one slice" e falta das sete seções obrigatórias | Bloqueante | `SumarioAlta` sobre `br-core-composition`, com discriminador `pattern` em `code` e as mesmas sete fatias |
| D-02 | `section.code.coding.system` fixado em `https://loinc.org/`. O sistema LOINC é `http://loinc.org`, e o binding required `doc-section-codes` rejeita o valor fixado. Nenhum código de seção passa nos dois testes | Bloqueante | Código de seção com `http://loinc.org` |
| D-03 | `br-core-patient` exige CPF (`identifier:cpf` 1..1). Paciente não identificado, recém-nascido ou estrangeiro sem CPF não tem como ser registrado, e a substituição do `unidentifiedPatient` por CNS provisório fica impossível | Alto | Exemplos com CPF. Levar ao BR-Core: CPF 0..1 com invariante "CPF ou CNS" |
| D-04 | `br-core-capacidadefuncional`: `code` required a `BRTerminologiaSuspeitaDiagnostica` (CID-10), `category` required a `BRCategoriaDiagnostico` (principal/secundário), `subject.identifier` 1..1 duplicando a referência e `stage` 1..1. CID-10 não descreve funcionalidade (CIF ou SNOMED CT descrevem), e a categoria nacional contradiz o binding extensible `condition-category` (aviso) | Alto | Perfil usado sem especialização; exemplo com Z74.0 e `stage.summary` em texto |
| D-05 | `br-core-medicationrequest`: `dosageInstruction` 0..1. Posologia com dose de ataque e manutenção ou dose variável por horário exige um MedicationRequest por fase | Alto | 1..1, documentado |
| D-06 | `AllergyIntolerance.code` required a `BRAlergenos`, que não tem SNOMED CT. O CBARA usa SNOMED CT, mas `BRAlergenosCBARA` no guia de terminologia tem um único código (`veneno-vespa`), que não é SNOMED | Alto | Fatia `code.coding[snomed]` (preferred BRAlergenosSNOMEDNacional) mais um coding de BRAlergenos |
| D-07 | `br-core-medicationrequest`: binding herdado na fatia `medicationReference` (tipo só Reference). O validador acusa erro de perfil ("binding but no bindable types") no próprio BR-Core e em qualquer derivado que restrinja o tipo | Médio | Restrição a Reference por invariante (pa-1), não por `only` |
| D-08 | `BRProcedimentosNacionais` enumera parte da TUSS 22 e não tem SIGTAP; na RNDS o mesmo nome designa SIGTAP | Alto | Novo `BRProcedimentosSUSSaudeSuplementar` (SIGTAP + TUSS 22). CBHPM fora: é da AMB, licenciada e paga, e não está no OCL |
| D-09 | `dosageInstruction.route` e `reaction.exposureRoute` ligam ao ValueSet do IPS, que não é dependência do pacote BR-Core: o ValueSet não resolve e o IG Publisher acusa 2 erros nos perfis derivados | Médio | Herdado; exemplo com EDQM 20053000. Os 2 erros do QA deste guia são este |
| D-10 | `br-core-encounter` usa a extensão `additional-binding` sem dependência do pacote de ferramentas e com `value[x]` e extensões juntos (ext-1) | Baixo | Herdado; erro só na validação do perfil |
| D-11 | `Encounter.participant.type` extensible a `BRResponsabilidadeParticipante`, fora do ValueSet base do R4 (aviso em todo Encounter) | Baixo | Herdado |

## Do comparativo SA-IG x BR-Core

| # | Débito | Grau | Tratamento neste guia |
|---|---|---|---|
| D-12 | SA-IG com canonical próprio, sem `dependsOn` do BR-Core: não herda nenhuma evolução | Alto | Dependência do BR-Core 1.3.0; todos os perfis derivam dele |
| D-13 | `Composition.encounter` zerado e reimplementado como seção informacoesContatoAssistencial | Alto | `encounter` 1..1; seção eliminada |
| D-14 | Resumo da evolução em ClinicalImpression só para texto livre | Alto | `Encounter.text` |
| D-15 | Uma seção para diagnósticos de admissão e avaliados | Médio | Duas seções (42347-5 e 57852-6) |
| D-16 | Composition intermediária BRRegistroPrescricaoMedicamento | Alto | seção aponta direto para MedicationRequest |
| D-17 | Medicamento em CodeableConcept de texto livre (BRPrescricaoNaoEstruturada) | Médio | br-core-medication; não estruturado em `Medication.code.text` |
| D-18 | Extensões BRTurno e BRIntervaloDoses | Médio | `Timing.repeat.when` e `period`/`periodUnit` |
| D-19 | Extensão unidentifiedPatient em todos os perfis clínicos | Médio | br-core-patient sempre (ver D-03) |
| D-20 | Extensão BRIdentificacaoEquipe | Alto | `Encounter.participant`, `Procedure.performer` ou CareTeam |
| D-21 | `Procedure.performer.function` com CBO | Alto | performer-role (SNOMED CT) |
| D-22 | `Procedure.identifier` com número de autorização (type AUTH) | Médio | autorização na camada financeira (Claim/ClaimResponse, ver InspiraRIRA) |
| D-23 | CodeSystems nacionais que traduzem os status do HL7 (binding required no R4) | Alto | ValueSets do HL7 + 17 suplementos pt-BR |
| D-24 | URLs `www.saude.gov.br/fhir/r4` não resolvíveis | Alto | URLs `terminologia.saude.gov.br` |
| D-25 | Manifestação MedDRA required, máximo 1 | Alto | SNOMED CT preferred, 0..*, MedDRA aceito e ConceptMap |
| D-26 | CarePlan só com description (activity e goal zerados) | Alto | activity estruturada (BR-Core) |
| D-27 | Capacidade funcional 0..1 e perfil incompleto | Alto | seção 1..1 com br-core-capacidadefuncional |
| D-28 | Seção informacoesAdicionais (BROutrasInformacoes) | Baixo | Encounter |
| D-29 | Versões incoerentes (01.10, 2.0, 2.1.0, 1.0...) e histórico de 3 commits no SA-IG | Baixo | SemVer 0.1.0, controle no git |
| D-30 | Restrição de `note` a 0..1 e de `onset[x]` a dateTime no SA-IG | Baixo | não restringido; decisão de negócio a documentar |
