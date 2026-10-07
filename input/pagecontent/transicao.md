# Transição e convivência

A mudança de canonical e de estrutura quebra a compatibilidade com o SA-IG. Emissores e a RNDS precisam migrar.

## Estratégia

1. **Convivência.** Por um período definido, a RNDS aceita o SA-IG e este modelo. Um conversor gera o documento novo a partir do antigo:
   - informacoesContatoAssistencial e informacoesAdicionais → Encounter;
   - resumoEvolucaoClinica → `Encounter.text`;
   - problemasDiagnosticosAvaliados → diagnosticosAdmissao (diagnósticos com papel de admissão) e diagnosticosAvaliados (demais);
   - prescricaoAlta → MedicationRequest direto, Medication a partir do CodeableConcept;
   - status nacionais → códigos HL7 (mapeamento 1:1);
   - BRTurno e BRIntervaloDoses → `Timing.repeat`.
2. **Seções novas obrigatórias.** Documentos antigos sem alguma das sete seções recebem a seção com `emptyReason = unavailable`.
3. **Terminologia.** Alérgenos e manifestações antigos (BRAlergenos, MedDRA) continuam aceitos como coding; SNOMED CT entra como coding adicional quando disponível; MedDRA é convertido pelo ConceptMap.
4. **Decisões pendentes antes de migrar:**
   - publicação da nova versão do BR-Core, sem o `br-core-sumarioalta` (AC-16);
   - CPF opcional no br-core-patient (AC-03);
   - terminologia de capacidade funcional.
5. **Medição de perda semântica.** Contar os documentos que não convertem sem ambiguidade, principalmente diagnósticos sem papel definido e prescrições em texto livre.
