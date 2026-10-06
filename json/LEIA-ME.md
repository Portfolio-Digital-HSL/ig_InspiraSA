# IG InspiraSA: recursos em JSON

Gerado em 06/10/2026 do repositório Portfolio-Digital-HSL/ig_InspiraSA (main), com SUSHI 3.20.1 e IG Publisher 2.3.4.

## guia/ (24 arquivos)
Recursos publicados pelo guia, como saem do IG Publisher (com narrativa):
- ImplementationGuide-br.org.hsl.inspirasa.json
- StructureDefinition-sumario-alta-ml.json: modelo lógico do Sumário de Alta, com snapshot e mapeamentos para o BR-Core e o SA-IG.
- 22 exemplos: Bundle document, duas Compositions (internação por insuficiência cardíaca e colecistectomia com seções vazias) e os recursos referenciados.

O guia não tem perfis próprios: os exemplos declaram os perfis do BR-Core 1.3.0 e do FHIR Clinical Documents 1.0.1. Contra o BR-Core 1.3.0, as Compositions e o Bundle acusam os defeitos D-01 e D-02 do br-core-sumarioalta publicado.

## exemplos-brcore-main/ (22 arquivos)
Os mesmos exemplos ajustados ao BR-Core corrigido (HL7-BR main 9cf1bc9): LOINC http://loinc.org nas seções e capacidade funcional 47420-5. Validam com 0 erros contra o main do BR-Core e o FHIR Clinical Documents (sem servidor de terminologia). Viram os exemplos do guia quando a dependência mudar para a nova versão do BR-Core.

## terminologia/ (23 arquivos)
Artefatos para o OCL e o guia de terminologia (https://terminologia.saude.gov.br/fhir/...), não publicados por este guia: 17 suplementos pt-BR, 4 ValueSets (BRAlergenosSNOMEDNacional, BRManifestacaoReacaoSNOMED, BRCapacidadeFuncional, BRProcedimentosNacionais) e 2 ConceptMaps (BRMedDRAParaSNOMED, BRAlergenosCBARAParaSNOMED).
