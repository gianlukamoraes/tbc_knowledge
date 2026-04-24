# TBC Knowledge — Próximos Passos

> Documento de planejamento pós-MVP. Atualizado em: 2026-04-23.
> Estado atual: produto funcionando em produção, separação interno/externo validada.

---

## Contexto

O MVP está operacional:
- Plugin instalável via one-liner (`install.sh` / `install.ps1`)
- Auto-registro trial de 30 dias para qualquer email novo
- Banco externo (`knowledge_external.db`) isolado do banco interno TBC
- Admin dashboard em `https://mcp.totvstbc.com.br/admin/`
- Segurança validada: dev externo nunca acessa `encryption_key` nem módulos internos TBC

O que falta para virar produto vendável.

---

## 1. Expandir o banco externo

**Prioridade: ALTA — é o principal vetor de valor percebido pelo trial**

O banco atual tem 35 funções e 17 endpoints — conteúdo básico de referência. Para o dev externo ter uma experiência que justifique pagar, o banco precisa de padrões reais.

### O que adicionar (só conteúdo público / derivado de TDN)

| Tipo | Exemplos | Volume estimado |
|------|----------|-----------------|
| Pontos de Entrada por módulo | `SIGAFAT`, `SIGACOM`, `SIGAEST`, `SIGACRM` | ~150 PEs documentados |
| Templates REST (TLPP) | `@Get`, `@Post`, `@Put`, autenticação OAuth2, paginação | ~30 templates |
| Padrões MVC | `ModelDef`, `ViewDef`, triggers de validação, grids | ~20 padrões |
| ExecAuto patterns | `MATA103`, `MATA140`, `FINA080` — parâmetros e fluxo | ~40 rotinas |
| SmartView objects | Business Objects do SIGAFAT, SIGACOM | ~20 objetos |
| Erros comuns | Mensagens de erro → causa → solução | ~50 entradas |

### Como fazer
```bash
# Editar e expandir kb-builder/seed-external.js no auth_server_skills
# Testar localmente
node kb-builder/seed-external.js
# Deploy: copiar o db para o servidor
scp data/knowledge_external.db hostinger6:/root/docker/auth-server/data/
```

---

## 2. Fluxo de expiração do trial

**Prioridade: ALTA — sem isso não tem conversão**

Quando o trial expira, o servidor já retorna HTTP 402 com `checkout_url`. O `connect-remote.js` precisa exibir uma mensagem clara para o dev.

### O que verificar/implementar
- [ ] Testar o fluxo real: forçar `expires_at` no passado e confirmar que o Claude Code exibe a mensagem de expiração
- [ ] Garantir que a mensagem no terminal é legível (não um stack trace)
- [ ] A `checkout_url` deve apontar para a página de pagamento

```bash
# Testar expiração: forçar expires_at no passado para um email trial
# No container auth-server:
UPDATE users SET expires_at = '2020-01-01' WHERE email = 'gianluka.moraes@gmail.com';
```

---

## 3. Página de pagamento

**Prioridade: ALTA — destino do dev quando o trial expira**

Já existe `public/payment.html` com layout de 3 tiers. Precisa de conteúdo real.

### O que definir
- [ ] Preços reais para cada tier (Builder / Studio / Platform)
- [ ] Modelo: por dev/mês, por empresa, ou créditos?
- [ ] CTA: formulário de contato, WhatsApp, ou email direto?
- [ ] Considerar link para agendar uma demo

### Referência de modelo de pricing (do jCodeMunch-MCP estudado)
- Tier individual: R$ X/dev/mês (acesso ao banco + skills)
- Tier time: R$ Y/time até N devs
- Tier empresa: R$ Z/org, devs ilimitados

---

## 4. Email transacional

**Prioridade: MÉDIA — melhora conversão e retenção**

Sem email, o dev esquece que tem trial ativo e perde a janela de conversão.

| Gatilho | Assunto | Conteúdo |
|---------|---------|----------|
| Auto-registro | "Seu trial TBC Knowledge está ativo" | Link para docs, skills disponíveis |
| 7 dias antes do vencimento | "Seu trial expira em 7 dias" | Benefícios + link pagamento |
| Expiração | "Seu trial expirou" | Link para ativar plano |

### Opções de implementação
- **Resend** (simples, gratuito até 3k/mês) — recomendado para MVP
- **Mailgun** — já estava no plano original
- Trigger: no `POST /auth` quando `status = 'auto_registered_trial'`

---

## 5. Distribuição — tornar o install acessível

**Prioridade: MÉDIA**

O one-liner funciona, mas o repositório está em conta pessoal `gianlukamoraes`. Para uma marca profissional:

- [ ] Criar organização GitHub `tbc-devai` (ou usar `tbc-servicos`)
- [ ] Mover `tbc_knowledge` para a org
- [ ] Atualizar URLs nos `install.sh`, `install.ps1`, `README.md`
- [ ] Criar landing page simples (pode ser GitHub Pages do repositório)

---

## 6. Melhorias no admin dashboard

**Prioridade: MÉDIA**

O dashboard atual mostra sessões e logs. Para gerenciar clientes externos:

- [ ] Filtro por tier: `internal` / `trial` / `standard` / `expired`
- [ ] Botão "Ativar plano pago" que muda `tier='standard'` e renova `expires_at`
- [ ] Coluna de última atividade (última chamada de tool)
- [ ] Exportar lista de trials para CSV (para abordagem comercial)

---

## 7. Rate limiting por tier

**Prioridade: BAIXA — só necessário com volume**

Para evitar abuso do trial e criar incentivo para upgrade:

| Tier | Limite sugerido |
|------|-----------------|
| `trial` | 100 tool calls/dia |
| `standard` | 2.000 tool calls/dia |
| `internal` | ilimitado |

Implementar em `mcp-middleware/server.js` com contador em `mcp-middleware.db`.

---

## 8. Testes automatizados

**Prioridade: BAIXA — mas importante antes de crescer**

Garantir que mudanças no servidor não quebrem o fluxo de um dev interno já em uso:

- [ ] `test/auth-trial.test.js` — auto-registro, idempotência, 402, flag OFF
- [ ] `test/knowledge-tier-isolation.test.js` — dev externo não acessa banco interno
- [ ] `test/regression-internal.test.js` — dev interno recebe `encryption_key`, conecta e usa tools

---

## Ordem de execução recomendada

```
Sprint 1 (agora):
  → Expandir banco externo com PEs e padrões
  → Definir preços e atualizar payment.html
  → Testar fluxo de expiração do trial end-to-end

Sprint 2:
  → Implementar email transacional (Resend)
  → Mover repo para org ou domínio próprio

Sprint 3:
  → Melhorias no admin (filtros, botão ativar)
  → Rate limiting se houver volume
  → Testes automatizados
```

---

## Dependências entre repos

| Mudança | Repo | Afeta |
|---------|------|-------|
| Expandir banco externo | `auth_server_skills` | prod deploy necessário |
| Email transacional | `auth_server_skills` | nenhum impacto no plugin |
| Pricing na payment.html | `auth_server_skills` | nenhum impacto no plugin |
| Mudar URL do repo | `tbc_knowledge` + `auth_server_skills` | reinstall para usuários existentes |
| Rate limiting | `auth_server_skills` | transparente para o plugin |
