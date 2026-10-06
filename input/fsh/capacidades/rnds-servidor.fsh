// Requisitos do servidor da RNDS para o Sumário de Alta.
// Autoria: Jussara Macedo Pinho Rötzsch.

Instance: rnds-servidor-sumarioalta
InstanceOf: CapabilityStatement
Usage: #definition
Title: "RNDS: servidor do Sumário de Alta"
Description: "Requisitos que o servidor da RNDS atende para receber o Sumário de Alta: aceita o documento (Bundle) conforme ao rnds-documento-sumarioalta e permite consultá-lo pelo identificador. Endpoint, autenticação e autorização seguem a documentação operacional da RNDS."
* name = "RNDSServidorSumarioAlta"
* title = "RNDS: servidor do Sumário de Alta"
* status = #draft
* experimental = true
* date = "2026-10-06"
* publisher = "Hospital Sírio-Libanês"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[+] = #xml
* implementationGuide = "http://fhir.hsl.org.br/ig/inspirasa/ImplementationGuide/br.org.hsl.inspirasa"
* rest[0].mode = #server
* rest[0].documentation = "O estabelecimento envia o Sumário de Alta como Bundle document (POST [base]/Bundle). Uma retificação é um novo Bundle com Composition.identifier igual ao do original, Composition.relatesTo (code = replaces) apontando o documento substituído e novo Bundle.identifier."
* rest[0].resource[0].type = #Bundle
* rest[0].resource[0].supportedProfile[0] = "http://fhir.hsl.org.br/ig/inspirasa/StructureDefinition/rnds-documento-sumarioalta"
* rest[0].resource[0].interaction[0].code = #create
* rest[0].resource[0].interaction[0].documentation = "Recebe o documento. O servidor DEVE rejeitar Bundle não conforme ao rnds-documento-sumarioalta."
* rest[0].resource[0].interaction[+].code = #read
* rest[0].resource[0].searchParam[0].name = "identifier"
* rest[0].resource[0].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/Bundle-identifier"
* rest[0].resource[0].searchParam[0].type = #token
* rest[0].resource[0].searchParam[+].name = "composition"
* rest[0].resource[0].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Bundle-composition"
* rest[0].resource[0].searchParam[=].type = #reference
