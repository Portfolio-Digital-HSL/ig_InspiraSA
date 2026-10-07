# IG InspiraSA: recursos em JSON

Gerado em 07/10/2026 do repositório Portfolio-Digital-HSL/ig_InspiraSA (main), com SUSHI 3.20.1 e IG Publisher 2.3.4.

## exemplos/ (22 arquivos)
Exemplos do guia: Bundle document, duas Compositions (internação por insuficiência cardíaca e colecistectomia com seções vazias) e os recursos referenciados. Declaram os perfis RNDS e os perfis do BR-Core. Validam com 0 erros contra o BR-Core 1.3.0 publicado e contra o main do BR-Core (HL7-BR), e conformam ao FHIR Clinical Documents 1.0.1. `exemplos-inspirasa.zip` traz os mesmos arquivos.

## perfis-rnds/ (4 arquivos)
rnds-sumarioalta (Composition sobre br-core-composition, com as sete seções), rnds-internacao (Encounter sobre br-core-encounter), rnds-documento-sumarioalta (Bundle sobre clinical-document-bundle) e o CapabilityStatement do servidor da RNDS (rnds-servidor-sumarioalta). Com snapshot, como saem do IG Publisher.

## modelo-logico/
StructureDefinition-sumario-alta-ml.json: modelo lógico do Sumário de Alta, com mapeamentos para o BR-Core/RNDS e o SA-IG.

## inspirasa-json.zip
Guia publicado (ImplementationGuide, perfis RNDS, CapabilityStatement, modelo lógico e exemplos, com narrativa), perfis RNDS e terminologia (17 suplementos pt-BR, 4 ValueSets e 2 ConceptMaps para o OCL e o guia de terminologia, não publicados por este guia).
