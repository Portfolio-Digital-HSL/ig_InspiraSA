# Recomendações à RNDS

1. **Publicar a nova versão do pacote BR-Core** com o que já está no `main` do repositório br.org.hl7.fhir.core (HL7-BR): `br-core-sumarioalta` e `br-core-registroatendimentoclinico` retirados (documentos são casos de uso da RNDS), LOINC `http://loinc.org`, `br-core-capacidadefuncional` revisto (D-04) e o novo `br-core-bundle-documento`. O binding de `section.code` volta a example, como no IPS, com os códigos de seção do IPS onde o IPS tem a seção (D-39). Com a correção, os exemplos deste guia validam sem erro também contra o `clinical-document-composition`.
2. **A RNDS se ajusta ao BR-Core nos recursos e é dona dos documentos.** Documentos normatizados (Sumário de Alta, RAC, RIA) como perfis da RNDS sobre o `br-core-composition`; os recursos pelos perfis do BR-Core; onde não houver perfil BR-Core, o FHIR Clinical Documents e, na falta dele, o recurso canônico do FHIR R4. Perfis RNDS sempre derivados do BR-Core (`BRSumarioAlta`, `rnds-internacao`, `rnds-documento-sumarioalta`), sem elementos, extensões ou terminologias próprias, e uma declaração de capacidades do servidor. Abandonar o SA-IG (canonical `www.saude.gov.br/fhir/r4`, herança do CMD) e publicar o guia com `dependsOn` do pacote BR-Core.
3. **Usar elementos nativos**: `Composition.encounter` para o contato assistencial, `Encounter.text` para o resumo da evolução, `Timing` para turno e intervalo, `participant`/CareTeam para a equipe.
4. **Permitir paciente sem CPF** no br-core-patient (D-03), com a regra "CPF ou CNS", para que o CNS provisório substitua a extensão unidentifiedPatient.
5. **Status do HL7 com tradução por suplemento.** Descontinuar os CodeSystems nacionais que copiam códigos do HL7 e publicar suplementos pt-BR no guia de terminologia.
6. **SNOMED CT para alergias e manifestações.** Incluir SNOMED CT (via CBARA) no BRAlergenos; publicar no guia de terminologia o CBARA do OCL (152 códigos, 147 com mapeamento para SNOMED CT) e o ConceptMap correspondente; ligar manifestações a SNOMED CT e publicar no guia de terminologia o mapa MedDRA–SNOMED CT que já está no OCL (Source MS/BRMedDRA).
7. **Publicar nova versão do `BRProcedimentosNacionais`** com BRTabelaSUS e TUSS 22 inteiras, sem o BRCBHPMTUSS (a CBHPM é da AMB e paga), e alinhar o conteúdo do guia de terminologia e do OCL.
8. **Revisar o `br-core-capacidadefuncional`** (D-04): terminologia de funcionalidade (CIF ou SNOMED CT), categoria do HL7 e `subject` só por referência.
9. **Liberar mais de uma posologia** em `br-core-medicationrequest` (D-05) e remover o binding da fatia `medicationReference` (D-07).
I. **Dar hierarquia ao CBARA** no OCL e no guia de terminologia: tipo (cereal, leguminosa, metal, pólen, grão) como pai das substâncias, para que o tipo do modelo de informação seja derivado da substância e não enviado em paralelo.
12. **Descontinuar o CMD como base de documentos.** As restrições do BRConjuntoMinimoDados (documento sem identificador, sem atestação, sem narrativa, paciente e autor só por identificador) vão para todos os documentos que derivam dele. O ponto de partida é o br-core-composition.

## Mudanças propostas ao BR-Core

Regras que este guia hoje só consegue dar como orientação de preenchimento:

| Perfil | Mudança |
|---|---|
| br-core-sumarioalta, br-core-registroatendimentoclinico | retirados no `main` do BR-Core: documentos são casos de uso da RNDS (D-41) |
| br-core-composition | binding de `section.code` example, como no R4 e no IPS (D-39), feito no `main` |
| br-core-composition | compatibilidade declarada com o `clinical-document-composition` (FHIR Clinical Documents): categoria 107903-7 Clinical note, fatias de atestador legal e profissional, extensões de versão e destinatário |
| br-core-bundle-documento (novo) | criado no `main` do BR-Core: Bundle `document` com identifier, timestamp ≥ Composition.date, br-core-composition como primeira entrada e fullUrl em todas as entradas, nas regras do `clinical-document-bundle` |
| br-core-encounter | invariante "internação encerrada tem `period.end`" para uso no Sumário de Alta |
| br-core-allergyintolerance | incluir SNOMED CT no BRAlergenos; `reaction.manifestation` preferred SNOMED CT |
| br-core-procedure | `code` extensible ao BRProcedimentosNacionais; `performer.function` preferred performer-role |
| br-core-medicationrequest | `dosageInstruction` 0..*; sem binding na fatia `medicationReference` (D-05, D-07) |
| br-core-capacidadefuncional | feito no `main` do BR-Core |
| br-core-patient | CPF 0..1 com invariante "CPF ou CNS" (D-03) |

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
