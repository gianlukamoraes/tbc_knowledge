# TBC Knowledge — Instalador para Windows (PowerShell)

$MarketplaceUrl = "https://github.com/gianlukamoraes/tbc_knowledge.git"
$Plugins = @("protheus", "fluig", "confluence", "playwright", "tae", "jira-api")

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗"
Write-Host "║        TBC Knowledge — Instalador        ║"
Write-Host "╚══════════════════════════════════════════╝"
Write-Host ""

# Verificar Claude Code
if (-not (Get-Command "claude" -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Claude Code não encontrado." -ForegroundColor Red
    Write-Host "  Instale em: https://claude.ai/download"
    exit 1
}

Write-Host "✓ Claude Code encontrado" -ForegroundColor Green
Write-Host ""

# Adicionar marketplace
Write-Host "→ Adicionando marketplace TBC Knowledge..."
claude plugin marketplace add $MarketplaceUrl
Write-Host ""

# Instalar plugins
foreach ($plugin in $Plugins) {
    Write-Host "→ Instalando $plugin..."
    claude plugin install "${plugin}@tbc_knowledge"
}

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗"
Write-Host "║         Instalação concluída! ✓          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝"
Write-Host ""
Write-Host "Último passo: abra o Claude Code e execute:"
Write-Host ""
Write-Host "  /protheus:setup" -ForegroundColor Cyan
Write-Host ""
