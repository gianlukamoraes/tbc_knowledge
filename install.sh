#!/bin/sh
# TBC Knowledge — Instalador cross-platform
# Funciona em Linux, macOS e Windows (Git Bash / WSL)

set -e

MARKETPLACE_URL="https://github.com/gianlukamoraes/tbc_knowledge.git"
PLUGINS="protheus fluig confluence playwright tae jira-api"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        TBC Knowledge — Instalador        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Verificar se Claude Code está instalado
if ! command -v claude >/dev/null 2>&1; then
  echo "✗ Claude Code não encontrado."
  echo "  Instale em: https://claude.ai/download"
  exit 1
fi

echo "✓ Claude Code encontrado"
echo ""

# Adicionar marketplace
echo "→ Adicionando marketplace TBC Knowledge..."
claude plugin marketplace add "$MARKETPLACE_URL"
echo ""

# Instalar plugins
for plugin in $PLUGINS; do
  echo "→ Instalando $plugin..."
  claude plugin install "${plugin}@tbc_knowledge"
done

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         Instalação concluída! ✓          ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Último passo: configure seu email de acesso."
echo "Abra o Claude Code e execute:"
echo ""
echo "  /protheus:setup"
echo ""
