# Débitos técnicos

Débitos identificados no `BRSumarioAlta` do SA-IG, incluindo os que ele herdava do `BRConjuntoMinimoDados` (CMD), e a correção feita neste guia. O `BRSumarioAlta` mantém o nome e passa a derivar do `br-core-composition`; os recursos do documento usam os perfis de base do BR-Core.

Grau: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; **Médio** gera ambiguidade; **Baixo** é ajuste de documentação.

| # | Débito no BRSumarioAlta | Grau | Correção feita |
|---|---|---|---|
| DT-01 | SA-IG com canonical próprio, sem `dependsOn` do BR-Core: não herda nenhuma evolução | Alto | Dependência do BR-Core 1.3.0. O documento é o `BRSumarioAlta`, sobre o `br-core-composition`; os recursos usam os perfis de base do BR-Core; nenhuma herança do CMD |
| DT-02 | `Composition.encounter` zerado e reimplementado como seção informacoesContatoAssistencial | Alto | `Composition.encounter` preenchido; seção eliminada |
| DT-03 | Resumo da evolução em ClinicalImpression só para texto livre | Alto | `Encounter.text` |
| DT-04 | Uma seção para diagnósticos de admissão e avaliados | Médio | Duas seções (42347-5 e 57852-6) |
| DT-05 | Composition intermediária BRRegistroPrescricaoMedicamento | Alto | seção aponta direto para MedicationRequest |
| DT-06 | Medicamento em CodeableConcept de texto livre (BRPrescricaoNaoEstruturada) | Médio | br-core-medication; não estruturado em `Medication.code.text` |
| DT-07 | Extensões BRTurno e BRIntervaloDoses | Médio | `Timing.repeat.when` e `period`/`periodUnit` |
| DT-08 | Extensão unidentifiedPatient em todos os perfis clínicos | Médio | br-core-patient sempre (ver AC-03) |
| DT-09 | Extensão BRIdentificacaoEquipe | Alto | `Encounter.participant`, `Procedure.performer` ou CareTeam |
| DT-10 | `Procedure.performer.function` com CBO | Alto | performer-role (SNOMED CT) |
| DT-11 | `Procedure.identifier` com número de autorização (type AUTH) | Médio | autorização na camada financeira (Claim/ClaimResponse, ver InspiraRIRA) |
| DT-12 | CodeSystems nacionais que traduzem os status do HL7 (binding required no R4) | Alto | ValueSets do HL7 (já no BR-Core) + 17 suplementos pt-BR |
| DT-13 | URLs `www.saude.gov.br/fhir/r4` não resolvíveis | Alto | URLs `terminologia.saude.gov.br` |
| DT-14 | Manifestação MedDRA required, máximo 1 | Alto | SNOMED CT, MedDRA aceito e ConceptMap |
| DT-15 | CarePlan só com description (activity e goal zerados) | Alto | activity estruturada (BR-Core) |
| DT-16 | Capacidade funcional 0..1 e perfil incompleto | Alto | seção 1..1 no `BRSumarioAlta`, entradas `br-core-capacidadefuncional` |
| DT-17 | Seção informacoesAdicionais (BROutrasInformacoes) | Baixo | Encounter |
| DT-18 | Versões incoerentes (01.10, 2.0, 2.1.0, 1.0...) e histórico de 3 commits no SA-IG | Baixo | SemVer 0.1.0, controle no git |
| DT-19 | Restrição de `note` a 0..1 e de `onset[x]` a dateTime no SA-IG | Baixo | não restringido; decisão de negócio a documentar |
| DT-20 | CMD (BRConjuntoMinimoDados-1.1) proíbe `identifier`, `attester`, `custodian`, `confidentiality` e `event` na Composition: documento sem identificador, sem atestação e sem custodiante | Alto | `BRSumarioAlta` (sobre `br-core-composition`) + `clinical-document-composition`: identifier, atestador legal e custodian (CNES) |
| DT-21 | CMD fixa `title` em "Conjunto Mínimo de Dados", também no Sumário de Alta | Médio | Título livre |
| DT-22 | CMD usa `category` para a modalidade assistencial (BRModalidadeAssistencial, required, 1..1) | Médio | Modalidade no Encounter; `category` = LOINC 107903-7 Clinical note |
| DT-23 | CMD proíbe `subject.reference` e `author.reference`: paciente e autor só por identificador | Alto | Referência a br-core-patient e br-core-practitioner |
| DT-24 | SA-IG proíbe `section.code`, `section.text` e `emptyReason` em todas as seções: sem código, sem narrativa atestável, sem justificativa de seção vazia. No `BRSumarioAlta`, seção sem `code` não casa com nenhuma fatia | Bloqueante | Código LOINC, narrativa e emptyReason em toda seção |
| DT-25 | SA-IG fatia as seções por perfil em `entry.resolve()`, com uma entrada por seção e seções repetidas; a seção de procedimentos é obrigatória (1..*), o que o comparativo anterior não registrou | Médio | Uma seção por tipo, com várias entradas (7..7 no `BRSumarioAlta`) |

Achados no BR-Core e em outros artefatos, fora do `BRSumarioAlta`, estão em [Recomendações à RNDS](recomendacoes-rnds.html#achados-no-br-core-e-em-outros-artefatos).
