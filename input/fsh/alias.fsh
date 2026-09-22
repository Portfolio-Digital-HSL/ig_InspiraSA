// ═══════════════════════════════════════════════════════════════════════════
// Aliases do guia — use SEMPRE o alias, nunca a URL crua, nos arquivos .fsh.
//
//   * code from $loinc          // sim
//   * code from http://loinc.org // não
//
// Aliases são globais: valem em todos os arquivos .fsh do projeto.
// Ao adicionar um novo, confirme a URL no pacote de origem antes — URL errada
// não quebra o SUSHI, só aparece como erro de terminologia lá no QA.
// ═══════════════════════════════════════════════════════════════════════════

// ─── Terminologias externas ────────────────────────────────────────────────
Alias: $sct    = http://snomed.info/sct
Alias: $loinc  = http://loinc.org
Alias: $ucum   = http://unitsofmeasure.org
Alias: $icd10  = http://hl7.org/fhir/sid/icd-10

// ─── HL7 Terminology (THO) ─────────────────────────────────────────────────
Alias: $v2-0203              = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v2-0131              = http://terminology.hl7.org/CodeSystem/v2-0131
Alias: $v3-ActCode           = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v3-MaritalStatus     = http://terminology.hl7.org/CodeSystem/v3-MaritalStatus
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $condition-clinical   = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-ver-status = http://terminology.hl7.org/CodeSystem/condition-ver-status
Alias: $data-absent-reason   = http://terminology.hl7.org/CodeSystem/data-absent-reason

// ─── Sistemas de identificação ─────────────────────────────────────────────
Alias: $iso3166 = urn:iso:std:iso:3166

// ─── Terminologias brasileiras ─────────────────────────────────────────────
// Dependem da entrada do hl7.fhir.br.core em sushi-config.yaml, que ainda não
// foi decidida. Quando entrar, adicione aqui os aliases (CBO, CID-10 BR, CNES,
// raça/cor, etc.) copiando as URLs direto do pacote — não de memória:
//
//   grep -h '"url"' ~/.fhir/packages/hl7.fhir.br.core#<versao>/package/CodeSystem-*.json

// ─── Artefatos deste guia ──────────────────────────────────────────────────
// Atalho para o canonical próprio, útil ao referenciar perfis e extensões:
Alias: $inspirasa = http://fhir.hsl.org.br/ig/inspirasa
