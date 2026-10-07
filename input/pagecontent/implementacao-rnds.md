# Implementação na RNDS

Esta página é para quem implementa o envio do Sumário de Alta à RNDS: sistemas hospitalares e integradores.

## O que enviar

Um **Bundle `document`** conforme ao [BRDocumentoSumarioAlta](StructureDefinition-BRDocumentoSumarioAlta.html), com:

1. a Composition conforme ao [BRSumarioAlta](StructureDefinition-BRSumarioAlta.html) como primeira entrada;
2. todos os recursos que a Composition referencia, cada um com `fullUrl`.

O servidor da RNDS aceita o documento conforme a [declaração de capacidades](CapabilityStatement-rnds-servidor-sumarioalta.html): `POST [base]/Bundle`. Endpoint, certificado, autenticação e autorização seguem a documentação operacional da RNDS.

## Perfis

Os perfis RNDS derivam de perfis do BR-Core e do FHIR Clinical Documents. Não criam elementos, extensões nem terminologia.

| Recurso | Perfil RNDS | Deriva de | O que acrescenta |
|---|---|---|---|
| Bundle | [BRDocumentoSumarioAlta](StructureDefinition-BRDocumentoSumarioAlta.html) | `clinical-document-bundle` (`br-core-bundle-documento` quando publicado) | `identifier` e `timestamp` obrigatórios; Composition RNDS como primeira entrada; `timestamp` ≥ `Composition.date` |
| Composition | [BRSumarioAlta](StructureDefinition-BRSumarioAlta.html) | `br-core-composition`; impõe `clinical-document-composition` | as sete seções (LOINC, perfis do BR-Core nas entradas); `identifier`, `subject`, `encounter`, `custodian` e atestador legal obrigatórios; `type` 18842-5; `category` 107903-7; toda seção com `entry` ou `emptyReason` |
| Encounter | [BRInternacao](StructureDefinition-BRInternacao.html) | `br-core-encounter` | internação encerrada (`status = finished`, `class = IMP`); resumo da evolução em `text`; data da alta; profissional da alta; `hospitalization` |

Os demais recursos usam os perfis do BR-Core sem restrição adicional:

| Conteúdo | Perfil |
|---|---|
| Paciente | `br-core-patient` (raça/cor obrigatória, extensão do IPS-BR) |
| Profissional, estabelecimento | `br-core-practitioner`, `br-core-organization` |
| Diagnósticos | `br-core-condition` |
| Alergias e intolerâncias | `br-core-allergyintolerance` |
| Procedimentos | `br-core-procedure` |
| Prescrição de alta | `br-core-medicationrequest` + `br-core-medication` |
| Plano de cuidados | `br-core-careplan` |
| Capacidade funcional | `br-core-capacidadefuncional` |

## Regras que o validador aplica

| Regra | Onde |
|---|---|
| Composition.identifier com `system` e `value`, estável entre versões do documento | BRSumarioAlta |
| Bundle.identifier com `system` e `value`, novo a cada emissão | BRDocumentoSumarioAlta |
| `Composition.encounter` aponta a internação conforme ao BRInternacao | BRSumarioAlta |
| `Composition.custodian`: estabelecimento (CNES) | BRSumarioAlta |
| Atestador legal com data e profissional (rnds-sa-1) | BRSumarioAlta |
| Seção com `entry` ou `emptyReason` (rnds-sa-2) | BRSumarioAlta, em cada seção |
| Internação encerrada, com data da alta e profissional da alta (rnds-int-1) | BRInternacao |
| Composition RNDS na primeira entrada (rnds-doc-1); `timestamp` ≥ `Composition.date` (rnds-doc-3) | BRDocumentoSumarioAlta |
| Sete seções e seus códigos LOINC | BRSumarioAlta |
| Terminologias dos recursos | perfis do BR-Core |

As regras de uso que o validador não tem como aplicar estão em [Estrutura do documento](estrutura.html).

## Retificação

Uma retificação é um novo Bundle com:

- novo `Bundle.identifier`;
- `Composition.identifier` igual ao do documento original;
- `Composition.relatesTo.code = replaces` e `relatesTo.targetReference` ou `targetIdentifier` apontando o documento substituído;
- `Composition.status = amended`.

## Validação local

Antes de enviar, valide o Bundle com o validador FHIR:

```bash
java -jar validator_cli.jar documento.json -version 4.0.1 \
  -ig br.org.hsl.inspirasa#current \
  -profile http://fhir.hsl.org.br/ig/inspirasa/StructureDefinition/BRDocumentoSumarioAlta
```

Exemplo completo: [documento-sumario-alta-ic](Bundle-documento-sumario-alta-ic.html). Exemplo com seções vazias: [sumario-alta-colecistectomia](Composition-sumario-alta-colecistectomia.html).

## Estado da validação

Os 22 exemplos validam sem erro contra o BR-Core 1.3.0 publicado (IG Publisher, 07/10/2026) e contra o `main` do BR-Core, com os perfis RNDS aplicados. Ver [Débitos técnicos](debitos-tecnicos.html).

O canonical deste guia (`http://fhir.hsl.org.br/ig/inspirasa`) é provisório. Na publicação pela RNDS, os perfis passam para o canonical da RNDS.
