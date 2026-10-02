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
Description: "Agentes de alergia e intolerância. Padrão: SNOMED CT (substâncias e produtos farmacêuticos/biológicos), que é a base do CBARA. Códigos nacionais do CBARA sem conceito SNOMED, medicamentos (BRMedicamento) e imunobiológicos (BRImunobiologico) são aceitos para compatibilidade com o BRAlergenos do BR-Core."
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

ValueSet: BRProcedimentosSUSSaudeSuplementar
Id: BRProcedimentosSUSSaudeSuplementar
Title: "Procedimentos: SIGTAP, TUSS e CBHPM"
Description: "Procedimentos realizados no SUS (Tabela SUS / SIGTAP) e na saúde suplementar (TUSS 22 da ANS e CBHPM). Recompõe o BRProcedimentosNacionais do BR-Core, que hoje enumera só parte da TUSS e não inclui a Tabela SUS."
* insert TermoDraft(ValueSet/BRProcedimentosSUSSaudeSuplementar)
* include codes from system $BRTabelaSUS
* include codes from system $tuss-22
* include codes from system $BRCBHPMTUSS

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
* description = "Mapa das manifestações de reação adversa em MedDRA (BRReacoesAdversasMedDRA) para SNOMED CT. O conteúdo completo deve vir do mapa oficial MedDRA–SNOMED CT (MSSO/SNOMED International), sujeito às licenças das duas terminologias. Os mapeamentos abaixo são ilustrativos."
* sourceCanonical = "https://terminologia.saude.gov.br/fhir/ValueSet/BRReacoesAdversasMedDRA"
* targetCanonical = "https://terminologia.saude.gov.br/fhir/ValueSet/BRManifestacaoReacaoSNOMED"
* group[0].source = $BRMedDRA
* group[0].target = $sct
* group[0].element[0].code = #10002424
* group[0].element[0].display = "Angioedema"
* group[0].element[0].target[0].code = #41291007
* group[0].element[0].target[0].display = "Angioedema (disorder)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #10013968
* group[0].element[1].display = "Dispnéia"
* group[0].element[1].target[0].code = #267036007
* group[0].element[1].target[0].display = "Dyspnea (finding)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[2].code = #10014184
* group[0].element[2].display = "Eczema"
* group[0].element[2].target[0].code = #43116000
* group[0].element[2].target[0].display = "Eczema (disorder)"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #10037868
* group[0].element[3].display = "Exantema maculopapular"
* group[0].element[3].target[0].code = #247471006
* group[0].element[3].target[0].display = "Maculopapular eruption (disorder)"
* group[0].element[3].target[0].equivalence = #equivalent
