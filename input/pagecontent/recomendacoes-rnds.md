# Recomendações à RNDS

1. **Publicar a nova versão do pacote BR-Core** com o que já está no `main` do repositório br.org.hl7.fhir.core (HL7-BR): `br-core-sumarioalta` e `br-core-registroatendimentoclinico` retirados (documentos são casos de uso da RNDS), LOINC `http://loinc.org`, `br-core-capacidadefuncional` revisto (AC-04) e o novo `br-core-bundle-documento`. O binding de `section.code` volta a example, como no IPS, com os códigos de seção do IPS onde o IPS tem a seção (AC-14). Com a correção, os exemplos deste guia validam sem erro também contra o `clinical-document-composition`.
2. **A RNDS se ajusta ao BR-Core nos recursos e é dona dos documentos.** Documentos normatizados (Sumário de Alta, RAC, RIA) como perfis da RNDS sobre o `br-core-composition`; os recursos pelos perfis do BR-Core; onde não houver perfil BR-Core, o FHIR Clinical Documents e, na falta dele, o recurso canônico do FHIR R4. Perfis RNDS sempre derivados do BR-Core (`BRSumarioAlta`, `rnds-internacao`, `rnds-documento-sumarioalta`), sem elementos, extensões ou terminologias próprias, e uma declaração de capacidades do servidor. Abandonar o SA-IG (canonical `www.saude.gov.br/fhir/r4`, herança do CMD) e publicar o guia com `dependsOn` do pacote BR-Core.
3. **Usar elementos nativos**: `Composition.encounter` para o contato assistencial, `Encounter.text` para o resumo da evolução, `Timing` para turno e intervalo, `participant`/CareTeam para a equipe.
4. **Permitir paciente sem CPF** no br-core-patient (AC-03), com a regra "CPF ou CNS", para que o CNS provisório substitua a extensão unidentifiedPatient.
5. **Status do HL7 com tradução por suplemento.** Descontinuar os CodeSystems nacionais que copiam códigos do HL7 e publicar suplementos pt-BR no guia de terminologia.
6. **SNOMED CT para alergias e manifestações.** Incluir SNOMED CT (via CBARA) no BRAlergenos; publicar no guia de terminologia o CBARA do OCL (152 códigos, 147 com mapeamento para SNOMED CT) e o ConceptMap correspondente; ligar manifestações a SNOMED CT e publicar no guia de terminologia o mapa MedDRA–SNOMED CT que já está no OCL (Source MS/BRMedDRA).
7. **Publicar nova versão do `BRProcedimentosNacionais`** com BRTabelaSUS e TUSS 22 inteiras, sem o BRCBHPMTUSS (a CBHPM é da AMB e paga), e alinhar o conteúdo do guia de terminologia e do OCL.
8. **Revisar o `br-core-capacidadefuncional`** (AC-04): terminologia de funcionalidade (CIF ou SNOMED CT), categoria do HL7 e `subject` só por referência.
9. **Liberar mais de uma posologia** em `br-core-medicationrequest` (AC-05) e remover o binding da fatia `medicationReference` (AC-07).
I. **Dar hierarquia ao CBARA** no OCL e no guia de terminologia: tipo (cereal, leguminosa, metal, pólen, grão) como pai das substâncias, para que o tipo do modelo de informação seja derivado da substância e não enviado em paralelo.
12. **Descontinuar o CMD como base de documentos.** As restrições do BRConjuntoMinimoDados (documento sem identificador, sem atestação, sem narrativa, paciente e autor só por identificador) vão para todos os documentos que derivam dele. O ponto de partida é o br-core-composition.

## Mudanças propostas ao BR-Core

Regras que este guia hoje só consegue dar como orientação de preenchimento:

| Perfil | Mudança |
|---|---|
| br-core-sumarioalta, br-core-registroatendimentoclinico | retirados no `main` do BR-Core: documentos são casos de uso da RNDS (AC-16) |
| br-core-composition | binding de `section.code` example, como no R4 e no IPS (AC-14), feito no `main` |
| br-core-composition | compatibilidade declarada com o `clinical-document-composition` (FHIR Clinical Documents): categoria 107903-7 Clinical note, fatias de atestador legal e profissional, extensões de versão e destinatário |
| br-core-bundle-documento (novo) | criado no `main` do BR-Core: Bundle `document` com identifier, timestamp ≥ Composition.date, br-core-composition como primeira entrada e fullUrl em todas as entradas, nas regras do `clinical-document-bundle` |
| br-core-encounter | invariante "internação encerrada tem `period.end`" para uso no Sumário de Alta |
| br-core-allergyintolerance | incluir SNOMED CT no BRAlergenos; `reaction.manifestation` preferred SNOMED CT |
| br-core-procedure | `code` extensible ao BRProcedimentosNacionais; `performer.function` preferred performer-role |
| br-core-medicationrequest | `dosageInstruction` 0..*; sem binding na fatia `medicationReference` (AC-05, AC-07) |
| br-core-capacidadefuncional | feito no `main` do BR-Core |
| br-core-patient | CPF 0..1 com invariante "CPF ou CNS" (AC-03) |

## Terminologias propostas

Na pasta `terminologia/` deste repositório, para importação no OCL (org MS) e publicação no guia de terminologia:

- 17 suplementos pt-BR (ver [Terminologia](terminologia.html));
- ValueSets BRAlergenosSNOMEDNacional, BRManifestacaoReacaoSNOMED e nova versão do BRProcedimentosNacionais;
- ConceptMap BRMedDRAParaSNOMED.

## Perfis e extensões

Nenhuma extensão: tudo o que o SA-IG fazia com extensão tem elemento nativo. Três perfis RNDS, derivados do BR-Core e do FHIR Clinical Documents:

| Restrição | Perfil RNDS | Destino |
|---|---|---|
| Sete seções fatiadas pelo LOINC, com os perfis do BR-Core nas entradas | BRSumarioAlta | RNDS |
| `type` = LOINC 18842-5; `subject`, `encounter` e `custodian` 1..1 | BRSumarioAlta | RNDS |
| Seção com `entry` ou `emptyReason` (rnds-sa-2) | BRSumarioAlta | RNDS |
| `identifier` 1..1 com `system` e `value` | BRSumarioAlta | RNDS |
| `category` = LOINC 107903-7; conformidade ao `clinical-document-composition` | BRSumarioAlta | RNDS |
| Atestador legal com data e profissional (rnds-sa-1) | BRSumarioAlta | RNDS |
| Internação encerrada (`finished`, `IMP`), resumo da evolução em `text`, data da alta, `hospitalization`, profissional da alta (rnds-int-1) | rnds-internacao | RNDS |
| `identifier` e `timestamp`; Composition RNDS na primeira entrada (rnds-doc-1); `timestamp` ≥ `Composition.date` (rnds-doc-3) | rnds-documento-sumarioalta | RNDS (parent passa a `br-core-bundle-documento` quando publicado) |

## Achados no BR-Core e em outros artefatos

Encontrados na construção do guia, fora do `BRSumarioAlta`. Numerados como AC-nn; os débitos do `BRSumarioAlta` são DT-nn.

| # | Achado | Grau | Encaminhamento |
|---|---|---|---|
| AC-01 | `br-core-sumarioalta` fatia `section` com discriminador `profile` em `code`. `code` não tem perfil, então toda seção casa com todas as fatias e o validador acusa "matches more than one slice" e falta das sete seções obrigatórias | Bloqueante | Não afeta mais o guia: o `BRSumarioAlta` deriva do `br-core-composition` e fatia as seções por `pattern` em `code`. O `br-core-sumarioalta` e o `br-core-registroatendimentoclinico` foram retirados do `main` do BR-Core (AC-16) |
| AC-02 | `section.code.coding.system` fixado em `https://loinc.org/`. O binding de `section.code` é o ValueSet `doc-section-codes` (required no `br-core-composition` 1.3.0; example no R4, no IPS e no `main` do BR-Core, ver AC-14), cujos códigos são do CodeSystem LOINC, de canonical `http://loinc.org`. Com `https://loinc.org/` o código é de um sistema desconhecido e não pertence ao ValueSet. Nenhum código de seção passa nos dois testes | Bloqueante | Não afeta mais o guia: o `BRSumarioAlta` usa `http://loinc.org`, o mesmo canonical da Source LOINC no OCL (`RI/loinc`). O alias também foi corrigido no `main` do BR-Core |
| AC-03 | `br-core-patient` exige CPF (`identifier:cpf` 1..1). Paciente não identificado, recém-nascido ou estrangeiro sem CPF não tem como ser registrado, e a substituição do `unidentifiedPatient` por CNS provisório fica impossível | Alto | Exemplos com CPF. Levar ao BR-Core: CPF 0..1 com invariante "CPF ou CNS" |
| AC-04 | `br-core-capacidadefuncional`: `code` required a `BRTerminologiaSuspeitaDiagnostica` (CID-10), `category` required a `BRCategoriaDiagnostico` (principal/secundário), `subject.identifier` 1..1 duplicando a referência e `stage` 1..1. CID-10 não descreve funcionalidade (CIF ou SNOMED CT descrevem), e a categoria nacional contradiz o binding extensible `condition-category` (aviso) | Alto | Corrigido no `main` do BR-Core (HL7-BR, commit 9cf1bc9; aguarda nova versão do pacote): `code` preferred BRCapacidadeFuncional (SNOMED CT Functional finding), CID-10/CIAP-2 como codificação adicional; `category` volta ao HL7; sem `subject.identifier` 1..1 nem `stage` 1..* |
| AC-05 | `br-core-medicationrequest`: `dosageInstruction` 0..1. Posologia com dose de ataque e manutenção ou dose variável por horário exige um MedicationRequest por fase | Alto | Um MedicationRequest por fase; proposta ao BR-Core |
| AC-06 | `AllergyIntolerance.code` required a `BRAlergenos`, que não tem SNOMED CT. No OCL, o `BRAlergenosCBARA` tem 152 códigos nacionais e 147 mapeamentos SAME-AS para SNOMED CT, todos com código e link de destino coerentes na Source gps (conferido em 05/10/2026). O antigo mapeamento 141 de `veneno-vespa`, que levava ao 260176001 Kiwi fruit, foi substituído pelo 298 (256440004 Wasp venom). Seis códigos não têm mapeamento: outro-agente-substancia, grama, lima, contato-metal, glutamato, grao. No guia de terminologia o CodeSystem é `not-present` e o `BRAlergenos` enumera só `veneno-vespa` | Alto | Regra de preenchimento: coding SNOMED CT ou CBARA mais um coding de BRAlergenos. Todos os 152 códigos mapeados no OCL em 06/10/2026, incluindo lima → 1285547006 (limão-taiti), contato-metal → 767098004 Metal and/or metal compound e grama → 422304003 Family Poaceae (contato com a planta; o SNOMED CT não tem substância Grass). Conferido em 06/10/2026: 153 mapeamentos ativos, todos com código e link coerentes na gps e sem destino repetido (etanolamina tem dois, SAME-AS para o grupo e BROADER-THAN para a substância). Antes, também no OCL (05/10/2026): grao → 264331002 Grain, glutamato → 430503006 Glutamate, outro-agente-substancia → 105590001 Substance, veneno-vespa → 256440004 (mapeamento 298), sepia → 726759005 Cuttlefish. Sem duplicidade de destino entre os 150 mapeamentos ativos |
| AC-07 | `br-core-medicationrequest`: a fatia `medicationReference` herda o binding example que o R4 define em `medication[x]`; o validador acusa erro de perfil ("binding but no bindable types"). Não é regra do FSH do BR-Core: vem do snapshot | Médio | Regra de preenchimento: usar `medicationReference`; proposta ao BR-Core |
| AC-08 | `BRProcedimentosNacionais` tem dois conteúdos para o mesmo canonical. No guia de terminologia, 1000 códigos da TUSS 22. No OCL (`MS/BRProcedimentosNacionais-1.0`), 11.035 referências: as 5.074 da BRTabelaSUS e 5.961 da TUSS 22, mas estas apontam para `/orgs/ans/sources/tuss-22/`, Source que não existe; a TUSS 22 está em `/orgs/ANS/sources/tabela-22/` (5.966 conceitos) | Alto | Nova versão do `BRProcedimentosNacionais`, mesmo nome e canonical: BRTabelaSUS + TUSS 22, sem BRCBHPMTUSS (CBHPM é da AMB, licenciada e paga). É o que o OCL já pretende; falta apontar as referências da TUSS para `ANS/tabela-22` e alinhar o guia de terminologia |
| AC-09 | `dosageInstruction.route` e `reaction.exposureRoute` ligam ao ValueSet do IPS, que não é dependência do pacote BR-Core: o ValueSet não resolve e o validador não confere a via | Médio | Exemplo com EDQM 20053000 |
| AC-10 | `br-core-encounter` usa a extensão `additional-binding` sem dependência do pacote de ferramentas e com `value[x]` e extensões juntos (ext-1) | Baixo | Erro só na validação do perfil |
| AC-11 | `Encounter.participant.type` extensible a `BRResponsabilidadeParticipante`, fora do ValueSet base do R4 (aviso em todo Encounter) | Baixo | Aviso nos exemplos |
| AC-12 | CBARA mistura tipo e substância numa lista sem hierarquia (nenhum conceito pai no OCL) | Médio | Criar a hierarquia no OCL (ex.: `grao-soja` filho de `grao`, `niquel` filho de `contato-metal`) |
| AC-13 | A página de modelo de informação do SA-IG (`miSA.xml`) está vazia e é cópia do modelo do RIA-R: o SA-IG não tem modelo lógico | Médio | Modelo lógico [SumarioAltaML](StructureDefinition-sumario-alta-ml.html), com mapeamento para o BR-Core e para o SA-IG; ver [Mapa de estrutura](mapa-estrutura.html) |
| AC-14 | O `br-core-composition` liga `section.code` ao ValueSet `doc-section-codes` como required; no Composition do R4 e no IPS o binding é example. Com required, códigos de seção do BR-Core que não estão no ValueSet falham quando o validador consulta o servidor de terminologia: 42347-5, 8654-6 e 54522-8 no `br-core-sumarioalta`; 57852-6 é aceito, mas 52471-0, 89213-3, 63895-7 e 54522-8 no `br-core-registroatendimentoclinico` não | Bloqueante | Corrigido no `main` do BR-Core: o `br-core-composition` liga `section.code` ao `doc-section-codes` como example, como no R4 e no IPS. Os códigos de seção do `BRSumarioAlta` (42347-5, 48765-2, 57852-6, 47519-4, 8654-6, 18776-5 e 47420-5, este do IPS) são todos aceitos. O pacote 1.3.0 publicado ainda traz o required; a correção entra na próxima versão |
| AC-15 | O `br-core-patient` declara a raça/cor (extensão `raca-br-ips` do IPS-BR) como 1..1 desde a 1.3.0, mas o pacote 1.3.0 publicado não tem essa fatia nem as de identidade de gênero, povo indígena e sexo ao nascimento: o pacote foi gerado sem o `br.gov.saude.ips.fhir`, e o SUSHI descartou as regras. Exemplos sem raça/cor passam na 1.3.0 e falham no BR-Core corrigido | Alto | Exemplos com raça/cor (`BRRacaCor`). Levar ao BR-Core: gerar o pacote com a dependência do IPS-BR disponível |
| AC-16 | O BR-Core 1.3.0 traz documentos de caso de uso (`br-core-sumarioalta`, `br-core-registroatendimentoclinico`), o que nenhum core nacional consultado faz (US, AU, CA, FR; o CH Core só tem Composition e Bundle genéricos). O conteúdo normatizado pela RNDS ficava sob a governança do BR-Core | Alto | Os dois perfis foram retirados do `main` do BR-Core; o Sumário de Alta é o `BRSumarioAlta`, sobre o `br-core-composition` e os perfis de base do BR-Core. AC-01 e AC-02 deixam de afetar este guia |
