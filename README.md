# IG InspiraSA

Guia de Implementação FHIR **R4 (4.0.1)** do projeto InspiraSA, escrito em
[FHIR Shorthand (FSH)](https://hl7.org/fhir/uv/shorthand/) e compilado com
[SUSHI](https://fshschool.org/docs/sushi/) + [IG Publisher](https://github.com/HL7/fhir-ig-publisher).

## Conteúdo

Sumário de Alta hospitalar derivado do BR-Core 1.3.0, substituindo o SA-IG legado da RNDS.

| Perfil | Pai |
|---|---|
| SumarioAlta (`sumario-alta`) | br-core-composition (provisório; ver débitos D-01 e D-02) |
| InternacaoSumarioAlta | br-core-encounter |
| DiagnosticoSumarioAlta | br-core-condition |
| AlergiaSumarioAlta | br-core-allergyintolerance |
| ProcedimentoSumarioAlta | br-core-procedure |
| PrescricaoAltaSumarioAlta | br-core-medicationrequest |
| PlanoCuidadosSumarioAlta | br-core-careplan |

Capacidade funcional usa o `br-core-capacidadefuncional` direto.

- `json/`: perfis e exemplos em JSON, e `perfis-inspirasa.zip`.
- `terminologia/`: suplementos pt-BR, ValueSets e ConceptMap para o OCL e o guia de terminologia (não publicados pelo IG). Ver `terminologia/README.md`.

### Tradução para português

Os textos herdados do FHIR em inglês são traduzidos por RuleSets gerados:

```bash
npx sushi build . --snapshot
python3 scripts/traducao_ptbr.py   # gera input/fsh/traducao/*.fsh
npx sushi build . --snapshot
```

## Pré-requisitos

| Ferramenta | Versão | Para quê |
|---|---|---|
| Node.js | >= 20 | rodar o SUSHI |
| Java (JDK) | **17** | rodar o IG Publisher (testado com Temurin/OpenJDK 17.0.20) |
| Ruby + Jekyll | Ruby 3.x, Jekyll 4.x | o IG Publisher usa o Jekyll para gerar o site |

```bash
# macOS (Homebrew)
brew install node openjdk@17 ruby
gem install jekyll
```

O `openjdk@17` do Homebrew é *keg-only* — não entra no PATH sozinho. Exporte o
`JAVA_HOME` antes de buildar (ou fixe no seu `~/.zshrc`):

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export PATH="$JAVA_HOME/bin:$PATH"
```

Confira com `java -version` — precisa dizer 17.x. Se disser outra coisa, o
`npm run build` falha com `UnsupportedClassVersionError`.

O SUSHI **não** precisa ser instalado globalmente: a versão usada pelo projeto está
fixada no `package.json` e é instalada com `npm install`.

## Primeiros passos

```bash
npm install
```

### 1. Compilar só o FSH (rápido, poucos segundos)

Valida a sintaxe FSH e gera os recursos em `fsh-generated/resources/`.
É o comando do dia a dia enquanto se escreve perfil.

```bash
npm run fsh
```

### 2. Gerar o guia completo (lento, vários minutos)

Roda o SUSHI **da versão fixada no `package.json`** e em seguida o IG Publisher,
produzindo o site navegável em `output/`.

O publisher também sabe chamar o SUSHI sozinho, mas chamaria o binário **global**
da máquina de cada um — por isso o script usa `nosushi` e roda o SUSHI fixado
antes. Assim todo mundo compila com a mesma versão.

Se o `publisher.jar` não estiver em `~/.fhir/tools/publisher/`, baixe-o uma vez
(~230 MB). O `./_build.sh update` faz isso, mas é interativo e trava em CI;
o equivalente direto é:

```bash
mkdir -p ~/.fhir/tools/publisher
curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar \
  -o ~/.fhir/tools/publisher/publisher.jar
```

```bash
npm run build
```

Abra o resultado em **`output/en/index.html`**.

> O `output/index.html` da raiz é só um stub de 544 bytes com o cabeçalho de
> publicação — o site navegável fica dentro da pasta do idioma.

## Estrutura

```
sushi-config.yaml          # metadados do IG (id, canonical, versão, dependências)
ig.ini                     # aponta o IG Publisher para o template
input/
  fsh/
    profiles/              # Profile: ...
    extensions/            # Extension: ...
    valuesets/             # ValueSet: ...
    codesystems/           # CodeSystem: ...
    instances/             # Instance: ... (exemplos)
  pagecontent/             # páginas em Markdown do site (index.md, etc.)
  images/                  # imagens referenciadas nas páginas
  includes/                # menu.xml customizado, fragmentos HTML
  ignoreWarnings.txt       # warnings do QA aceitos conscientemente
fsh-generated/             # GERADO — não versionar, não editar
output/                    # GERADO — não versionar
```

Arquivos `.fsh` podem ter qualquer nome e ficar em qualquer subpasta de `input/fsh/`;
a divisão acima é só convenção para manter o projeto navegável.

## Convenções

- Um artefato por arquivo, nome do arquivo em `kebab-case` refletindo o `Id`.
- `Id` dos artefatos em `kebab-case` (ex.: `paciente-inspira-rac`).
- `Name` (nome computável) em `PascalCase` (ex.: `PacienteInspiraSA`).
- Todo perfil precisa de `Title` e `Description` preenchidos — o QA do IG Publisher reclama sem eles.
- Todo perfil deve ter pelo menos um exemplo em `input/fsh/instances/`.

## Pendências deste scaffold

Antes do primeiro uso real, confirmar em `sushi-config.yaml`:

- [ ] `id` (`br.org.hsl.inspirasa`) e `canonical` (`http://fhir.hsl.org.br/ig/inspirasa`) — **valores provisórios**, precisam da definição oficial do projeto
- [ ] `dependencies:` — decidir se o guia vai se apoiar no `hl7.fhir.br.core` e em qual versão
- [ ] `license:` — está comentado
- [ ] Apagar `input/fsh/profiles/exemplo-paciente.fsh` quando o primeiro perfil real entrar
- [ ] `ig.ini` usa `fhir2.base.template#current` (referência móvel); avaliar fixar uma versão quando o guia estabilizar

## Estado do build

Validado em 22/09/2026 com IG Publisher 2.3.4, SUSHI 3.20.1 e JDK 17.0.20.1:
**0 erros, 0 warnings, 0 links quebrados**, 1204 arquivos em `output/`.

Mantenha esse placar em zero — warning que se acumula vira warning que ninguém lê.
Quando um warning for legítimo e aceitável, documente o motivo em
`input/ignoreWarnings.txt` em vez de simplesmente conviver com ele.
