# Débitos técnicos

Débitos identificados no `BRSumarioAlta` do SA-IG, incluindo os que ele herdava do `BRConjuntoMinimoDados` (CMD), e a correção feita neste guia. O `BRSumarioAlta` mantém o nome e passa a derivar do `br-core-composition`; os recursos do documento usam os perfis de base do BR-Core.

Grau: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; **Médio** gera ambiguidade; **Baixo** é ajuste de documentação.

| # | Débito no BRSumarioAlta | Grau | Correção feita |
|---|---|---|---|
| D-12 | SA-IG com canonical próprio, sem `dependsOn` do BR-Core: não herda nenhuma evolução | Alto | Dependência do BR-Core 1.3.0. O documento é o `BRSumarioAlta`, sobre o `br-core-composition`; os recursos usam os perfis de base do BR-Core; nenhuma herança do CMD |
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
| D-27 | Capacidade funcional 0..1 e perfil incompleto | Alto | seção 1..1 no `BRSumarioAlta`, entradas `br-core-capacidadefuncional` |
| D-28 | Seção informacoesAdicionais (BROutrasInformacoes) | Baixo | Encounter |
| D-29 | Versões incoerentes (01.10, 2.0, 2.1.0, 1.0...) e histórico de 3 commits no SA-IG | Baixo | SemVer 0.1.0, controle no git |
| D-30 | Restrição de `note` a 0..1 e de `onset[x]` a dateTime no SA-IG | Baixo | não restringido; decisão de negócio a documentar |
| D-31 | CMD (BRConjuntoMinimoDados-1.1) proíbe `identifier`, `attester`, `custodian`, `confidentiality` e `event` na Composition: documento sem identificador, sem atestação e sem custodiante | Alto | `BRSumarioAlta` (sobre `br-core-composition`) + `clinical-document-composition`: identifier, atestador legal e custodian (CNES) |
| D-32 | CMD fixa `title` em "Conjunto Mínimo de Dados", também no Sumário de Alta | Médio | Título livre |
| D-33 | CMD usa `category` para a modalidade assistencial (BRModalidadeAssistencial, required, 1..1) | Médio | Modalidade no Encounter; `category` = LOINC 107903-7 Clinical note |
| D-34 | CMD proíbe `subject.reference` e `author.reference`: paciente e autor só por identificador | Alto | Referência a br-core-patient e br-core-practitioner |
| D-35 | SA-IG proíbe `section.code`, `section.text` e `emptyReason` em todas as seções: sem código, sem narrativa atestável, sem justificativa de seção vazia. No `BRSumarioAlta`, seção sem `code` não casa com nenhuma fatia | Bloqueante | Código LOINC, narrativa e emptyReason em toda seção |
| D-36 | SA-IG fatia as seções por perfil em `entry.resolve()`, com uma entrada por seção e seções repetidas; a seção de procedimentos é obrigatória (1..*), o que o comparativo anterior não registrou | Médio | Uma seção por tipo, com várias entradas (7..7 no `BRSumarioAlta`) |

Achados no BR-Core e em outros artefatos, fora do `BRSumarioAlta`, estão em [Recomendações à RNDS](recomendacoes-rnds.html#achados-no-br-core-e-em-outros-artefatos).
