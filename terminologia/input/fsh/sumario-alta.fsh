// ValueSets e ConceptMap do Sumário de Alta (IG InspiraSA).

RuleSet: TermoDraft(id)
* ^url = "https://terminologia.saude.gov.br/fhir/{id}"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = true
* ^publisher = "Ministério da Saúde"
* ^language = #pt-BR

ValueSet: BRAlergenosSNOMEDNacional
Id: BRAlergenosSNOMEDNacional
Title: "Alérgenos: SNOMED CT e códigos nacionais"
Description: "Agentes de alergia e intolerância. Padrão: SNOMED CT (substâncias e produtos farmacêuticos/biológicos). Os códigos nacionais do CBARA, mapeados para SNOMED CT no OCL, medicamentos (BRMedicamento) e imunobiológicos (BRImunobiologico) são aceitos para compatibilidade com o BRAlergenos do BR-Core."
* insert TermoDraft(ValueSet/BRAlergenosSNOMEDNacional)
* include codes from system $sct where concept is-a #105590001 "Substance (substance)"
* include codes from system $sct where concept is-a #373873005 "Pharmaceutical / biologic product (product)"
* include codes from system $BRAlergenosCBARA
* include codes from system $BRMedicamento
* include codes from system $BRImunobiologico

ValueSet: BRManifestacaoReacaoSNOMED
Id: BRManifestacaoReacaoSNOMED
Title: "Manifestação de reação adversa: SNOMED CT"
Description: "Manifestações clínicas de reação alérgica ou intolerância. Padrão: SNOMED CT (achados clínicos). MedDRA, usado pela Anvisa na farmacovigilância, é aceito como codificação adicional e convertido pelo ConceptMap BRMedDRAParaSNOMED."
* insert TermoDraft(ValueSet/BRManifestacaoReacaoSNOMED)
* include codes from system $sct where concept is-a #404684003 "Clinical finding (finding)"

ValueSet: BRCapacidadeFuncional
Id: BRCapacidadeFuncional
Title: "Capacidade funcional: SNOMED CT"
Description: "Achados funcionais (capacidade ou incapacidade) em SNOMED CT, descendentes de 118228005 Functional finding. Usado em br-core-capacidadefuncional.code (preferred), na correção proposta ao BR-Core. CID-10 e CIAP-2 da condição de base podem vir como codificação adicional."
* insert TermoDraft(ValueSet/BRCapacidadeFuncional)
* include codes from system $sct where concept is-a #118228005 "Functional finding (finding)"

ValueSet: BRProcedimentosNacionais
Id: BRProcedimentosNacionais
Title: "BR Procedimentos Nacionais"
Description: "Proposta de nova versão do BRProcedimentosNacionais: procedimentos do SUS (Tabela SUS / SIGTAP, BRTabelaSUS) e da saúde suplementar (TUSS 22 da ANS, tabela-22 no OCL). Sai o BRCBHPMTUSS: a CBHPM é da AMB, de uso licenciado e pago. Hoje o mesmo canonical tem dois conteúdos: 1000 códigos TUSS 22 no guia de terminologia e 25 códigos da BRTabelaSUS no OCL (BRProcedimentosNacionais-1.0)."
* insert TermoDraft(ValueSet/BRProcedimentosNacionais)
* include codes from system $BRTabelaSUS
* include codes from system $tuss-22

Instance: BRMedDRAParaSNOMED
InstanceOf: ConceptMap
Usage: #definition
Title: "MedDRA para SNOMED CT (manifestações)"
* url = "https://terminologia.saude.gov.br/fhir/ConceptMap/BRMedDRAParaSNOMED"
* version = "0.1.0"
* name = "BRMedDRAParaSNOMED"
* title = "MedDRA para SNOMED CT (manifestações)"
* status = #draft
* experimental = true
* publisher = "Ministério da Saúde"
* language = #pt-BR
* description = "Manifestações de reação adversa do BRMedDRA (usado pela Anvisa) para SNOMED CT. Forma FHIR dos 28 mapeamentos SAME-AS que existem no OCL, na Source MS/BRMedDRA (alvo /orgs/SNOMED/sources/gps/), um para cada código do BRMedDRA."
* sourceCanonical = "https://terminologia.saude.gov.br/fhir/ValueSet/BRReacoesAdversasMedDRA"
* targetCanonical = "https://terminologia.saude.gov.br/fhir/ValueSet/BRManifestacaoReacaoSNOMED"
* group[0].source = $BRMedDRA
* group[0].target = $sct
* group[0].element[0].code = #10002198
* group[0].element[0].display = "Anafilaxia"
* group[0].element[0].target[0].code = #39579001
* group[0].element[0].target[0].display = "Anaphylaxis (disorder)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #10002424
* group[0].element[1].display = "Angioedema"
* group[0].element[1].target[0].code = #41291007
* group[0].element[1].target[0].display = "Angioedema (disorder)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[2].code = #10003246
* group[0].element[2].display = "Artrite"
* group[0].element[2].target[0].code = #3723001
* group[0].element[2].target[0].display = "Arthritis (disorder)"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #10003553
* group[0].element[3].display = "Asma"
* group[0].element[3].target[0].code = #195967001
* group[0].element[3].target[0].display = "Asthma (disorder)"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[4].code = #10003639
* group[0].element[4].display = "Dermatite atópica"
* group[0].element[4].target[0].code = #24079001
* group[0].element[4].target[0].display = "Atopic dermatitis (disorder)"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[5].code = #10006482
* group[0].element[5].display = "Broncoespasmo"
* group[0].element[5].target[0].code = #4386001
* group[0].element[5].target[0].display = "Bronchospasm (finding)"
* group[0].element[5].target[0].equivalence = #equivalent
* group[0].element[6].code = #10007617
* group[0].element[6].display = "Parada Cardiorespiratória"
* group[0].element[6].target[0].code = #410429000
* group[0].element[6].target[0].display = "Cardiac arrest (disorder)"
* group[0].element[6].target[0].equivalence = #equivalent
* group[0].element[7].code = #10010741
* group[0].element[7].display = "Conjuntivite"
* group[0].element[7].target[0].code = #9826008
* group[0].element[7].target[0].display = "Conjunctivitis (disorder)"
* group[0].element[7].target[0].equivalence = #equivalent
* group[0].element[8].code = #10011224
* group[0].element[8].display = "Tosse"
* group[0].element[8].target[0].code = #49727002
* group[0].element[8].target[0].display = "Cough (finding)"
* group[0].element[8].target[0].equivalence = #equivalent
* group[0].element[9].code = #10012441
* group[0].element[9].display = "Exantema bolhoso"
* group[0].element[9].target[0].code = #271759003
* group[0].element[9].target[0].display = "Bullous eruption (disorder)"
* group[0].element[9].target[0].equivalence = #equivalent
* group[0].element[10].code = #10012442
* group[0].element[10].display = "Dermatite de contato"
* group[0].element[10].target[0].code = #40275004
* group[0].element[10].target[0].display = "Contact dermatitis (disorder)"
* group[0].element[10].target[0].equivalence = #equivalent
* group[0].element[11].code = #10012735
* group[0].element[11].display = "Diarréia"
* group[0].element[11].target[0].code = #62315008
* group[0].element[11].target[0].display = "Diarrhea (finding)"
* group[0].element[11].target[0].equivalence = #equivalent
* group[0].element[12].code = #10013968
* group[0].element[12].display = "Dispnéia"
* group[0].element[12].target[0].code = #267036007
* group[0].element[12].target[0].display = "Dyspnea (finding)"
* group[0].element[12].target[0].equivalence = #equivalent
* group[0].element[13].code = #10014184
* group[0].element[13].display = "Eczema"
* group[0].element[13].target[0].code = #43116000
* group[0].element[13].target[0].display = "Eczema (disorder)"
* group[0].element[13].target[0].equivalence = #equivalent
* group[0].element[14].code = #10015218
* group[0].element[14].display = "Eritema Multiforme"
* group[0].element[14].target[0].code = #36715001
* group[0].element[14].target[0].display = "Erythema multiforme (disorder)"
* group[0].element[14].target[0].equivalence = #equivalent
* group[0].element[15].code = #10023845
* group[0].element[15].display = "Edema de Glote"
* group[0].element[15].target[0].code = #51599000
* group[0].element[15].target[0].display = "Edema of larynx (disorder)"
* group[0].element[15].target[0].equivalence = #equivalent
* group[0].element[16].code = #10028116
* group[0].element[16].display = "Mucosite"
* group[0].element[16].target[0].code = #95361005
* group[0].element[16].target[0].display = "Inflammatory disease of mucous membrane (disorder)"
* group[0].element[16].target[0].equivalence = #equivalent
* group[0].element[17].code = #10029117
* group[0].element[17].display = "Nefrite"
* group[0].element[17].target[0].code = #52845002
* group[0].element[17].target[0].display = "Nephritis (disorder)"
* group[0].element[17].target[0].equivalence = #equivalent
* group[0].element[18].code = #10034972
* group[0].element[18].display = "Fotossensibilidade"
* group[0].element[18].target[0].code = #90128006
* group[0].element[18].target[0].display = "Photosensitivity (finding)"
* group[0].element[18].target[0].equivalence = #equivalent
* group[0].element[19].code = #10037087
* group[0].element[19].display = "Prurido"
* group[0].element[19].target[0].code = #418363000
* group[0].element[19].target[0].display = "Itching of skin (finding)"
* group[0].element[19].target[0].equivalence = #equivalent
* group[0].element[20].code = #10037868
* group[0].element[20].display = "Exantema maculopapular"
* group[0].element[20].target[0].code = #247471006
* group[0].element[20].target[0].display = "Maculopapular eruption (disorder)"
* group[0].element[20].target[0].equivalence = #equivalent
* group[0].element[21].code = #10039083
* group[0].element[21].display = "Rinite"
* group[0].element[21].target[0].code = #70076002
* group[0].element[21].target[0].display = "Rhinitis (disorder)"
* group[0].element[21].target[0].equivalence = #equivalent
* group[0].element[22].code = #10042033
* group[0].element[22].display = "Síndrome de Stevens-Johnson"
* group[0].element[22].target[0].code = #73442001
* group[0].element[22].target[0].display = "Stevens-Johnson syndrome (disorder)"
* group[0].element[22].target[0].equivalence = #equivalent
* group[0].element[23].code = #10044223
* group[0].element[23].display = "Síndrome de Lyell"
* group[0].element[23].target[0].code = #768962006
* group[0].element[23].target[0].display = "Lyell syndrome (disorder)"
* group[0].element[23].target[0].equivalence = #equivalent
* group[0].element[24].code = #10046735
* group[0].element[24].display = "Urticária"
* group[0].element[24].target[0].code = #126485001
* group[0].element[24].target[0].display = "Urticaria (disorder)"
* group[0].element[24].target[0].equivalence = #equivalent
* group[0].element[25].code = #10047115
* group[0].element[25].display = "Vasculite"
* group[0].element[25].target[0].code = #31996006
* group[0].element[25].target[0].display = "Vasculitis (disorder)"
* group[0].element[25].target[0].equivalence = #equivalent
* group[0].element[26].code = #10047700
* group[0].element[26].display = "Vômito"
* group[0].element[26].target[0].code = #422400008
* group[0].element[26].target[0].display = "Vomiting (disorder)"
* group[0].element[26].target[0].equivalence = #equivalent
* group[0].element[27].code = #10073508
* group[0].element[27].display = "Síndrome de DRESS"
* group[0].element[27].target[0].code = #702809001
* group[0].element[27].target[0].display = "Drug reaction with eosinophilia and systemic symptoms (disorder)"
* group[0].element[27].target[0].equivalence = #equivalent

// Mapeamentos do CBARA para SNOMED CT que faltavam no OCL (decididos em
// 05/10/2026). Os demais 147 já estão na Source MS/BRAlergenosCBARA.
Instance: BRAlergenosCBARAParaSNOMED
InstanceOf: ConceptMap
Usage: #definition
Title: "CBARA para SNOMED CT (complemento)"
* url = "https://terminologia.saude.gov.br/fhir/ConceptMap/BRAlergenosCBARAParaSNOMED"
* version = "0.1.0"
* name = "BRAlergenosCBARAParaSNOMED"
* title = "CBARA para SNOMED CT (complemento)"
* status = #draft
* experimental = true
* publisher = "Ministério da Saúde"
* language = #pt-BR
* description = "Mapeamentos SAME-AS dos códigos do BRAlergenosCBARA que estavam sem correspondência em SNOMED CT no OCL. O JSONL grava cada um na Source MS/BRAlergenosCBARA."
* group[0].source = $BRAlergenosCBARA
* group[0].target = $sct
* group[0].element[0].code = #lima
* group[0].element[0].display = "Lima"
* group[0].element[0].target[0].code = #1285547006
* group[0].element[0].target[0].display = "Citrus X latifolia (substance)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Proposto: limão-taiti (lima ácida Tahiti), sinônimo SNOMED Seedless lime."
* group[0].element[1].code = #grama
* group[0].element[1].display = "Grama"
* group[0].element[1].target[0].code = #256277009
* group[0].element[1].target[0].display = "Grass pollen (substance)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Proposto: pólen de gramíneas."
* group[0].element[2].code = #contato-metal
* group[0].element[2].display = "Contato com metal"
* group[0].element[2].target[0].code = #767098004
* group[0].element[2].target[0].display = "Metal and/or metal compound (substance)"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Proposto."
