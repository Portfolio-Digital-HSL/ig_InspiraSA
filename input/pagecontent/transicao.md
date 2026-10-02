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
   - correção de D-01 e D-02 no BR-Core (sem ela nenhum Sumário de Alta valida contra o `br-core-sumarioalta`);
   - CPF opcional no br-core-patient (D-03);
   - validação do mapeamento proposto de Angioedema (MedDRA 10002424 → SNOMED CT 41291007);
   - terminologia de capacidade funcional.
5. **Medição de perda semântica.** Contar os documentos que não convertem sem ambiguidade, principalmente diagnósticos sem papel definido e prescrições em texto livre.
