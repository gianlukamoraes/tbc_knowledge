# TBC Knowledge

Skills TOTVS para desenvolvimento Fluig e Protheus, com acesso ao knowledge base TBC via MCP.

---

## Instalação

Cole no seu terminal e pressione Enter:

**Linux / macOS**
```bash
curl -fsSL https://raw.githubusercontent.com/tbc-servicos/tbc_knowledge/main/install.sh | sh
```

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/tbc-servicos/tbc_knowledge/main/install.ps1 | iex
```

> Requer [Claude Code](https://claude.ai/download) instalado.

---

## Configuração

Após instalar, abra o Claude Code e execute:

```
/protheus:setup
```

O assistente detecta seu sistema operacional e configura tudo automaticamente.

---

## Plugins incluídos

| Plugin | O que faz |
|--------|-----------|
| `protheus` | Skills ADVPL/TLPP — padrões, geração de código, diagnóstico |
| `fluig` | Skills Fluig — widgets Angular, datasets, workflows BPM |
| `confluence` | Integração com Confluence |
| `playwright` | Testes E2E para Protheus |
| `tae` | TOTVS Assinatura Eletrônica |
| `jira-api` | Integração com Jira |

---

## Suporte

fabricadesoftwaretbc@totvs.com.br
