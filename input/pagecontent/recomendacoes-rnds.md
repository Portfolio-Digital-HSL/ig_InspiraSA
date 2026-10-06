# Recomendações à RNDS

1. **Publicar a correção do BR-Core** (branch `fix/sumarioalta-capacidadefuncional` do repositório br.org.hl7.fhir.core): discriminador `pattern` em `section.code` e `http://loinc.org` no `br-core-sumarioalta` e no `br-core-registroatendimentoclinico` (D-01, D-02), e o `br-core-capacidadefuncional` revisto (D-04). Com a correção, os exemplos deste guia validam sem erro também contra o `clinical-document-composition`.
2. **A RNDS se ajusta ao BR-Core, não o contrário.** Usar o `br-core-sumarioalta` e os perfis do BR-Core; onde não houver perfil BR-Core, o recurso canônico do FHIR R4. Nenhum perfil próprio da RNDS. Abandonar o SA-IG (canonical `www.saude.gov.br/fhir/r4`, herança do CMD) e publicar o guia com `dependsOn` do pacote BR-Core.
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
| br-core-sumarioalta | `encounter` 1..1; `custodian` 1..1; `type` = LOINC 18842-5; invariante "seção com `entry` ou `emptyReason`"; discriminador `pattern` em `code` e `http://loinc.org` (D-01, D-02) |
| br-core-composition | compatibilidade declarada com o `clinical-document-composition` (FHIR Clinical Documents): categoria 107903-7 Clinical note, fatias de atestador legal e profissional, extensões de versão e destinatário |
| br-core-bundle-documento (novo) | criado no branch `fix/sumarioalta-capacidadefuncional`: Bundle `document` com identifier, timestamp ≥ Composition.date, br-core-composition como primeira entrada e fullUrl em todas as entradas, nas regras do `clinical-document-bundle` |
| br-core-encounter | invariante "internação encerrada tem `period.end`" para uso no Sumário de Alta |
| br-core-allergyintolerance | incluir SNOMED CT no BRAlergenos; `reaction.manifestation` preferred SNOMED CT |
| br-core-procedure | `code` extensible ao BRProcedimentosNacionais; `performer.function` preferred performer-role |
| br-core-medicationrequest | `dosageInstruction` 0..*; sem binding na fatia `medicationReference` (D-05, D-07) |
| br-core-capacidadefuncional | feito no branch `fix/sumarioalta-capacidadefuncional` |
| br-core-patient | CPF 0..1 com invariante "CPF ou CNS" (D-03) |

## Terminologias propostas

Na pasta `terminologia/` deste repositório, para importação no OCL (org MS) e publicação no guia de terminologia:

- 17 suplementos pt-BR (ver [Terminologia](terminologia.html));
- ValueSets BRAlergenosSNOMEDNacional, BRManifestacaoReacaoSNOMED e nova versão do BRProcedimentosNacionais;
- ConceptMap BRMedDRAParaSNOMED.

## Perfis e extensões

Nenhum. O BR-Core tem os perfis, e tudo o que o SA-IG fazia com extensão tem elemento nativo.
