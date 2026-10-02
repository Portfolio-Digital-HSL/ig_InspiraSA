# Estrutura do documento

O Sumário de Alta é enviado como **Bundle `document`**: a [Composition](StructureDefinition-sumario-alta.html) é a primeira entrada, seguida de todos os recursos referenciados. Ver o exemplo [documento-sumario-alta-ic](Bundle-documento-sumario-alta-ic.html).

## Cabeçalho

| Elemento | Regra | Observação |
|---|---|---|
| `type` | LOINC 18842-5 Discharge summary | fixo |
| `subject` | 1..1, br-core-patient | paciente não identificado: CNS provisório, não extensão |
| `encounter` | 1..1, [InternacaoSumarioAlta](StructureDefinition-internacao-sumario-alta.html) | invariante sa-2 |
| `author` | 1..* | profissional da alta |
| `custodian` | 1..1, br-core-organization | estabelecimento (CNES) |
| `status` | final, amended, entered-in-error | retificação com `relatesTo` |

## Seções

O `section` é 7..7. Cada seção é 1..1, identificada pelo código LOINC (discriminador `pattern` em `code`) e DEVE ter `entry` ou `emptyReason` (invariante sa-1).

| Fatia | LOINC | Entradas | Antes, no SA-IG |
|---|---|---|---|
| diagnosticosAdmissao | 42347-5 | [DiagnosticoSumarioAlta](StructureDefinition-diagnostico-sumario-alta.html) | parte de problemasDiagnosticosAvaliados |
| alergiasIntolerancias | 48765-2 | [AlergiaSumarioAlta](StructureDefinition-alergia-sumario-alta.html) | alergiaReacaoAdversa |
| diagnosticosAvaliados | 57852-6 | [DiagnosticoSumarioAlta](StructureDefinition-diagnostico-sumario-alta.html) | problemasDiagnosticosAvaliados |
| procedimentosRealizados | 47519-4 | [ProcedimentoSumarioAlta](StructureDefinition-procedimento-sumario-alta.html) | procedimentosRealizados |
| prescricaoAlta | 8654-6 | [PrescricaoAltaSumarioAlta](StructureDefinition-prescricao-alta-sumario-alta.html) | prescricaoAlta via Composition intermediária |
| planoCuidados | 18776-5 | [PlanoCuidadosSumarioAlta](StructureDefinition-plano-cuidados-sumario-alta.html) | planoCuidados (só texto) |
| capacidadeFuncional | 54522-8 | br-core-capacidadefuncional | restricaoFuncionalIncapacidadeSaude (0..1) |

Seção sem conteúdo usa `emptyReason` de `list-empty-reason`: `nilknown` (nada conhecido), `notasked`, `unavailable` etc. Exemplo: [sumario-alta-colecistectomia](Composition-sumario-alta-colecistectomia.html).

## Internação

A [Internação do Sumário de Alta](StructureDefinition-internacao-sumario-alta.html) concentra o que o SA-IG espalhava em seções:

| Informação | Elemento |
|---|---|
| Resumo da evolução clínica | `Encounter.text` (narrativa) |
| Admissão e alta | `period.start`, `period.end` (1..1, invariante isa-1) |
| Caráter do atendimento | `priority` (BRCaraterAtendimento) |
| Procedência | `hospitalization.admitSource` (BRProcedencia) |
| Desfecho / motivo da alta | `hospitalization.dischargeDisposition` (BRMotivoDesfecho) |
| Diagnósticos com papel | `diagnosis.condition` + `diagnosis.use` (AD admissão, DD alta) |
| Profissional da alta, equipe | `participant.type` (BRResponsabilidadeParticipante) + `participant.individual` |
| Estabelecimento | `serviceProvider` |

## Pai provisório

O `SumarioAlta` deriva de `br-core-composition` e reproduz as sete seções do `br-core-sumarioalta`. O `br-core-sumarioalta` 1.3.0 não aceita nenhuma instância válida (débitos [D-01 e D-02](debitos-tecnicos.html)). Quando o BR-Core corrigir, basta trocar o `Parent`.
