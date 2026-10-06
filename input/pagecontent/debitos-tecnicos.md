# Débitos técnicos

Achados do comparativo SA-IG x BR-Core x FHIR R4 e da construção deste guia, com o tratamento dado aqui. O guia não cria perfis: onde o BR-Core falha, o tratamento é regra de preenchimento e proposta de mudança. Grau: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; **Médio** gera ambiguidade; **Baixo** é ajuste de documentação.

## BR-Core 1.3.0 (encontrados na construção)

| # | Débito | Grau | Tratamento neste guia |
|---|---|---|---|
| D-01 | `br-core-sumarioalta` fatia `section` com discriminador `profile` em `code`. `code` não tem perfil, então toda seção casa com todas as fatias e o validador acusa "matches more than one slice" e falta das sete seções obrigatórias | Bloqueante | Corrigido no BR-Core, branch `fix/sumarioalta-capacidadefuncional` (discriminador `pattern` em `code`; também em `br-core-registroatendimentoclinico`). Até a nova versão, os exemplos de Composition falham contra a 1.3.0 |
| D-02 | `section.code.coding.system` fixado em `https://loinc.org/`. O sistema LOINC é `http://loinc.org`, e o binding required `doc-section-codes` rejeita o valor fixado. Nenhum código de seção passa nos dois testes | Bloqueante | Corrigido no BR-Core, branch `fix/sumarioalta-capacidadefuncional`: alias `$loinc = http://loinc.org`, o mesmo canonical da Source LOINC no OCL (`RI/loinc`). Os exemplos seguem com `https://loinc.org/` enquanto a dependência for a 1.3.0 |
| D-03 | `br-core-patient` exige CPF (`identifier:cpf` 1..1). Paciente não identificado, recém-nascido ou estrangeiro sem CPF não tem como ser registrado, e a substituição do `unidentifiedPatient` por CNS provisório fica impossível | Alto | Exemplos com CPF. Levar ao BR-Core: CPF 0..1 com invariante "CPF ou CNS" |
| D-04 | `br-core-capacidadefuncional`: `code` required a `BRTerminologiaSuspeitaDiagnostica` (CID-10), `category` required a `BRCategoriaDiagnostico` (principal/secundário), `subject.identifier` 1..1 duplicando a referência e `stage` 1..1. CID-10 não descreve funcionalidade (CIF ou SNOMED CT descrevem), e a categoria nacional contradiz o binding extensible `condition-category` (aviso) | Alto | Corrigido no BR-Core, branch `fix/sumarioalta-capacidadefuncional`: `code` preferred BRCapacidadeFuncional (SNOMED CT Functional finding), CID-10/CIAP-2 como codificação adicional; `category` volta ao HL7; sem `subject.identifier` 1..1 nem `stage` 1..* |
| D-05 | `br-core-medicationrequest`: `dosageInstruction` 0..1. Posologia com dose de ataque e manutenção ou dose variável por horário exige um MedicationRequest por fase | Alto | Um MedicationRequest por fase; proposta ao BR-Core |
| D-06 | `AllergyIntolerance.code` required a `BRAlergenos`, que não tem SNOMED CT. No OCL, o `BRAlergenosCBARA` tem 152 códigos nacionais e 147 mapeamentos SAME-AS para SNOMED CT, todos com código e link de destino coerentes na Source gps (conferido em 05/10/2026). O antigo mapeamento 141 de `veneno-vespa`, que levava ao 260176001 Kiwi fruit, foi substituído pelo 298 (256440004 Wasp venom). Seis códigos não têm mapeamento: outro-agente-substancia, grama, lima, contato-metal, glutamato, grao. No guia de terminologia o CodeSystem é `not-present` e o `BRAlergenos` enumera só `veneno-vespa` | Alto | Regra de preenchimento: coding SNOMED CT ou CBARA mais um coding de BRAlergenos. Todos os 152 códigos mapeados no OCL em 06/10/2026, incluindo lima → 1285547006 (limão-taiti), contato-metal → 767098004 Metal and/or metal compound e grama → 422304003 Family Poaceae (contato com a planta; o SNOMED CT não tem substância Grass). Conferido em 06/10/2026: 153 mapeamentos ativos, todos com código e link coerentes na gps e sem destino repetido (etanolamina tem dois, SAME-AS para o grupo e BROADER-THAN para a substância). Antes, também no OCL (05/10/2026): grao → 264331002 Grain, glutamato → 430503006 Glutamate, outro-agente-substancia → 105590001 Substance, veneno-vespa → 256440004 (mapeamento 298), sepia → 726759005 Cuttlefish. Sem duplicidade de destino entre os 150 mapeamentos ativos |
| D-07 | `br-core-medicationrequest`: a fatia `medicationReference` herda o binding example que o R4 define em `medication[x]`; o validador acusa erro de perfil ("binding but no bindable types"). Não é regra do FSH do BR-Core: vem do snapshot | Médio | Regra de preenchimento: usar `medicationReference`; proposta ao BR-Core |
| D-08 | `BRProcedimentosNacionais` tem dois conteúdos para o mesmo canonical. No guia de terminologia, 1000 códigos da TUSS 22. No OCL (`MS/BRProcedimentosNacionais-1.0`), 11.035 referências: as 5.074 da BRTabelaSUS e 5.961 da TUSS 22, mas estas apontam para `/orgs/ans/sources/tuss-22/`, Source que não existe; a TUSS 22 está em `/orgs/ANS/sources/tabela-22/` (5.966 conceitos) | Alto | Nova versão do `BRProcedimentosNacionais`, mesmo nome e canonical: BRTabelaSUS + TUSS 22, sem BRCBHPMTUSS (CBHPM é da AMB, licenciada e paga). É o que o OCL já pretende; falta apontar as referências da TUSS para `ANS/tabela-22` e alinhar o guia de terminologia |
| D-09 | `dosageInstruction.route` e `reaction.exposureRoute` ligam ao ValueSet do IPS, que não é dependência do pacote BR-Core: o ValueSet não resolve e o validador não confere a via | Médio | Exemplo com EDQM 20053000 |
| D-10 | `br-core-encounter` usa a extensão `additional-binding` sem dependência do pacote de ferramentas e com `value[x]` e extensões juntos (ext-1) | Baixo | Erro só na validação do perfil |
| D-11 | `Encounter.participant.type` extensible a `BRResponsabilidadeParticipante`, fora do ValueSet base do R4 (aviso em todo Encounter) | Baixo | Aviso nos exemplos |

## Do comparativo SA-IG x BR-Core

| # | Débito | Grau | Tratamento neste guia |
|---|---|---|---|
| D-12 | SA-IG com canonical próprio, sem `dependsOn` do BR-Core: não herda nenhuma evolução | Alto | Dependência do BR-Core 1.3.0; usa os perfis dele, sem perfis próprios |
| D-13 | `Composition.encounter` zerado e reimplementado como seção informacoesContatoAssistencial | Alto | `Composition.encounter` preenchido; seção eliminada |
| D-14 | Resumo da evolução em ClinicalImpression só para texto livre | Alto | `Encounter.text` |
| D-15 | Uma seção para diagnósticos de admissão e avaliados | Médio | Duas seções (42347-5 e 57852-6) |
| D-16 | Composition intermediária BRRegistroPrescricaoMedicamento | Alto | seção aponta direto para MedicationRequest |
| D-17 | Medicamento em CodeableConcept de texto livre (BRPrescricaoNaoEstruturada) | Médio | br-core-medication; não estruturado em `Medication.code.text` |
| D-18 | Extensões BRTurno e BRIntervaloDoses | Médio | `Timing.repeat.when` e `period`/`periodUnit` |
| D-19 | Extensão unidentifiedPatient em todos os perfis clínicos | Médio | br-core-patient sempre (ver D-03) |
| D-20 | Extensão BRIdentificacaoEquipe | Alto | `Encounter.participant`, `Procedure.performer` ou CareTeam |
| D-21 | `Procedure.performer.function` com CBO | Alto | performer-role (SNOMED CT) |
| D-22 | `Procedure.identifier` com número de autorização (type AUTH) | Médio | autorização na camada financeira (Claim/ClaimResponse, ver InspiraRIRA) |
| D-23 | CodeSystems nacionais que traduzem os status do HL7 (binding required no R4) | Alto | ValueSets do HL7 (já no BR-Core) + 17 suplementos pt-BR |
| D-24 | URLs `www.saude.gov.br/fhir/r4` não resolvíveis | Alto | URLs `terminologia.saude.gov.br` |
| D-25 | Manifestação MedDRA required, máximo 1 | Alto | SNOMED CT, MedDRA aceito e ConceptMap |
| D-26 | CarePlan só com description (activity e goal zerados) | Alto | activity estruturada (BR-Core) |
| D-27 | Capacidade funcional 0..1 e perfil incompleto | Alto | seção 1..1 com br-core-capacidadefuncional (BR-Core) |
| D-28 | Seção informacoesAdicionais (BROutrasInformacoes) | Baixo | Encounter |
| D-29 | Versões incoerentes (01.10, 2.0, 2.1.0, 1.0...) e histórico de 3 commits no SA-IG | Baixo | SemVer 0.1.0, controle no git |
| D-30 | Restrição de `note` a 0..1 e de `onset[x]` a dateTime no SA-IG | Baixo | não restringido; decisão de negócio a documentar |
