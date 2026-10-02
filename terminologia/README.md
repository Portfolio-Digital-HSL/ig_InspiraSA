# Terminologia do Sumário de Alta

Suplementos, ValueSets e ConceptMap usados pelo IG InspiraSA. Destinados ao OCL
(organização `MS`) e ao guia de terminologia, com URLs canônicas
`https://terminologia.saude.gov.br/fhir/...`. Não são publicados pelo IG.

> Status `draft` e `experimental`. Proposta para deliberação.

## Estrutura

```
input/fsh/suplementos-ptbr.fsh   # 17 CodeSystem supplements (designações pt-BR de CodeSystems HL7)
input/fsh/sumario-alta.fsh       # 3 ValueSets e 1 ConceptMap
fhir/                            # recursos FHIR R4 (gerados)
ocl/sumario-alta.jsonl           # importação do OCL (gerado)
scripts/gerar.sh                 # FSH -> fhir/ -> ocl/
scripts/gerar_ocl.py             # fhir/ -> ocl/
scripts/importar_ocl.ps1         # importação pela API REST (Windows)
```

## Conteúdo

| Tipo | Id | Uso no IG InspiraSA |
|---|---|---|
| CodeSystem supplement | BRSuplementoCondicaoClinica | Condition.clinicalStatus |
| CodeSystem supplement | BRSuplementoCondicaoVerificacao | Condition.verificationStatus |
| CodeSystem supplement | BRSuplementoCategoriaCondicao | Condition.category |
| CodeSystem supplement | BRSuplementoAlergiaClinica | AllergyIntolerance.clinicalStatus |
| CodeSystem supplement | BRSuplementoAlergiaVerificacao | AllergyIntolerance.verificationStatus |
| CodeSystem supplement | BRSuplementoAlergiaTipo | AllergyIntolerance.type |
| CodeSystem supplement | BRSuplementoAlergiaCategoria | AllergyIntolerance.category |
| CodeSystem supplement | BRSuplementoAlergiaCriticidade | AllergyIntolerance.criticality |
| CodeSystem supplement | BRSuplementoGravidadeReacao | AllergyIntolerance.reaction.severity |
| CodeSystem supplement | BRSuplementoSituacaoEvento | Procedure.status |
| CodeSystem supplement | BRSuplementoSituacaoPrescricao | MedicationRequest.status |
| CodeSystem supplement | BRSuplementoIntencaoPrescricao | MedicationRequest.intent |
| CodeSystem supplement | BRSuplementoSituacaoRequisicao | CarePlan.status |
| CodeSystem supplement | BRSuplementoIntencaoRequisicao | CarePlan.intent |
| CodeSystem supplement | BRSuplementoSituacaoAtividadePlano | CarePlan.activity.detail.status |
| CodeSystem supplement | BRSuplementoSituacaoDocumento | Composition.status |
| CodeSystem supplement | BRSuplementoMotivoSecaoVazia | Composition.section.emptyReason |
| ValueSet | BRAlergenosSNOMEDNacional | AllergyIntolerance.code.coding[snomed] |
| ValueSet | BRManifestacaoReacaoSNOMED | AllergyIntolerance.reaction.manifestation |
| ValueSet | BRProcedimentosSUSSaudeSuplementar | Procedure.code |
| ConceptMap | BRMedDRAParaSNOMED | MedDRA (Anvisa) para SNOMED CT |

## Pendências

- **CBHPM**: fora do ValueSet de procedimentos. É da AMB, de uso licenciado e
  pago, e não está no OCL; o ValueSet usa só BRTabelaSUS e TUSS 22.
- **BRMedDRAParaSNOMED**: reproduz os 25 mapeamentos que já estão no OCL
  (Source MS/BRMedDRA). O JSONL só leva o que falta: Angioedema (10002424) →
  SNOMED CT 41291007, proposta, gravado na própria Source BRMedDRA.
- **CBARA**: no OCL, `BRAlergenosCBARA` tem 25 códigos nacionais mapeados
  (SAME-AS) para SNOMED CT. O mapeamento de `veneno-vespa` aponta para
  `/orgs/SNOMED/sources/sct/`, que não existe; deve apontar para
  `/orgs/SNOMED/sources/gps/`. No guia de terminologia o CodeSystem continua
  `not-present`.

## Subir no OCL

Os ValueSets são intensionais (hierarquias SNOMED CT ou sistemas inteiros). O
OCL não guarda filtros `is-a` nem "todo o sistema" como referência: as
Collections saem sem References, com o `compose` FHIR em
`extras.fhir_compose`. A expansão fica com o servidor de terminologia, ou com
References adicionadas depois que a Source SNOMED CT estiver no OCL.

O mapeamento aponta para a Source SNOMED CT do OCL, `/orgs/SNOMED/sources/gps/`
(canonical `http://snomed.info/sct`), onde estão todos os códigos usados aqui.
Se no servidor ela estiver em outro caminho, gere de novo:

```bash
python3 scripts/gerar_ocl.py --sct /orgs/<org>/sources/<source>/
```

Importação no Windows (PowerShell), a partir desta pasta:

```powershell
$env:OCL_TOKEN = "<seu token>"
.\scripts\importar_ocl.ps1 -Api https://oclapi2.ips.hsl.org.br
```

## Regenerar

```bash
./scripts/gerar.sh      # requer Node 20+ e Python 3
```
