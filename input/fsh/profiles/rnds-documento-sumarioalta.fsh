// Perfil RNDS do Bundle do documento Sumário de Alta (RNDSDocumentoSumarioAlta).
// Deriva do Bundle do FHIR Clinical Documents.
// Autoria: Jussara Macedo Pinho Rötzsch.

Profile: RNDSDocumentoSumarioAlta
Parent: $clindoc-bundle
Id: rnds-documento-sumarioalta
Title: "RNDS Documento do Sumário de Alta"
Description: "Bundle document com que o Sumário de Alta é enviado à RNDS. Restringe o clinical-document-bundle (FHIR Clinical Documents); passa a derivar do br-core-bundle-documento quando ele for publicado."
* ^status = #draft
* ^experimental = true
* identifier 1..1 MS
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* timestamp 1..1 MS
* identifier ^short = "Identificador desta instância do documento (muda a cada emissão; o identificador estável é Composition.identifier)"
* obeys rnds-doc-1 and rnds-doc-3

Invariant: rnds-doc-1
Description: "A primeira entrada DEVE ser a Composition conforme ao BRSumarioAlta."
Severity: #error
Expression: "entry.first().resource.is(Composition) and entry.first().resource.conformsTo('http://fhir.hsl.org.br/ig/inspirasa/StructureDefinition/BRSumarioAlta')"

Invariant: rnds-doc-3
Description: "Bundle.timestamp DEVE ser maior ou igual a Composition.date."
Severity: #error
Expression: "timestamp >= entry.first().resource.date"
