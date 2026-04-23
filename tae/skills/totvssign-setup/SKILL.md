---
name: totvssign-setup
description: Configura credenciais para o MCP TOTVS Assinatura Eletrônica (TAE). Use quando o MCP totvs-sign não está conectado ou credenciais precisam ser configuradas.
---

# Configuração de Credenciais — TOTVS Sign MCP

O plugin TAE já vem com o MCP server `totvs-sign` configurado.
Esta skill só é necessária se as credenciais ainda não foram configuradas.

## Verificar se está funcionando

Tente usar a tool `totvssign_listPublications`. Se funcionar, não precisa fazer nada.

Se aparecer `getConnectionStatus` como única tool, as credenciais não estão configuradas.

## Configurar Credenciais

O MCP busca credenciais nesta ordem: env vars → config file.

### Opção 1: Variáveis de ambiente (recomendado)

```bash
export TAE_USER_EMAIL="seu-email@suaempresa.com"
export TAE_PASSWORD="sua-senha"
```

### Opção 2: Config file

Adicione `tae_email` e `tae_password` em `~/.config/tbc/dev-config.json` e proteja com `chmod 600`.

```json
{
  "tae_email": "seu-email@suaempresa.com",
  "tae_password": "sua-senha"
}
```

Após configurar, reinicie o Claude Code.
