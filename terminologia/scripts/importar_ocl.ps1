<#
Importa ocl/sumario-alta.jsonl no OCL recurso a recurso pela API REST,
sem usar o bulk import. Cria o que não existe e atualiza o que já existe.

Uso (PowerShell, na pasta terminologia):
    .\scripts\importar_ocl.ps1 -Api https://<api-do-ocl>
O token é pedido na hora e não fica gravado.

Ordem: Sources, Concepts, Mappings, Source Versions, Collections, References,
Collection Versions (a mesma do arquivo).
#>
param(
    [Parameter(Mandatory = $true)][string]$Api,
    [string]$Arquivo = "ocl/sumario-alta.jsonl",
    [switch]$SemVersoes,
    [switch]$AtualizarConceitos
)
$ErrorActionPreference = "Stop"
$Api = $Api.TrimEnd("/")
$sec = Read-Host "Token OCL" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
$token = ($token -replace '^\s*(Token|Bearer)\s+', '').Trim().Trim('"', "'")
if ($token.Length -ne 40) { Write-Host "Aviso: o token tem $($token.Length) caracteres; tokens do OCL costumam ter 40." -ForegroundColor Yellow }
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json; charset=utf-8" }
$log = "ocl/importacao-$(Get-Date -Format yyyyMMdd-HHmmss).log"

function Chamar($metodo, $url, $corpo) {
    $json = $corpo | ConvertTo-Json -Depth 20 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($json)
    try {
        $r = Invoke-WebRequest -Method $metodo -Uri "$Api$url" -Headers $headers -Body $bytes -UseBasicParsing
        return @{ ok = $true; status = [int]$r.StatusCode; texto = $r.Content }
    } catch {
        $st = 0; $txt = $_.Exception.Message
        if ($_.Exception.Response) { $st = [int]$_.Exception.Response.StatusCode }
        if ($_.ErrorDetails -and $_.ErrorDetails.Message) { $txt = $_.ErrorDetails.Message }
        return @{ ok = $false; status = $st; texto = $txt }
    }
}

function Existe($url) {
    try { Invoke-WebRequest -Method GET -Uri "$Api$url" -Headers $headers -UseBasicParsing | Out-Null; return $true } catch { return $false }
}

function CriarOuAtualizar($urlPost, $urlPut, $corpo, $rotulo, [switch]$NaoAtualizar) {
    if ($urlPut -and (Existe $urlPut)) {
        if ($NaoAtualizar) {
            Write-Host "OK   já existe  $rotulo" -ForegroundColor Green
            return $true
        }
        $r = Chamar "PUT" $urlPut $corpo; $acao = "atualizado"
    } else {
        $r = Chamar "POST" $urlPost $corpo; $acao = "criado"
    }
    $linha = if ($r.ok) { "OK   $acao  $rotulo" } else { "ERRO $($r.status) $acao $rotulo :: $($r.texto)" }
    Write-Host $linha -ForegroundColor ($(if ($r.ok) { "Green" } else { "Red" }))
    Add-Content -Path $log -Value $linha -Encoding UTF8
    return $r.ok
}

function Sem($obj, [string[]]$campos) {
    $h = [ordered]@{}
    foreach ($p in $obj.PSObject.Properties) { if ($campos -notcontains $p.Name) { $h[$p.Name] = $p.Value } }
    return $h
}

# Teste antes de enviar: endereço da API, token e organização
if ($Api -match "ENDERECO|<|>") { Write-Host "Troque -Api pelo endereço real da API do OCL." -ForegroundColor Red; exit 1 }
$primeiro = (Get-Content -Path $Arquivo -Encoding UTF8 -TotalCount 1) | ConvertFrom-Json
try {
    $r = Invoke-WebRequest -Method GET -Uri "$Api/orgs/$($primeiro.owner)/" -Headers $headers -UseBasicParsing
    if ($r.Content -notmatch '"id"') { throw "Resposta não parece da API do OCL (talvez seja o endereço da interface web)." }
    Write-Host "API ok, organização $($primeiro.owner) encontrada." -ForegroundColor Green
} catch {
    Write-Host "Falha no teste de $Api/orgs/$($primeiro.owner)/ :: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Confira o endereço da API (não é o da interface web), o token e se a organização existe." -ForegroundColor Red
    exit 1
}

$tiraComum = @("type", "owner", "owner_type")
$erros = 0
$script:mapsExistentes = @{}
Get-Content -Path $Arquivo -Encoding UTF8 | ForEach-Object {
    if (-not $_.Trim()) { return }
    $o = $_ | ConvertFrom-Json
    $org = "/orgs/$($o.owner)"
    switch ($o.type) {
        "Source" {
            $ok = CriarOuAtualizar "$org/sources/" "$org/sources/$($o.id)/" (Sem $o $tiraComum) "Source $($o.id)"
        }
        "Concept" {
            $ok = CriarOuAtualizar "$org/sources/$($o.source)/concepts/" "$org/sources/$($o.source)/concepts/$($o.id)/" (Sem $o ($tiraComum + "source")) "Concept $($o.source)/$($o.id)" -NaoAtualizar:(-not $AtualizarConceitos)
        }
        "Mapping" {
            # Mapping não tem id estável: consulta os existentes para não duplicar ao reimportar
            if (-not $script:mapsExistentes.ContainsKey($o.source)) {
                $lista = @()
                try { $lista = Invoke-RestMethod -Method GET -Uri "$Api$org/sources/$($o.source)/mappings/?limit=1000" -Headers $headers } catch {}
                $script:mapsExistentes[$o.source] = @($lista | ForEach-Object { "$($_.from_concept_code)|$($_.to_source_url)|$($_.to_concept_code)" })
            }
            $chave = "$($o.from_concept_code)|$($o.to_source_url)|$($o.to_concept_code)"
            if ($script:mapsExistentes[$o.source] -contains $chave) {
                Write-Host "OK   já existe  Mapping $($o.source) $($o.from_concept_code)->$($o.to_concept_code)" -ForegroundColor Green
                $ok = $true
            } else {
                $ok = CriarOuAtualizar "$org/sources/$($o.source)/mappings/" $null (Sem $o ($tiraComum + "source")) "Mapping $($o.source) $($o.from_concept_code)->$($o.to_concept_code)"
            }
        }
        "Source Version" {
            if ($SemVersoes) { return }
            $ok = CriarOuAtualizar "$org/sources/$($o.source)/versions/" "$org/sources/$($o.source)/$($o.id)/" (Sem $o ($tiraComum + "source")) "Source Version $($o.source)/$($o.id)"
        }
        "Collection" {
            $ok = CriarOuAtualizar "$org/collections/" "$org/collections/$($o.id)/" (Sem $o $tiraComum) "Collection $($o.id)"
        }
        "Reference" {
            $r = Chamar "PUT" "$org/collections/$($o.collection)/references/" @{ data = $o.data }
            $ok = $r.ok
            $linha = if ($ok) { "OK   referências $($o.collection) ($($o.data.expressions.Count))" } else { "ERRO $($r.status) referências $($o.collection) :: $($r.texto)" }
            Write-Host $linha -ForegroundColor ($(if ($ok) { "Green" } else { "Red" }))
            Add-Content -Path $log -Value $linha -Encoding UTF8
        }
        "Collection Version" {
            if ($SemVersoes) { return }
            $ok = CriarOuAtualizar "$org/collections/$($o.collection)/versions/" "$org/collections/$($o.collection)/$($o.id)/" (Sem $o ($tiraComum + "collection")) "Collection Version $($o.collection)/$($o.id)"
        }
        default { Write-Host "Tipo ignorado: $($o.type)" }
    }
    if (-not $ok) { $script:erros++ }
}
Write-Host "`nConcluído. Erros: $erros. Log: $log"
