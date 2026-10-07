# Mapa de estrutura

Este mapa mostra onde cada elemento do Sumário de Alta da RNDS (SA-IG) está no BR-Core e o que diverge. É gerado da planilha `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx` e do modelo lógico [SumarioAltaML](StructureDefinition-sumario-alta-ml.html) pelo script `scripts/gerar_mapa_estrutura.py`; para alterar, edite a planilha ou o modelo e gere de novo.

## Herança comparada

| Modelo | Cadeia |
|---|---|
| SA-IG da RNDS | BRSumarioAlta → BRConjuntoMinimoDados-1.1 (CMD) → Composition (R4); canonical `http://www.saude.gov.br/fhir/r4`, sem dependência do BR-Core |
| BR-Core 1.3.0 | br-core-sumarioalta → br-core-composition → Composition (R4); o br-core-sumarioalta foi retirado do `main` do BR-Core |
| Este guia | BRSumarioAlta → br-core-composition → Composition (R4); o CMD sai da cadeia. Documento em BRDocumentoSumarioAlta |

O comparativo tem duas camadas: o **documento-base** (CMD × br-core-composition) e o **Sumário de Alta** (BRSumarioAlta × br-core-sumarioalta, cabeçalho e seções). As colunas trazem a cardinalidade e o binding no FHIR R4, no SA-IG, no BR-Core 1.3.0 publicado e no BR-Core corrigido (`main` do HL7-BR, commit 9cf1bc9, ainda sem nova versão do pacote).

### Legenda

| Conformidade | Significado |
|---|---|
| Não conforme | O SA-IG proíbe o que o BR-Core exige, permite omitir o que ele exige, permite mais ocorrências ou usa outro ValueSet onde o BR-Core é required |
| Divergente | Restrições diferentes que, sozinhas, não impedem a validação |
| Conforme | Mesma cardinalidade e mesmas restrições |
| Sem equivalente | O elemento existe só em um dos modelos |

Grau do débito: **Bloqueante** impede instância válida; **Alto** quebra conformidade ou interoperabilidade; **Médio** gera ambiguidade; **Baixo** é ajuste de documentação. Os débitos do `BRSumarioAlta` e a correção feita estão em [Débitos técnicos](debitos-tecnicos.html); os achados do BR-Core e de outros artefatos, em [Recomendações](recomendacoes-rnds.html#achados-no-br-core-e-em-outros-artefatos).

## Modelo lógico → BR-Core → SA-IG

O SA-IG publica uma página de modelo de informação vazia, copiada do modelo do RIA-R (AC-13). O [modelo lógico do Sumário de Alta](StructureDefinition-sumario-alta-ml.html) reconstrói os elementos de dados do documento, independentes de tecnologia, e mapeia cada um para o elemento do BR-Core usado neste guia e para o do SA-IG. Os mesmos mapeamentos estão na aba *Mappings* do modelo.

### Documento (`documento`, 1..1)

BR-Core: Bundle (BRDocumentoSumarioAlta) + Composition (BRSumarioAlta, sobre br-core-composition). SA-IG: Bundle + Composition (BRSumarioAlta / BRConjuntoMinimoDados-1.1).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `documento.identificador` | 1..1 | Identifier | Identificador do documento | Bundle.identifier; Composition.identifier | não existe (Composition.identifier 0..0 no CMD) |
| `documento.dataHora` | 1..1 | dateTime | Data e hora do documento | Composition.date; Bundle.timestamp | Composition.date |
| `documento.situacao` | 1..1 | code | Situação do documento | Composition.status (composition-status) | Composition.status (BREstadoDocumento-1.0) |
| `documento.tipo` | 1..1 | CodeableConcept | Tipo de documento | Composition.type = LOINC 18842-5 | Composition.type (BRTipoDocumento-1.0) |
| `documento.autor` | 1..* | Reference | Autor | Composition.author (br-core-practitioner / practitionerrole) | Composition.author.identifier (BRPessoaJuridicaProfissionalLiberal-1.0) |
| `documento.atestador` | 0..1 | Reference | Atestador legal | Composition.attester (mode = legal) | não existe (attester 0..0) |
| `documento.custodiante` | 1..1 | Reference | Estabelecimento custodiante | Composition.custodian (br-core-organization) | não existe (custodian 0..0) |
| `documento.documentoSubstituido` | 0..1 | Reference | Documento substituído | Composition.relatesTo (replaces) | Composition.relatesTo |

### Indivíduo (`individuo`, 1..1)

BR-Core: Composition.subject (br-core-patient). SA-IG: Composition.subject.identifier (BRIndividuo-1.0) ou extensão unidentifiedPatient.


### Contato assistencial (internação) (`contatoAssistencial`, 1..1)

BR-Core: Composition.encounter (br-core-encounter). SA-IG: seção informacoesContatoAssistencial (BRContatoAssistencial-1.0).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `contatoAssistencial.modalidade` | 1..1 | CodeableConcept | Modalidade assistencial | Encounter.class (BRModalidadeAssistencial) | Encounter.class; também Composition.category no CMD |
| `contatoAssistencial.modalidadeTelessaude` | 0..1 | CodeableConcept | Modalidade de telessaúde | Encounter.type | Encounter.type (BRModalidadeTelessaude) |
| `contatoAssistencial.carater` | 1..1 | CodeableConcept | Caráter do atendimento | Encounter.priority (BRCaraterAtendimento) | Encounter.priority |
| `contatoAssistencial.admissao` | 1..1 | dateTime | Momento da admissão | Encounter.period.start | Encounter.period.start |
| `contatoAssistencial.alta` | 1..1 | dateTime | Momento da alta | Encounter.period.end | Encounter.period.end |
| `contatoAssistencial.procedencia` | 1..1 | CodeableConcept | Procedência | Encounter.hospitalization.admitSource (BRProcedencia) | Encounter.hospitalization.admitSource |
| `contatoAssistencial.motivoDesfecho` | 1..1 | CodeableConcept | Motivo do desfecho | Encounter.hospitalization.dischargeDisposition (BRMotivoDesfecho) | Encounter.hospitalization.dischargeDisposition |
| `contatoAssistencial.motivoAtendimento` | 0..1 | Reference | Motivo do atendimento | Encounter.reasonReference | Encounter.reasonReference |
| `contatoAssistencial.profissional` | 1..* | BackboneElement | Profissional participante | Encounter.participant | Encounter.participant (+ extensões function e team) |
| `contatoAssistencial.profissional.papel` | 1..1 | CodeableConcept | Tipo de participação | Encounter.participant.type (BRResponsabilidadeParticipante) | Encounter.participant.type |
| `contatoAssistencial.profissional.individuo` | 1..1 | Reference | Profissional | Encounter.participant.individual (br-core-practitioner / practitionerrole) | Encounter.participant.individual |
| `contatoAssistencial.equipe` | 0..1 | Reference | Equipe | CareTeam (br-core-careteam) | extensão team / BRIdentificacaoEquipe |
| `contatoAssistencial.local` | 0..1 | Reference | Local de atendimento | Encounter.location (br-core-location) | Encounter.location |
| `contatoAssistencial.estabelecimento` | 1..1 | Reference | Estabelecimento | Encounter.serviceProvider (br-core-organization) | Encounter.serviceProvider.identifier |
| `contatoAssistencial.contatoAnterior` | 0..1 | Reference | Contato assistencial anterior | Encounter.partOf | Encounter.partOf |
| `contatoAssistencial.resumoEvolucao` | 1..1 | string | Resumo da evolução clínica | Encounter.text | seção resumoEvolucaoClinica (ClinicalImpression.summary) |
| `contatoAssistencial.informacoesAdicionais` | 0..1 | string | Informações adicionais | Encounter.text | seção informacoesAdicionais (BRObservacaoDescritiva-1.0) e extensão otherInformations |

### Diagnóstico da admissão (`diagnosticoAdmissao`, 0..*)

BR-Core: BRSumarioAlta section:diagnosticosAdmissao (LOINC 42347-5) → Condition (br-core-condition). SA-IG: seção problemasDiagnosticosAvaliados (BRProblemaDiagnostico).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `diagnosticoAdmissao.codigo` | 1..1 | CodeableConcept | Diagnóstico ou problema | Condition.code (BRCID10) | Condition.code (BRProblemaDiagnostico) |
| `diagnosticoAdmissao.situacao` | 1..1 | CodeableConcept | Estado da resolução | Condition.clinicalStatus (condition-clinical + suplemento pt-BR) | Condition.clinicalStatus (BREstadoResolucaoDiagnosticoProblema-1.0) |
| `diagnosticoAdmissao.nota` | 0..1 | string | Nota | Condition.note | Condition.note |

### Diagnóstico avaliado (`diagnosticoAvaliado`, 0..*)

BR-Core: BRSumarioAlta section:diagnosticosAvaliados (LOINC 57852-6) → Condition (br-core-condition); papel em Encounter.diagnosis.use. SA-IG: seção problemasDiagnosticosAvaliados; Encounter.diagnosis:problemAndDiagnosis.

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `diagnosticoAvaliado.codigo` | 1..1 | CodeableConcept | Diagnóstico ou problema | Condition.code (BRCID10) | Condition.code |
| `diagnosticoAvaliado.papel` | 0..1 | CodeableConcept | Principal ou secundário | Encounter.diagnosis.use / rank | Encounter.diagnosis.rank |
| `diagnosticoAvaliado.situacao` | 1..1 | CodeableConcept | Estado da resolução | Condition.clinicalStatus | Condition.clinicalStatus |

### Alergia ou reação adversa (`alergia`, 0..*)

BR-Core: BRSumarioAlta section:alergiasIntolerancias (LOINC 48765-2) → AllergyIntolerance (br-core-allergyintolerance). SA-IG: seção alergiaReacaoAdversa (BRAlergiaReacaoAdversa-1.0).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `alergia.agente` | 1..1 | CodeableConcept | Agente ou substância | AllergyIntolerance.code (CBARA + SNOMED CT; BRMedicamento; BRImunobiologico) | AllergyIntolerance.code (BRAlergenos-1.0) |
| `alergia.categoria` | 1..1 | code | Categoria do agente | AllergyIntolerance.category | AllergyIntolerance.category (BRCategoriaAgenteAlergiasReacoesAdversas-1.0) |
| `alergia.tipo` | 0..1 | code | Tipo de reação | AllergyIntolerance.type | AllergyIntolerance.type |
| `alergia.grauCerteza` | 0..1 | CodeableConcept | Grau de certeza | AllergyIntolerance.verificationStatus | AllergyIntolerance.verificationStatus (BRGrauCertezaAlergiasReacoesAdversas-1.0) |
| `alergia.criticidade` | 0..1 | code | Criticidade | AllergyIntolerance.criticality | AllergyIntolerance.criticality (BRCriticidadeAlergiasReacoesAdversas-1.0) |
| `alergia.instalacao` | 0..1 | dateTime | Data da instalação | AllergyIntolerance.onset[x] | AllergyIntolerance.onset[x] |
| `alergia.manifestacao` | 0..* | CodeableConcept | Manifestação | AllergyIntolerance.reaction.manifestation (SNOMED CT; MedDRA adicional) | AllergyIntolerance.reaction.manifestation (MedDRA, máx. 1) |
| `alergia.evolucao` | 0..1 | string | Evolução | AllergyIntolerance.note | AllergyIntolerance.note |

### Procedimento realizado (`procedimento`, 0..*)

BR-Core: BRSumarioAlta section:procedimentosRealizados (LOINC 47519-4) → Procedure (br-core-procedure). SA-IG: seção procedimentosRealizados (BRProcedimentoRealizado-1.0); Encounter.diagnosis:procedure.

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `procedimento.codigo` | 1..1 | CodeableConcept | Procedimento | Procedure.code (BRProcedimentosNacionais) | Procedure.code (BRProcedimentosNacionais-1.0) |
| `procedimento.situacao` | 1..1 | code | Estado do procedimento | Procedure.status (event-status + suplemento pt-BR) | Procedure.status (BREstadoEvento-1.0) |
| `procedimento.momento` | 1..1 | dateTime | Momento da realização | Procedure.performed[x] | Procedure.performed[x] |
| `procedimento.quantidade` | 0..1 | integer | Quantidade | sem elemento no Procedure; produção na camada financeira (Claim) | extensão quantity (BRQuantidade-1.0) |
| `procedimento.executante` | 1..* | Reference | Executante | Procedure.performer.actor | Procedure.performer:practitioner.actor |
| `procedimento.funcao` | 0..1 | CodeableConcept | Função do executante | Procedure.performer.function (performer-role, SNOMED CT) | Procedure.performer.function (BROcupacao-1.0, CBO) |
| `procedimento.estabelecimentoTerceiro` | 0..1 | Reference | Estabelecimento terceiro | Procedure.performer.onBehalfOf | Procedure.performer.onBehalfOf |
| `procedimento.autorizacao` | 0..1 | Identifier | Número de autorização | Claim/ClaimResponse (camada financeira) | Procedure.identifier (type AUTH) |
| `procedimento.resultado` | 0..1 | string | Resultado ou observações | Procedure.note / outcome | Procedure.note |

### Prescrição de alta (`prescricao`, 0..*)

BR-Core: BRSumarioAlta section:prescricaoAlta (LOINC 8654-6) → MedicationRequest (br-core-medicationrequest). SA-IG: seção prescricaoAlta → BRRegistroPrescricaoMedicamento → BRPrescricaoMedicamento.

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `prescricao.medicamento` | 1..1 | Reference | Medicamento | MedicationRequest.medicationReference (br-core-medication, BRMedicamento) | MedicationRequest.medication[x] (BRPrescricaoNaoEstruturada, texto livre) |
| `prescricao.dataPrescricao` | 1..1 | dateTime | Data e hora da prescrição | MedicationRequest.authoredOn | MedicationRequest.authoredOn |
| `prescricao.prescritor` | 1..1 | Reference | Prescritor | MedicationRequest.requester | MedicationRequest.recorder.identifier (requester = estabelecimento) |
| `prescricao.posologia` | 0..1 | string | Posologia em texto | MedicationRequest.dosageInstruction.text | MedicationRequest.dosageInstruction.text |
| `prescricao.orientacoes` | 0..1 | string | Orientações de uso | MedicationRequest.dosageInstruction.patientInstruction | MedicationRequest.dosageInstruction.patientInstruction |
| `prescricao.frequencia` | 0..1 | Timing | Frequência e turno | MedicationRequest.dosageInstruction.timing (repeat.period, repeat.when) | timing + extensões BRIntervaloDoses e BRTurno |
| `prescricao.seNecessario` | 0..1 | boolean | Uso se necessário | MedicationRequest.dosageInstruction.asNeeded[x] | MedicationRequest.dosageInstruction.asNeeded[x] |
| `prescricao.via` | 1..1 | CodeableConcept | Via de administração | MedicationRequest.dosageInstruction.route (EDQM, IPS) | MedicationRequest.dosageInstruction.route (BRViaAdministracao-1.0) |
| `prescricao.dose` | 1..1 | Quantity | Dose | MedicationRequest.dosageInstruction.doseAndRate.dose[x] | MedicationRequest.dosageInstruction.maxDosePerAdministration |
| `prescricao.duracao` | 1..1 | Period | Duração / validade | MedicationRequest.dispenseRequest.validityPeriod | MedicationRequest.dispenseRequest.validityPeriod |
| `prescricao.quantidadeTotal` | 0..1 | Quantity | Total do tratamento | MedicationRequest.dispenseRequest.quantity | MedicationRequest.dispenseRequest.quantity |

### Plano de cuidados (`planoCuidados`, 0..*)

BR-Core: BRSumarioAlta section:planoCuidados (LOINC 18776-5) → CarePlan (br-core-careplan). SA-IG: seção planoCuidados (BRPlanoCuidados-1.0).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `planoCuidados.descricao` | 1..1 | string | Descrição | CarePlan.description | CarePlan.description |
| `planoCuidados.situacao` | 1..1 | code | Estado do plano | CarePlan.status (request-status + suplemento pt-BR) | CarePlan.status (BREstadoSolicitacao-1.0) |
| `planoCuidados.atividade` | 0..* | BackboneElement | Atividade programada | CarePlan.activity.detail (BRSubgrupoTabelaSUS) | não existe (activity 0..0) |

### Capacidade funcional (`capacidadeFuncional`, 0..*)

BR-Core: BRSumarioAlta section:capacidadeFuncional (LOINC 47420-5) → Condition (br-core-capacidadefuncional). SA-IG: seção restricaoFuncionalIncapacidadeSaude (BRRestricaoFuncionalIncapacidadeSaude-1.0).

| Elemento | Card. | Tipo | Nome | BR-Core (este guia) | SA-IG (legado) |
|---|---|---|---|---|---|
| `capacidadeFuncional.achado` | 1..1 | CodeableConcept | Achado funcional | Condition.code (BRCapacidadeFuncional, SNOMED CT; CID-10 adicional) | Condition.code.text (texto livre) |
| `capacidadeFuncional.situacao` | 1..1 | CodeableConcept | Estado | Condition.clinicalStatus | Condition.clinicalStatus (BREstadoRestricaoFuncionalIncapacidadeSaude-1.0) |
| `capacidadeFuncional.grau` | 0..1 | CodeableConcept | Grau | Condition.stage | não existe |

## Documento-base: CMD × br-core-composition

53 elementos comparados: 31 conforme, 21 divergente, 1 não conforme. A tabela mostra só os que não são conformes; os demais estão na planilha. Quase todas as restrições do cabeçalho do SA-IG vêm daqui.

| Elemento | R4 | CMD | br-core-composition 1.3.0 | Conformidade | Observação |
|---|---|---|---|---|---|
| `identifier` | 0..1 | 0..0 | 0..1 | Divergente | CMD zera o identificador do documento. |
| `status` | 1..1 · required: composition-status\|4.0.1 | 1..1 · required: BREstadoDocumento-1.0 · MS | 1..1 · required: composition-status | Não conforme |  |
| `type` | 1..1 · preferred: doc-typecodes | 1..1 · required: BRTipoDocumento-1.0 · MS | 1..1 · preferred: doc-typecodes | Divergente | CMD: um único coding, sem display nem text, ValueSet nacional BRTipoDocumento (required). BR-Core: doc-typecodes (preferred). |
| `category` | 0..* · example: document-classcodes | 1..1 · required: BRModalidadeAssistencial-1.0 · MS | 0..* · example: document-classcodes | Divergente | CMD: modalidade assistencial (BRModalidadeAssistencial, required, 1..1). BR-Core: document-classcodes (example). |
| `subject` | 0..1 · ref: Resource | 1..1 · ref: BRIndividuo-1.0 · MS | 0..1 · ref: br-core-patient | Divergente | CMD proíbe subject.reference, type e display: o paciente só pode ser identificado por identifier (sistema e valor), ou pela extensão unidentifiedPatient. BR-Core: referência a br-core-patient. |
| `encounter` | 0..1 · ref: Encounter | 0..0 · ref: Encounter | 0..1 · ref: br-core-encounter | Divergente | CMD zera encounter; o contato assistencial vira seção obrigatória. |
| `author` | 1..* · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 1..* · ref: BRPessoaJuridicaProfissionalLiberal-1.0 · MS | 1..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente | CMD proíbe author.reference, type e display e exige identifier: o autor só por identificador. BR-Core: referência a practitioner, practitionerrole, device, organization. |
| `confidentiality` | 0..1 · required: v3-ConfidentialityClassification\|2014-03-26 | 0..0 · required: v3-ConfidentialityClassification\|2014-03-26 | 0..1 · required: v3-ConfidentialityClassification | Divergente |  |
| `attester` | 0..* | 0..0 | 0..* | Divergente | CMD zera atestação. |
| `attester.mode` | 1..1 · required: composition-attestation-mode\|4.0.1 | 1..1 · required: composition-attestation-mode\|4.0.1 | 1..1 · required: composition-attestation-mode | Divergente |  |
| `attester.party` | 0..1 · ref: Patient, RelatedPerson, Practitioner, PractitionerRole, Organization | 0..1 · ref: Patient, RelatedPerson, Practitioner, PractitionerRole, Organization | 0..1 · ref: br-core-patient, br-core-relatedperson, br-core-practitioner, br-core-practitionerrole, br-core-organization | Divergente |  |
| `custodian` | 0..1 · ref: Organization | 0..0 · ref: Organization | 0..1 · ref: br-core-organization | Divergente | CMD zera custodiante. |
| `relatesTo` | 0..* | 0..1 | 0..* | Divergente | CMD limita a 1 e exige reference literal. |
| `relatesTo.code` | 1..1 · required: document-relationship-type\|4.0.1 | 1..1 · required: document-relationship-type\|4.0.1; fixedCode = "replaces" | 1..1 · required: document-relationship-type | Divergente |  |
| `relatesTo.target[x]` | 1..1 · ref: Composition | 1..1 | 1..1 · ref: Composition; slicing type em $this | Divergente |  |
| `event` | 0..* | 0..0 | 0..* | Divergente |  |
| `event.code` | 0..* · example: v3-ActCode | 0..* · example: v3-ActCode | 0..* · required: v3-ActCode | Divergente |  |
| `section` | 0..* | 1..* · slicing profile em entry.resolve() · MS | 0..* | Divergente | CMD já fatia as seções (informacoesContatoAssistencial 1..1, problemasDiagnosticosAvaliados, procedimentosRealizados) com code, text e emptyReason zerados. BR-Core não fatia no br-core-composition. |
| `section.code` | 0..1 · example: doc-section-codes | 0..1 · example: doc-section-codes | 0..1 · required: doc-section-codes | Divergente | CMD zera code em todas as suas fatias. |
| `section.author` | 0..* · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  |
| `section.mode` | 0..1 · required: list-mode\|4.0.1 | 0..1 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | Divergente |  |
| `section.orderedBy` | 0..1 · preferred: list-order | 0..1 · preferred: list-order | 0..1 · preferred: list-empty-reason | Divergente |  |

## Sumário de Alta: cabeçalho (BRSumarioAlta × br-core-sumarioalta)

| Elemento | R4 | SA-IG | BR-Core 1.3.0 | BR-Core corrigido | Conformidade | Grau | Origem no SA-IG | Recomendação |
|---|---|---|---|---|---|---|---|---|
| `identifier` | 0..1 | 0..0 | 0..1 | 0..1 | Divergente | Alto | CMD | Usar identifier (1..1 no documento). Bundle document exige identifier. |
| `status` | 1..1 · required: composition-status\|4.0.1 | 1..1 · required: BREstadoDocumento-1.0 | 1..1 · required: composition-status | 1..1 · required: composition-status | Não conforme | Alto | CMD | Usar composition-status do HL7 com suplemento pt-BR (BRSuplementoSituacaoDocumento). |
| `type` | 1..1 · preferred: doc-typecodes | 1..1 · required: BRTipoDocumento-1.0 | 1..1 · preferred: doc-typecodes | 1..1 · preferred: doc-typecodes | Divergente | Médio | CMD | LOINC 18842-5 Discharge summary. |
| `category` | 0..* · example: document-classcodes | 1..1 · required: BRModalidadeAssistencial-1.0 | 0..1 · example: document-classcodes | 0..1 · example: document-classcodes | Divergente | Médio | CMD | Modalidade em Encounter; category = LOINC 107903-7 Clinical note (FHIR Clinical Documents). |
| `subject` | 0..1 · ref: Resource | 1..1 · ref: BRIndividuo-1.0 | 0..1 · ref: br-core-patient | 0..1 · ref: br-core-patient | Divergente | Alto | CMD | br-core-patient. |
| `encounter` | 0..1 · ref: Encounter | 0..0 · ref: Encounter | 0..1 · ref: br-core-encounter | 0..1 · ref: br-core-encounter | Divergente | Alto | CMD | Composition.encounter para a internação (br-core-encounter); eliminar a seção informacoesContatoAssistencial. |
| `date` | 1..1 | 1..1 | 1..1 | 1..1 | Conforme |  | CMD |  |
| `author` | 1..* · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 1..* · ref: BRPessoaJuridicaProfissionalLiberal-1.0, BREstabelecimentoSaude-1.0 | 1..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 1..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente | Médio | CMD | Perfis do BR-Core. |
| `title` | 1..1 | 1..1 · fixedString = "Conjunto Mínimo de Dados" | 1..1 | 1..1 | Divergente | Alto | CMD | Título livre ("Sumário de Alta"). |
| `confidentiality` | 0..1 · required: v3-ConfidentialityClassification\|2014-03-26 | 0..0 · required: v3-ConfidentialityClassification\|2014-03-26 | 0..1 · required: v3-ConfidentialityClassification | 0..1 · required: v3-ConfidentialityClassification | Divergente | Baixo | CMD | Permitir. |
| `attester` | 0..* | 0..0 | 0..* | 0..* | Divergente | Alto | CMD | Atestador legal (FHIR Clinical Documents: attester:legal_attester). |
| `custodian` | 0..1 · ref: Organization | 0..0 · ref: Organization | 0..1 · ref: br-core-organization | 0..1 · ref: br-core-organization | Divergente | Alto | CMD | Estabelecimento (CNES) como custodian. |
| `relatesTo` | 0..* | 0..1 | 0..* | 0..* | Divergente | Baixo | CMD | Retificação por relatesTo (replaces). |
| `event` | 0..* | 0..0 | 0..* | 0..* | Divergente | Baixo | CMD | Sem ação. |
| `section` | 0..* | 1..* · slicing profile em entry.resolve() | 7..7 · slicing profile em code | 7..7 · slicing pattern em code | Não conforme | Bloqueante | BRSumarioAlta | Corrigido no main do BR-Core (9cf1bc9): discriminador pattern em code. |

## Sumário de Alta: seções

O SA-IG tem nove seções, fatiadas pelo perfil de `entry.resolve()`; o BR-Core tem sete, fatiadas por `code` (LOINC). Três seções do SA-IG não têm equivalente no BR-Core (contato assistencial, resumo da evolução, informações adicionais); o conteúdo delas vai para o Encounter referenciado em `Composition.encounter`, que não é seção. O binding de `section.code` é o ValueSet `doc-section-codes`, com códigos do CodeSystem LOINC (`http://loinc.org`). No BR-Core 1.3.0 é required e três códigos de seção (42347-5, 8654-6 e 54522-8) não estão no ValueSet; no BR-Core corrigido é example, como no R4 e no IPS, e a capacidade funcional usa o código do IPS, 47420-5 (AC-14).

| Seção no BR-Core | Seção no SA-IG | SA-IG card. | BR-Core card. | Conformidade | Grau | Observação |
|---|---|---|---|---|---|---|
| — | section:informacoesContatoAssistencial | 1..1 | — | Sem equivalente no BR-Core | Alto | Seção recria o Encounter, que deveria estar em Composition.encounter. |
| section:diagnosticosAdmissao | section:problemasDiagnosticosAvaliados | 0..* | 1..1 | Não conforme | Médio | SA-IG mistura diagnósticos de admissão e avaliados numa seção; BR-Core separa (42347-5). |
| section:diagnosticosAvaliados | section:problemasDiagnosticosAvaliados | 0..* | 1..1 | Não conforme | Médio | Idem, LOINC 57852-6. |
| section:alergiasIntolerancias | section:alergiaReacaoAdversa | 0..* | 1..1 | Não conforme | Médio | Mesma informação; BR-Core 1..1 com code LOINC 48765-2. |
| section:procedimentosRealizados | section:procedimentosRealizados | 1..* | 1..1 | Não conforme | Baixo | Mesma informação; SA-IG 1..* (uma seção por procedimento), BR-Core 1..1 com várias entradas. |
| section:prescricaoAlta | section:prescricaoAlta | 0..1 | 1..1 | Não conforme | Alto | SA-IG aponta para a Composition intermediária BRRegistroPrescricaoMedicamento; BR-Core aponta para br-core-medicationrequest. |
| section:planoCuidados | section:planoCuidados | 0..1 | 1..1 | Não conforme | Baixo | Mesma informação; BR-Core 1..1. |
| section:capacidadeFuncional | section:restricaoFuncionalIncapacidadeSaude | 0..1 | 1..1 | Não conforme | Alto | SA-IG 0..1; BR-Core 1..1 (obrigatória). |
| — | section:resumoEvolucaoClinica | 1..1 | — | Sem equivalente no BR-Core | Alto | Seção obrigatória no SA-IG com ClinicalImpression só para texto; sem seção no BR-Core. |
| — | section:informacoesAdicionais | 0..1 | — | Sem equivalente no BR-Core | Baixo | Sem seção no BR-Core. |

### Subelementos das seções

Sem as linhas das três seções que só existem no SA-IG (todas sem equivalente).

| Elemento (BR-Core) | Elemento (SA-IG) | SA-IG | BR-Core 1.3.0 | BR-Core corrigido | Conformidade | Grau | Origem no SA-IG |
|---|---|---|---|---|---|---|---|
| `section:diagnosticosAdmissao.title` | `section:problemasDiagnosticosAvaliados.title` | 0..1 · fixedString = "Motivo da admissão, diagnósticos relevantes e patologias associadas" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:diagnosticosAdmissao.code` | `section:problemasDiagnosticosAvaliados.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "42347-5", "system": "http://loinc.org"}]} | Divergente | Bloqueante | CMD |
| `section:diagnosticosAdmissao.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:diagnosticosAdmissao.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "42347-5" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:diagnosticosAdmissao.text` | `section:problemasDiagnosticosAvaliados.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | CMD |
| `section:diagnosticosAdmissao.mode` | `section:problemasDiagnosticosAvaliados.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | CMD |
| `section:diagnosticosAdmissao.orderedBy` | `section:problemasDiagnosticosAvaliados.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | CMD |
| `section:diagnosticosAdmissao.entry` | `section:problemasDiagnosticosAvaliados.entry` | 1..1 · ref: BRProblemaDiagnostico | 0..* · ref: br-core-condition | 0..* · ref: br-core-condition | Divergente | Médio | CMD |
| `section:diagnosticosAdmissao.emptyReason` | `section:problemasDiagnosticosAvaliados.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | CMD |
| `section:diagnosticosAdmissao.author` | `section:problemasDiagnosticosAvaliados.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | CMD |
| `section:diagnosticosAdmissao.focus` | `section:problemasDiagnosticosAvaliados.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | CMD |
| `section:diagnosticosAdmissao.section` | `section:problemasDiagnosticosAvaliados.section` | 0..0 | 0..* | 0..* | Divergente |  | CMD |
| `section:diagnosticosAvaliados.title` | `section:problemasDiagnosticosAvaliados.title` | 0..1 · fixedString = "Motivo da admissão, diagnósticos relevantes e patologias associadas" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:diagnosticosAvaliados.code` | `section:problemasDiagnosticosAvaliados.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "57852-6", "system": "http://loinc.org"}]} | Divergente | Bloqueante | CMD |
| `section:diagnosticosAvaliados.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:diagnosticosAvaliados.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "57852-6" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:diagnosticosAvaliados.text` | `section:problemasDiagnosticosAvaliados.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | CMD |
| `section:diagnosticosAvaliados.mode` | `section:problemasDiagnosticosAvaliados.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | CMD |
| `section:diagnosticosAvaliados.orderedBy` | `section:problemasDiagnosticosAvaliados.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | CMD |
| `section:diagnosticosAvaliados.entry` | `section:problemasDiagnosticosAvaliados.entry` | 1..1 · ref: BRProblemaDiagnostico | 0..* · ref: br-core-condition | 0..* · ref: br-core-condition | Divergente | Médio | CMD |
| `section:diagnosticosAvaliados.emptyReason` | `section:problemasDiagnosticosAvaliados.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | CMD |
| `section:diagnosticosAvaliados.author` | `section:problemasDiagnosticosAvaliados.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | CMD |
| `section:diagnosticosAvaliados.focus` | `section:problemasDiagnosticosAvaliados.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | CMD |
| `section:diagnosticosAvaliados.section` | `section:problemasDiagnosticosAvaliados.section` | 0..0 | 0..* | 0..* | Divergente |  | CMD |
| `section:alergiasIntolerancias.title` | `section:alergiaReacaoAdversa.title` | 0..1 · fixedString = "Alergias e/ou reações adversas na internação" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:alergiasIntolerancias.code` | `section:alergiaReacaoAdversa.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "48765-2", "system": "http://loinc.org"}]} | Divergente | Bloqueante | BRSumarioAlta |
| `section:alergiasIntolerancias.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:alergiasIntolerancias.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "48765-2" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:alergiasIntolerancias.text` | `section:alergiaReacaoAdversa.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | BRSumarioAlta |
| `section:alergiasIntolerancias.mode` | `section:alergiaReacaoAdversa.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | BRSumarioAlta |
| `section:alergiasIntolerancias.orderedBy` | `section:alergiaReacaoAdversa.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | BRSumarioAlta |
| `section:alergiasIntolerancias.entry` | `section:alergiaReacaoAdversa.entry` | 1..1 · ref: BRAlergiaReacaoAdversa-1.0 | 0..* · ref: br-core-allergyintolerance | 0..* · ref: br-core-allergyintolerance | Divergente | Médio | BRSumarioAlta |
| `section:alergiasIntolerancias.emptyReason` | `section:alergiaReacaoAdversa.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | BRSumarioAlta |
| `section:alergiasIntolerancias.author` | `section:alergiaReacaoAdversa.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | BRSumarioAlta |
| `section:alergiasIntolerancias.focus` | `section:alergiaReacaoAdversa.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | BRSumarioAlta |
| `section:alergiasIntolerancias.section` | `section:alergiaReacaoAdversa.section` | 0..0 | 0..* | 0..* | Divergente |  | BRSumarioAlta |
| `section:procedimentosRealizados.title` | `section:procedimentosRealizados.title` | 0..1 · fixedString = "Procedimento(s) realizado(s) ou solicitado(s)" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:procedimentosRealizados.code` | `section:procedimentosRealizados.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "47519-4", "system": "http://loinc.org"}]} | Divergente | Bloqueante | CMD |
| `section:procedimentosRealizados.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:procedimentosRealizados.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "47519-4" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:procedimentosRealizados.text` | `section:procedimentosRealizados.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | CMD |
| `section:procedimentosRealizados.mode` | `section:procedimentosRealizados.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | CMD |
| `section:procedimentosRealizados.orderedBy` | `section:procedimentosRealizados.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | CMD |
| `section:procedimentosRealizados.entry` | `section:procedimentosRealizados.entry` | 1..1 · ref: BRProcedimentoRealizado-1.0 | 0..* · ref: br-core-procedure | 0..* · ref: br-core-procedure | Divergente | Médio | CMD |
| `section:procedimentosRealizados.emptyReason` | `section:procedimentosRealizados.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | CMD |
| `section:procedimentosRealizados.author` | `section:procedimentosRealizados.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | CMD |
| `section:procedimentosRealizados.focus` | `section:procedimentosRealizados.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | CMD |
| `section:procedimentosRealizados.section` | `section:procedimentosRealizados.section` | 0..0 | 0..* | 0..* | Divergente |  | CMD |
| `section:prescricaoAlta.title` | `section:prescricaoAlta.title` | 0..1 · fixedString = "Prescrição da Alta" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:prescricaoAlta.code` | `section:prescricaoAlta.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "8654-6", "system": "http://loinc.org"}]} | Divergente | Bloqueante | BRSumarioAlta |
| `section:prescricaoAlta.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:prescricaoAlta.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "8654-6" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:prescricaoAlta.text` | `section:prescricaoAlta.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | BRSumarioAlta |
| `section:prescricaoAlta.mode` | `section:prescricaoAlta.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | BRSumarioAlta |
| `section:prescricaoAlta.orderedBy` | `section:prescricaoAlta.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | BRSumarioAlta |
| `section:prescricaoAlta.entry` | `section:prescricaoAlta.entry` | 1..1 · ref: BRRegistroPrescricaoMedicamento | 0..* · ref: br-core-medicationrequest | 0..* · ref: br-core-medicationrequest | Divergente | Médio | BRSumarioAlta |
| `section:prescricaoAlta.emptyReason` | `section:prescricaoAlta.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | BRSumarioAlta |
| `section:prescricaoAlta.author` | `section:prescricaoAlta.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | BRSumarioAlta |
| `section:prescricaoAlta.focus` | `section:prescricaoAlta.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | BRSumarioAlta |
| `section:prescricaoAlta.section` | `section:prescricaoAlta.section` | 0..0 | 0..* | 0..* | Divergente |  | BRSumarioAlta |
| `section:planoCuidados.title` | `section:planoCuidados.title` | 0..1 · fixedString = "Plano de cuidados, instruções e recomendações (na alta)" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:planoCuidados.code` | `section:planoCuidados.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "18776-5", "system": "http://loinc.org"}]} | Divergente | Bloqueante | BRSumarioAlta |
| `section:planoCuidados.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:planoCuidados.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "18776-5" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:planoCuidados.text` | `section:planoCuidados.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | BRSumarioAlta |
| `section:planoCuidados.mode` | `section:planoCuidados.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | BRSumarioAlta |
| `section:planoCuidados.orderedBy` | `section:planoCuidados.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | BRSumarioAlta |
| `section:planoCuidados.entry` | `section:planoCuidados.entry` | 1..1 · ref: BRPlanoCuidados-1.0 | 0..* · ref: br-core-careplan | 0..* · ref: br-core-careplan | Divergente | Médio | BRSumarioAlta |
| `section:planoCuidados.emptyReason` | `section:planoCuidados.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | BRSumarioAlta |
| `section:planoCuidados.author` | `section:planoCuidados.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | BRSumarioAlta |
| `section:planoCuidados.focus` | `section:planoCuidados.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | BRSumarioAlta |
| `section:planoCuidados.section` | `section:planoCuidados.section` | 0..0 | 0..* | 0..* | Divergente |  | BRSumarioAlta |
| `section:capacidadeFuncional.title` | `section:restricaoFuncionalIncapacidadeSaude.title` | 0..1 · fixedString = "Restrições funcionais e incapacidades em saúde" | 0..1 | 0..1 | Divergente | Baixo | BRSumarioAlta |
| `section:capacidadeFuncional.code` | `section:restricaoFuncionalIncapacidadeSaude.code` | 0..0 · example: doc-section-codes | 0..1 · required: doc-section-codes | 1..1 · example: doc-section-codes; patternCodeableConcept = {"coding": [{"code": "47420-5", "system": "http://loinc.org"}]} | Divergente | Bloqueante | BRSumarioAlta |
| `section:capacidadeFuncional.code.coding.system` | — | — · sem equivalente | 0..1 · patternUri = "https://loinc.org/" | 0..1 | Sem equivalente no SA-IG | Bloqueante | — |
| `section:capacidadeFuncional.code.coding.code` | — | — · sem equivalente | 0..1 · patternCode = "54522-8" | 0..1 | Sem equivalente no SA-IG |  | — |
| `section:capacidadeFuncional.text` | `section:restricaoFuncionalIncapacidadeSaude.text` | 0..0 | 0..1 | 0..1 | Divergente | Alto | BRSumarioAlta |
| `section:capacidadeFuncional.mode` | `section:restricaoFuncionalIncapacidadeSaude.mode` | 0..0 · required: list-mode\|4.0.1 | 0..1 · required: list-mode | 0..1 · required: list-mode | Divergente |  | BRSumarioAlta |
| `section:capacidadeFuncional.orderedBy` | `section:restricaoFuncionalIncapacidadeSaude.orderedBy` | 0..0 · preferred: list-order | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente |  | BRSumarioAlta |
| `section:capacidadeFuncional.entry` | `section:restricaoFuncionalIncapacidadeSaude.entry` | 0..* · ref: BRRestricaoFuncionalIncapacidadeSaude-1.0 | 0..* · ref: br-core-capacidadefuncional | 0..* · ref: br-core-capacidadefuncional | Divergente | Médio | BRSumarioAlta |
| `section:capacidadeFuncional.emptyReason` | `section:restricaoFuncionalIncapacidadeSaude.emptyReason` | 0..0 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | 0..1 · preferred: list-empty-reason | Divergente | Médio | BRSumarioAlta |
| `section:capacidadeFuncional.author` | `section:restricaoFuncionalIncapacidadeSaude.author` | 0..0 · ref: Practitioner, PractitionerRole, Device, Patient, RelatedPerson, Organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | 0..* · ref: br-core-practitioner, br-core-practitionerrole, Device, br-core-patient, br-core-relatedperson, br-core-organization | Divergente |  | BRSumarioAlta |
| `section:capacidadeFuncional.focus` | `section:restricaoFuncionalIncapacidadeSaude.focus` | 0..0 | 0..1 | 0..1 | Divergente |  | BRSumarioAlta |
| `section:capacidadeFuncional.section` | `section:restricaoFuncionalIncapacidadeSaude.section` | 0..0 | 0..* | 0..* | Divergente |  | BRSumarioAlta |

## Planilhas

| Planilha | Conteúdo |
|---|---|
| `comparativo/comparativo_sumarioalta_rnds_brcore.xlsx` (este repositório) | Fonte deste mapa: as duas camadas elemento a elemento, a partir dos snapshots, com FHIR R4, BR-Core 1.3.0, BR-Core corrigido e a origem de cada restrição; débitos e cotejo com a planilha anterior. |
| `comparativo_sa.xlsx` (repositório sa-ig, pasta `Claude outputs`) | Seções do SA-IG × br-core-sumarioalta, cinco recursos clínicos (Condition, AllergyIntolerance, Procedure, MedicationRequest, CarePlan) elemento a elemento e inventário dos 24 perfis do SA-IG, a partir do JSON do SA-IG e do FSH do BR-Core. |

### Cotejo entre as duas planilhas

| Tema | Planilha anterior | Este comparativo | Situação | Encaminhamento |
|---|---|---|---|---|
| Fontes | SA-IG em JSON × FSH do BR-Core (código-fonte do repositório). Sem coluna R4 (declarado no Leia-me). | SA-IG em snapshot × pacote BR-Core 1.3.0 em snapshot × R4 × BR-Core corrigido (main). | Divergem no método | Snapshot mostra o que o validador usa; o FSH não mostra herança nem o efeito do alias $loinc. |
| Escopo | Seções do documento, cinco recursos clínicos (Condition, AllergyIntolerance, Procedure, MedicationRequest, CarePlan) e inventário dos 24 perfis. | Cabeçalho da Composition, seções e subelementos, e o nível CMD × br-core-composition. | Complementares | Usar os dois: o anterior para os recursos clínicos, este para o documento. |
| Camada CMD | Cita que BRSumarioAlta deriva do CMD e que o CMD zera encounter. | Compara o CMD com o br-core-composition elemento a elemento e indica a origem de cada restrição. | Só neste | A maior parte das restrições do cabeçalho vem do CMD. |
| Cabeçalho da Composition | Não compara (só encounter). | identifier, attester, custodian e confidentiality proibidos; title fixo "Conjunto Mínimo de Dados"; status em ValueSet nacional; category usada para modalidade; subject e author só por identificador. | Só neste | Incluir nos débitos do SA. |
| Cardinalidade das seções no SA-IG | "Nenhuma das 9 seções tem cardinalidade total fixa"; procedimentosRealizados sem cardinalidade. | section 1..*; informacoesContatoAssistencial 1..1; procedimentosRealizados 1..*; resumoEvolucaoClinica 1..1 (snapshot). | Divergem | O anterior leu só o differential do BRSumarioAlta; o mínimo vem do CMD e aparece no snapshot. Procedimentos é obrigatório no SA-IG. |
| Fatiamento das seções no SA-IG | Não registra. | Discriminador profile em entry.resolve(); cada seção leva uma entrada e se repete. | Só neste |  |
| section.code, section.text e emptyReason no SA-IG | Não registra. | Os três proibidos (0..0) em todas as seções: sem código, sem narrativa, sem justificativa de seção vazia. | Só neste | Com o BR-Core corrigido, seção sem code não casa com nenhuma fatia: bloqueante. |
| br-core-sumarioalta: discriminador e sistema LOINC | Descreve os códigos como "fixos" e recomenda migrar para Parent br-core-sumarioalta. | Discriminador profile em code e system https://loinc.org/: nenhuma instância valida (AC-01, AC-02). Corrigido no main do BR-Core. | Divergem | A recomendação anterior só é viável depois da correção do BR-Core. |
| Seções 9 → 7 | Mesma correspondência: contato e informações adicionais sem seção; diagnósticos desdobrados; capacidade funcional obrigatória. | Mesma correspondência. | Concordam |  |
| Grau: contato assistencial e resumo da evolução | Médio e Médio. | Alto e Alto. | Divergem no grau | Ambos zeram/recriam elementos nativos (encounter, Encounter.text); tratado como Alto. |
| Paciente não identificado | Recomenda CNS provisório no lugar da extensão unidentifiedPatient. | Concorda e acrescenta que o br-core-patient exige CPF (1..1), o que impede o CNS provisório (AC-03). | Este completa | Decisão pendente no BR-Core. |
| Procedure.code | Recompor com SIGTAP, TUSS-22 e CBHPM. | BRProcedimentosNacionais com BRTabelaSUS e TUSS 22; CBHPM fora (AMB, paga). | Superado por decisão | Decisão de 02/10/2026. |
| Capacidade funcional | Remodelar sobre br-core-condition com ValueSet nacional de capacidade funcional. | br-core-capacidadefuncional corrigido: SNOMED CT Functional finding (BRCapacidadeFuncional), CID-10 adicional, sem subject.identifier e stage obrigatórios. | Superado por decisão | Correção no main do BR-Core do BR-Core. |
| Alergias e manifestações | SNOMED CT (GPS) no lugar de BRAlergenos/MedDRA. | SNOMED CT + CBARA (152 códigos mapeados no OCL) e MedDRA mapeado (28). | Este completa |  |
| Perfil próprio do SA | Recomenda migrar BRSumarioAlta para Parent br-core-sumarioalta. | Sem perfil próprio: usa br-core-sumarioalta direto; regras viram preenchimento e propostas ao BR-Core. | Superado por decisão | A RNDS se ajusta ao BR-Core. |
| Bundle do documento | Não trata. | br-core-bundle-documento criado no main do BR-Core; segue o clinical-document-bundle. | Só neste |  |
| Recursos clínicos (Condition, AllergyIntolerance, Procedure, MedicationRequest, CarePlan) | Comparação elemento a elemento com débito e recomendação. | Não repete. | Só no anterior | Continua válido; atualizar Procedure.code e capacidade funcional conforme decisões. |
| Inventário de perfis do SA-IG | 24 perfis com versão, data e equivalente no BR-Core. | Não repete. | Só no anterior |  |
