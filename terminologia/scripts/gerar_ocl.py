#!/usr/bin/env python3
"""Gera o arquivo de importação do OCL (JSON Lines) a partir dos recursos FHIR
em fhir/ (Sumário de Alta).

Uso:
    python3 scripts/gerar_ocl.py [--owner MS] [--locale pt] [--versao 0.1.0]
                                 [--sct /orgs/SNOMED/sources/gps/]

Saída: ocl/sumario-alta.jsonl, na ordem Sources, Concepts, Mappings, Source
Versions, Collections, References e Collection Versions.

Regras de conversão
- CodeSystem supplement -> Source (content_type supplement, extras.supplements
  com o canonical HL7 suplementado) + um Concept por código, com o nome em
  português como preferido e o display HL7 em inglês como sinônimo.
- ValueSet -> Collection (collection_type Value Set).
  * Os três ValueSets deste pacote são intensionais (SNOMED CT por hierarquia
    ou sistemas inteiros: Tabela SUS, TUSS, MedDRA, BRMedicamento...).
    O OCL não guarda filtros is-a nem "todo o sistema" como referência
    explícita: a Collection sai sem References e o compose FHIR vai em
    extras.fhir_compose. A expansão fica com o servidor de terminologia
    (ou com References adicionadas depois de carregar a Source SNOMED CT).
- ConceptMap -> só os mapeamentos marcados "Proposto" no comentário, gravados
  na Source de origem (ex.: MS/BRMedDRA, que já tem os demais). equivalent = SAME-AS.
- released = true só quando o recurso FHIR está active. Tudo aqui é draft.
"""
import argparse, glob, json, os

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE = "https://terminologia.saude.gov.br/fhir/"
MAP_TYPE = {"equal": "SAME-AS", "equivalent": "SAME-AS", "wider": "NARROWER-THAN",
            "narrower": "BROADER-THAN", "inexact": "MAPS-TO", "relatedto": "MAPS-TO"}


def comum(owner, d, locale):
    return {"owner": owner, "owner_type": "Organization", "name": d["name"],
            "full_name": d.get("title", d["name"]), "description": d.get("description", ""),
            "default_locale": locale, "supported_locales": locale + ",en", "public_access": "View",
            "canonical_url": d["url"], "custom_validation_schema": "None",
            "publisher": "MS", "experimental": d.get("experimental", False),
            "extras": {"fhir_status": d.get("status"), "experimental": d.get("experimental", False)}}


def versao(tipo, chave, nome, d, a):
    return {"type": tipo, "id": a.versao, chave: nome, "owner": a.owner, "owner_type": "Organization",
            "description": "Versão %s" % a.versao, "released": d.get("status") == "active"}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--owner", default="MS")
    ap.add_argument("--locale", default="pt")
    ap.add_argument("--versao", default="0.1.0")
    ap.add_argument("--sct", default="/orgs/SNOMED/sources/gps/",
                    help="caminho da Source SNOMED CT no OCL de destino")
    a = ap.parse_args()
    src = lambda canon: (a.sct if canon == "http://snomed.info/sct"
                         else "/orgs/%s/sources/%s/" % (a.owner, canon.rsplit("/", 1)[1]))
    rec = [json.load(open(f, encoding="utf-8")) for f in sorted(glob.glob(os.path.join(RAIZ, "fhir", "*.json")))]
    sources, concepts, mappings, sversions, colls, refs, cversions = [], [], [], [], [], [], []

    for d in rec:
        rt = d["resourceType"]
        if rt == "CodeSystem":
            s = {"type": "Source", "id": d["id"], "short_code": d["id"], "source_type": "Dictionary",
                 "case_sensitive": d.get("caseSensitive", True), "content_type": d.get("content", "complete")}
            s.update(comum(a.owner, d, a.locale))
            if d.get("supplements"):
                s["extras"]["supplements"] = d["supplements"]
            sources.append(s)
            for c in d.get("concept", []):
                pt = next((g["value"] for g in c.get("designation", []) if g.get("language", "").startswith("pt")), None)
                nomes = [{"name": pt or c.get("display", c["code"]), "locale": a.locale,
                          "locale_preferred": True, "name_type": "Fully Specified"}]
                if pt and c.get("display"):
                    nomes.append({"name": c["display"], "locale": "en", "locale_preferred": True, "name_type": "Synonym"})
                concepts.append({"type": "Concept", "id": c["code"], "concept_class": "Misc", "datatype": "None",
                                 "source": d["id"], "owner": a.owner, "owner_type": "Organization",
                                 "retired": False, "names": nomes})
            sversions.append(versao("Source Version", "source", d["id"], d, a))
        elif rt == "ConceptMap":
            # Os mapeamentos já existentes no OCL ficam na Source de origem
            # (ex.: MS/BRMedDRA). Só os marcados "Proposto" no comentário são
            # gerados, nessa mesma Source; não se cria Source para o ConceptMap.
            for g in d["group"]:
                dono = g["source"].rsplit("/", 1)[1]
                for e in g["element"]:
                    for t in e.get("target", []):
                        if t["equivalence"] == "unmatched" or not t.get("comment", "").startswith("Proposto"):
                            continue
                        mappings.append({"type": "Mapping", "source": dono, "owner": a.owner,
                                         "owner_type": "Organization", "map_type": MAP_TYPE[t["equivalence"]],
                                         "from_source_url": src(g["source"]), "from_concept_code": e["code"],
                                         "to_source_url": src(g["target"]), "to_concept_code": t["code"],
                                         "extras": {"equivalence": t["equivalence"], "conceptmap": d["url"]}})
        elif rt == "ValueSet":
            c = {"type": "Collection", "id": d["id"], "short_code": d["id"], "collection_type": "Value Set"}
            c.update(comum(a.owner, d, a.locale))
            c["extras"]["fhir_compose"] = d.get("compose", {})
            colls.append(c)
            cversions.append(versao("Collection Version", "collection", d["id"], d, a))

    os.makedirs(os.path.join(RAIZ, "ocl"), exist_ok=True)
    saida = os.path.join(RAIZ, "ocl", "sumario-alta.jsonl")
    with open(saida, "w", encoding="utf-8", newline="\n") as f:
        for linha in sources + concepts + mappings + sversions + colls + refs + cversions:
            f.write(json.dumps(linha, ensure_ascii=False) + "\n")
    print("%s: %d sources, %d concepts, %d mappings, %d collections" % (
        saida, len(sources), len(concepts), len(mappings), len(colls)))


if __name__ == "__main__":
    main()
