# Implementação na RNDS

Esta página é para quem implementa o envio do Sumário de Alta à RNDS: sistemas hospitalares e integradores.

## O que enviar

Um **Bundle `document`** conforme ao [RNDS Documento do Sumário de Alta](StructureDefinition-rnds-documento-sumarioalta.html), com:

1. a Composition conforme ao [RNDS Sumário de Alta](StructureDefinition-rnds-sumarioalta.html) como primeira entrada;
2. todos os recursos que a Composition referencia, cada um com `fullUrl`.

O servidor da RNDS aceita o documento conforme a [declaração de capacidades](CapabilityStatement-rnds-servidor-sumarioalta.html): `POST [base]/Bundle`. Endpoint, certificado, autenticação e autorização seguem a documentação operacional da RNDS.

## Perfis

Os perfis RNDS só restringem perfis do BR-Core e do FHIR Clinical Documents. Não criam elementos, extensões nem terminologia.

| Recurso | Perfil RNDS | Deriva de | O que acrescenta |
|---|---|---|---|
| Bundle | [rnds-documento-sumarioalta](StructureDefinition-rnds-documento-sumarioalta.html) | `clinical-document-bundle` (`br-core-bundle-documento` quando publicado) | `identifier` e `timestamp` obrigatórios; Composition RNDS como primeira entrada; `timestamp` ≥ `Composition.date` |
| Composition | [rnds-sumarioalta](StructureDefinition-rnds-sumarioalta.html) | `br-core-sumarioalta`; impõe `clinical-document-composition` | `identifier`, `subject`, `encounter`, `custodian` e atestador legal obrigatórios; `type` 18842-5; `category` 107903-7; toda seção com `entry` ou `emptyReason` |
| Encounter | [rnds-internacao](StructureDefinition-rnds-internacao.html) | `br-core-encounter` | internação encerrada (`status = finished`, `class = IMP`); resumo da evolução em `text`; data da alta; profissional da alta; `hospitalization` |

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
| Composition.identifier com `system` e `value`, estável entre versões do documento | rnds-sumarioalta |
| Bundle.identifier com `system` e `value`, novo a cada emissão | rnds-documento-sumarioalta |
| `Composition.encounter` aponta a internação conforme ao rnds-internacao | rnds-sumarioalta |
| `Composition.custodian`: estabelecimento (CNES) | rnds-sumarioalta |
| Atestador legal com data e profissional (rnds-sa-1) | rnds-sumarioalta |
| Seção com `entry` ou `emptyReason` (rnds-sa-2) | rnds-sumarioalta, em cada seção |
| Internação encerrada, com data da alta e profissional da alta (rnds-int-1) | rnds-internacao |
| Composition RNDS na primeira entrada (rnds-doc-1); `timestamp` ≥ `Composition.date` (rnds-doc-3) | rnds-documento-sumarioalta |
| Sete seções, códigos LOINC das seções, terminologias | br-core-sumarioalta e perfis das seções |

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
  -profile http://fhir.hsl.org.br/ig/inspirasa/StructureDefinition/rnds-documento-sumarioalta
```

Exemplo completo: [documento-sumario-alta-ic](Bundle-documento-sumario-alta-ic.html). Exemplo com seções vazias: [sumario-alta-colecistectomia](Composition-sumario-alta-colecistectomia.html).

## Estado da validação

Contra o BR-Core 1.3.0 publicado, os exemplos acusam os defeitos D-01 e D-02 do `br-core-sumarioalta`. Contra o BR-Core corrigido (HL7-BR, `main`), os 22 exemplos validam sem erro, com os perfis RNDS aplicados. Ver [Débitos técnicos](debitos-tecnicos.html).

O canonical deste guia (`http://fhir.hsl.org.br/ig/inspirasa`) é provisório. Na publicação pela RNDS, os perfis passam para o canonical da RNDS.
