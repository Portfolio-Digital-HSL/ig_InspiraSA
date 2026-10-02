# Recomendações à RNDS

1. **Corrigir o `br-core-sumarioalta` antes de exigi-lo** (D-01, D-02): discriminador `pattern` em `code` e sistema `http://loinc.org`. Hoje nenhum documento passa na validação.
2. **Derivar o Sumário de Alta do BR-Core** e abandonar o canonical `www.saude.gov.br/fhir/r4`. Publicar o guia com `dependsOn` do pacote BR-Core.
3. **Usar elementos nativos**: `Composition.encounter` para o contato assistencial, `Encounter.text` para o resumo da evolução, `Timing` para turno e intervalo, `participant`/CareTeam para a equipe.
4. **Permitir paciente sem CPF** no br-core-patient (D-03), com a regra "CPF ou CNS", para que o CNS provisório substitua a extensão unidentifiedPatient.
5. **Status do HL7 com tradução por suplemento.** Descontinuar os CodeSystems nacionais que copiam códigos do HL7 e publicar suplementos pt-BR no guia de terminologia.
6. **SNOMED CT para alergias e manifestações.** Incluir SNOMED CT (via CBARA) no BRAlergenos; carregar o CBARA completo no guia de terminologia; ligar manifestações a SNOMED CT e publicar o mapa MedDRA–SNOMED CT para a farmacovigilância da Anvisa.
7. **Recompor o `BRProcedimentosNacionais`** com SIGTAP, TUSS e CBHPM, e publicar um CodeSystem CBHPM com URL própria.
8. **Revisar o `br-core-capacidadefuncional`** (D-04): terminologia de funcionalidade (CIF ou SNOMED CT), categoria do HL7 e `subject` só por referência.
9. **Liberar mais de uma posologia** em `br-core-medicationrequest` (D-05) e remover o binding da fatia `medicationReference` (D-07).
10. **Enviar o Sumário de Alta como Bundle `document`** assinado, com `identifier` estável e retificação por `relatesTo`.

## Terminologias propostas

Na pasta `terminologia/` deste repositório, para importação no OCL (org MS) e publicação no guia de terminologia:

- 17 suplementos pt-BR (ver [Terminologia](terminologia.html));
- ValueSets BRAlergenosSNOMEDNacional, BRManifestacaoReacaoSNOMED e BRProcedimentosSUSSaudeSuplementar;
- ConceptMap BRMedDRAParaSNOMED.

## Extensões

Nenhuma. Tudo o que o SA-IG fazia com extensão tem elemento nativo.
