# Guia Completo — ai-dev-template

> Este documento explica em detalhe como o template funciona, o porquê de cada decisão, e como tirar o máximo proveito dele no desenvolvimento assistido por IA.

---

## Sumario

1. [O Problema que Este Template Resolve](#1-o-problema-que-este-template-resolve)
2. [Filosofia: Por Que Funciona](#2-filosofia-por-que-funciona)
3. [Anatomia do Template — Arquivo por Arquivo](#3-anatomia-do-template--arquivo-por-arquivo)
4. [O Sistema de Sessoes](#4-o-sistema-de-sessoes)
5. [CLAUDE.md — O Cerebro do Projeto](#5-claudemd--o-cerebro-do-projeto)
6. [STATE.md — A Memoria do Projeto](#6-statemd--a-memoria-do-projeto)
7. [O Makefile e a Validacao](#7-o-makefile-e-a-validacao)
8. [Pasta .claude/ — Configuracao do Agente](#8-pasta-claude--configuracao-do-agente)
9. [Arquitetura de Codigo](#9-arquitetura-de-codigo)
10. [Como Adaptar Para Seu Projeto](#10-como-adaptar-para-seu-projeto)
11. [Erros Comuns e Como Evitar](#11-erros-comuns-e-como-evitar)
12. [Exemplos Praticos](#12-exemplos-praticos)

---

## 1. O Problema que Este Template Resolve

Quando voce desenvolve com IA (Claude Code, Cursor, Copilot, etc.), o agente e poderoso mas **burro em contexto**. Ele nao sabe:

- Onde ficam os arquivos do seu projeto
- Qual e a feature atual que voce esta construindo
- Quantos testes existem (e se ele quebrou algum)
- Quais sao as regras do projeto (ex: "nunca use ORM X", "sempre teste primeiro")
- O que ja foi feito e o que falta

**Sem contexto, o agente:**
- Cria arquivos em lugares errados
- Implementa coisas que ja existem
- Quebra testes sem perceber
- Mistura features numa mesma sessao
- Perde tempo explorando o codebase toda vez

**Com este template, o agente:**
- Sabe exatamente onde colocar cada tipo de arquivo (tabela "Where to Modify")
- Sabe qual feature construir agora (STATE.md)
- Valida que nenhum teste quebrou (make validate)
- Segue regras especificas do projeto (Critical Rules)
- Retoma de onde parou, mesmo em conversas novas (STATE.md persiste)

---

## 2. Filosofia: Por Que Funciona

### 2.1. Contexto > Inteligencia

Um agente mediocre com contexto perfeito produz mais que um agente brilhante sem contexto. Este template e 100% sobre dar contexto.

### 2.2. Documentacao como Codigo

Os arquivos `.md` nao sao documentacao para humanos lerem. Sao **instrucoes executaveis** para agentes de IA. Cada arquivo existe para resolver um problema especifico do agente:

| Arquivo | Problema que resolve |
|---------|---------------------|
| `CLAUDE.md` | "Onde fica tal coisa?" |
| `STATE.md` | "O que eu devo fazer agora?" |
| `session-protocol.md` | "Como eu trabalho aqui?" |
| `architecture.md` | "Como o sistema e organizado?" |
| `Makefile` | "Como eu testo/valido?" |

### 2.3. Sessoes = Foco

Um humano pode manter 5 coisas na cabeca. Um agente de IA tambem — ele tem uma janela de contexto limitada. Se voce mistura 3 features na mesma conversa, a qualidade cai drasticamente.

Sessoes resolvem isso: **1 sessao = 1 feature = 1 objetivo claro**.

### 2.4. Validacao Automatica

O agente nao sabe se ele quebrou algo a menos que voce force ele a verificar. O `make validate` e obrigatorio no final de cada sessao justamente para pegar regressoes antes que virem problema.

---

## 3. Anatomia do Template — Arquivo por Arquivo

```
.
├── CLAUDE.md                    [1] Instrucoes para o agente
├── .context/
│   └── STATE.md                 [2] Estado atual do projeto
├── .claude/
│   ├── launch.json              [3] Servidor de preview
│   └── settings.json            [4] Permissoes do agente
├── docs/
│   ├── guide.md                 [5] Este documento
│   ├── session-protocol.md      [6] Protocolo de trabalho
│   └── architecture.md          [7] Arquitetura do sistema
├── src/                         [8] Codigo-fonte
│   ├── api/routes/
│   ├── services/
│   ├── domain/entities/
│   ├── domain/repos/
│   └── infra/
├── tests/                       [9] Testes
├── Makefile                    [10] Atalhos de desenvolvimento
├── pyproject.toml              [11] Configuracao Python
├── .env.example                [12] Variaveis de ambiente
└── .gitignore                  [13] Arquivos ignorados pelo git
```

---

## 4. O Sistema de Sessoes

### O que e uma sessao?

Uma sessao e uma unidade de trabalho focada. Pense assim:

- **Sessao ≠ conversa**. Uma sessao pode durar 1 conversa ou 3.
- **Sessao = 1 feature**. Autenticacao de usuario? Uma sessao. Carrinho de compras? Outra sessao.
- **Sessoes sao sequenciais**. S0 → S1 → S2 → S3. Cada uma pode depender da anterior.

### Por que numerar sessoes?

Porque o agente precisa de **ordem**. Quando ele abre o STATE.md e ve:

```
| S1 | Autenticacao | Done | — |
| S2 | Catalogo     | In Progress | S1 |
| S3 | Carrinho     | Pending | S2 |
```

Ele sabe instantaneamente: "Estou na S2, preciso construir o catalogo, e a autenticacao ja esta pronta pra eu usar."

### Por que rastrear testes?

Porque o **numero de testes so pode subir, nunca descer**. Se a S1 terminou com 15 testes e a S2 termina com 12, algo quebrou. O baseline de testes no STATE.md permite que o agente (e voce) detecte isso imediatamente.

### Ciclo de uma sessao

```
1. Ler STATE.md          → "S2 esta In Progress, feature: Catalogo"
2. Ler CLAUDE.md         → "Para adicionar route, editar src/api/routes/"
3. Escrever teste        → test_catalog_list.py (RED - falha)
4. Implementar           → catalog_service.py + routes (GREEN - passa)
5. make validate         → Todos os testes passam, lint limpo
6. Atualizar STATE.md    → S2 = Done, baseline: 28 testes
7. Commit                → "feat(S2): product catalog"
```

---

## 5. CLAUDE.md — O Cerebro do Projeto

### Por que "CLAUDE.md" e nao "AGENTS.md"?

Porque o Claude Code (e ferramentas como Cursor) le automaticamente arquivos chamados `CLAUDE.md` na raiz do projeto. E carregado no contexto do agente antes de qualquer conversa. Voce nao precisa pedir pro agente ler — ele ja sabe.

### Secoes e por que cada uma existe

#### Project Identity
```markdown
**MeuApp** — API de gerenciamento de eventos com IA
```
**Por que**: O agente precisa saber o que esta construindo. Sem isso, ele faz suposicoes erradas. Uma linha basta.

#### Critical Rules
```markdown
1. Zero regressions: Se um teste passava e agora falha, conserte.
2. One feature per session: Nao misture features.
3. Test first: Escreva o teste antes da implementacao.
```
**Por que**: Regras sao **guardrails**. Sem elas, o agente toma atalhos. Ele vai pular testes, misturar features, e criar bagunca. As regras previnem os erros mais comuns.

**Como personalizar**: Adicione regras especificas do seu projeto. Exemplos:
- "Nunca use SQLAlchemy direto nos services, sempre via repository"
- "Todas as respostas da API devem seguir o formato `{data, error, meta}`"
- "Nunca commite sem rodar os testes"

#### Where to Modify (a tabela mais importante)

```markdown
| I need to... | Files | Tests |
|---|---|---|
| Add an API route | src/api/routes/ | tests/api/ |
| Add a service | src/services/ | tests/services/ |
```

**Por que**: Esta e a tabela que mais economiza tempo. Quando o agente precisa adicionar algo, ele consulta esta tabela em vez de explorar toda a arvore de diretorios. Em um projeto com 200 arquivos, isso evita minutos de busca.

**Como personalizar**: Mapeie TODAS as operacoes comuns do seu projeto. Quanto mais completa a tabela, menos tempo o agente perde.

#### Quick Commands

```markdown
make install    # Instala deps
make test       # Roda testes
make validate   # Validacao completa
```

**Por que**: O agente precisa saber os comandos exatos. Se voce usa `pnpm test` em vez de `npm test`, coloque aqui. Se precisa de flags especiais, coloque aqui.

---

## 6. STATE.md — A Memoria do Projeto

### Por que .context/ e nao na raiz?

Porque o STATE.md muda a cada sessao. Manter em `.context/` separa o **estado mutavel** (STATE.md) da **configuracao estavel** (CLAUDE.md). O CLAUDE.md raramente muda; o STATE.md muda toda sessao.

### Secoes do STATE.md

#### Current Phase
```markdown
**Session 2** — Construindo o catalogo de produtos
```
**Por que**: O agente precisa saber em uma linha o que esta acontecendo AGORA.

#### Session Plan (a tabela de sessoes)
```markdown
| S0 | Setup | Done | — |
| S1 | Auth  | Done | — |
| S2 | Catalog | In Progress | S1 |
```
**Por que**: Mostra o roadmap completo. O agente sabe o que ja foi feito, o que esta fazendo, e o que vem depois. A coluna "Depends On" evita que ele tente construir algo sem as dependencias prontas.

#### Test Baseline
```markdown
| api | 12 |
| services | 8 |
| domain | 5 |
| Total | 25 |
```
**Por que**: Este e o contrato. Se o total cai de 25 para 23, algo esta errado. O agente (e voce) podem detectar regressoes instantaneamente comparando o baseline antes e depois da sessao.

---

## 7. O Makefile e a Validacao

### Por que Makefile e nao scripts?

1. **Universal**: `make` existe em todo sistema operacional
2. **Autodocumentado**: `make help` lista todos os comandos
3. **Composavel**: `make validate` chama `make test` + `make lint` em sequencia
4. **Memoravel**: `make test` e mais facil de lembrar que `uv run pytest tests/ -v --tb=short`

### Por que `make validate` e obrigatorio?

Porque e a unica forma de garantir que a sessao terminou limpa. Sem validacao, voce descobre bugs 3 sessoes depois, quando o contexto ja se perdeu e o conserto e 10x mais dificil.

O `make validate` faz:
1. **Roda TODOS os testes** — nao so os da feature nova
2. **Roda o linter** — pega erros de estilo e imports
3. **Mostra git status** — voce ve o que mudou
4. **Mostra git log** — voce ve os ultimos commits

### Targets importantes

| Target | O que faz | Quando usar |
|--------|-----------|-------------|
| `make install` | Instala dependencias | Inicio do projeto |
| `make test` | Roda todos os testes | Durante desenvolvimento |
| `make test-api` | Roda testes da API | Quando mexeu so na API |
| `make lint` | Verifica estilo | Antes de commitar |
| `make validate` | Tudo junto | Final de cada sessao |
| `make clean` | Remove caches | Quando algo esta estranho |

---

## 8. Pasta .claude/ — Configuracao do Agente

### launch.json — Servidor de Preview

```json
{
  "configurations": [
    {
      "name": "dev-server",
      "runtimeExecutable": "python",
      "runtimeArgs": ["-m", "http.server", "3000"],
      "port": 3000
    }
  ]
}
```

**Por que**: O agente pode iniciar um servidor de preview com `preview_start` e verificar visualmente se as mudancas funcionaram. Sem isso, ele coda "as cegas" e voce precisa verificar manualmente.

**Como personalizar**:
```json
// FastAPI
{ "runtimeExecutable": "uvicorn", "runtimeArgs": ["main:app", "--reload", "--port", "8000"], "port": 8000 }

// Next.js
{ "runtimeExecutable": "npm", "runtimeArgs": ["run", "dev"], "port": 3000 }

// Go
{ "runtimeExecutable": "go", "runtimeArgs": ["run", "."], "port": 8080 }
```

### settings.json — Permissoes

```json
{
  "permissions": {
    "allow": ["Bash(make *)", "Bash(uv *)", "Bash(git status*)"],
    "deny": ["Bash(git worktree *)", "Bash(git branch *)"]
  }
}
```

**Por que deny em worktrees e branches?**

Porque agentes de IA adoram criar branches e worktrees "para seguranca". O problema:
- **Branches**: O agente cria, faz mudancas, esquece de fazer merge, e voce tem 15 branches orfas
- **Worktrees**: Copia inteira do repo que ocupa disco e gera confusao sobre qual e o diretorio "real"

Trabalhar direto no `master` e mais simples, e com `make validate` voce pega problemas antes de commitar.

---

## 9. Arquitetura de Codigo

### Por que Clean Architecture?

Porque ela resolve o problema mais comum de projetos que crescem: **tudo depende de tudo**.

```
SEM arquitetura:        COM arquitetura:

route.py                API (routes)
  └── db.py               └── Services (logic)
  └── email.py                  └── Domain (entities, repos)
  └── cache.py                       ↑
  └── utils.py             Infrastructure (implements repos)
```

**Sem arquitetura**: Trocar o banco de dados significa reescrever metade do codigo.
**Com arquitetura**: Trocar o banco significa criar uma nova implementacao do repositorio. O resto nao muda.

### Camadas explicadas

#### `src/domain/` — O nucleo
- **entities/**: Objetos do negocio (User, Product, Order)
- **repos/**: Interfaces abstratas (UserRepository, ProductRepository)
- **Regra**: ZERO dependencias externas. Puro Python. Sem frameworks, sem bibliotecas.
- **Por que**: Se o dominio nao depende de nada, ele nunca quebra por causa de atualizacao de biblioteca.

#### `src/services/` — A logica
- Orquestra chamadas aos repositorios
- Aplica regras de negocio
- **Regra**: Depende apenas do domain (abstracoeses, nunca implementacoes)
- **Por que**: Isola a logica de negocio. Se voce troca de FastAPI para Flask, os services nao mudam.

#### `src/api/` — A interface
- Routes HTTP, middleware, schemas de request/response
- **Regra**: Fina. Valida input, chama service, retorna resposta. Nenhuma logica de negocio aqui.
- **Por que**: A API e a parte que mais muda (novos endpoints, novos campos). Se ela for fina, mudancas sao rapidas e seguras.

#### `src/infra/` — As implementacoes
- Implementacoes concretas dos repositorios (PostgresUserRepo, RedisCache)
- Clientes de APIs externas
- **Regra**: Implementa interfaces do domain. Nenhum service ou route importa daqui diretamente.
- **Por que**: Permite trocar tecnologias sem afetar o resto (PostgreSQL → MongoDB, Redis → Memcached).

### Por que `tests/` espelha `src/`?

```
src/api/routes/users.py    →    tests/api/test_users.py
src/services/auth.py       →    tests/services/test_auth.py
```

Porque quando o agente cria `src/services/catalog.py`, ele sabe automaticamente que o teste vai em `tests/services/test_catalog.py`. Sem ambiguidade.

---

## 10. Como Adaptar Para Seu Projeto

### Passo 1: Clone e limpe

```bash
git clone https://github.com/devkauania/ai-dev-template.git meu-projeto
cd meu-projeto
rm -rf .git && git init
```

### Passo 2: Defina a identidade

Abra `CLAUDE.md` e substitua:
```markdown
**MeuApp** — Plataforma de agendamento para casas de eventos
```

### Passo 3: Mapeie seus arquivos

A tabela "Where to Modify" deve refletir SEU projeto:

```markdown
| I need to... | Files | Tests |
|---|---|---|
| Add webhook handler | src/webhooks/ | tests/webhooks/ |
| Add n8n workflow | workflows/ | tests/workflows/ |
| Add AI prompt | src/prompts/ | tests/prompts/ |
```

### Passo 4: Planeje suas sessoes

Abra `.context/STATE.md`:

```markdown
| S0 | Setup + CI | Done | — |
| S1 | WhatsApp webhook | In Progress | — |
| S2 | AI qualification flow | Pending | S1 |
| S3 | Pricing engine | Pending | S1 |
| S4 | Visit scheduling | Pending | S2, S3 |
```

### Passo 5: Ajuste os comandos

Se voce usa Node.js em vez de Python, mude o `Makefile`:

```makefile
install:
	pnpm install

test:
	pnpm test

lint:
	pnpm lint
```

### Passo 6: Configure o preview

Mude `.claude/launch.json` para seu servidor de dev:

```json
{
  "configurations": [
    {
      "name": "dev",
      "runtimeExecutable": "pnpm",
      "runtimeArgs": ["dev"],
      "port": 3000
    }
  ]
}
```

---

## 11. Erros Comuns e Como Evitar

### 1. "O agente ignora minhas regras"

**Causa**: As regras estao vagas demais.

Ruim: `"Write clean code"`
Bom: `"Every service must have a NullXxxService fallback. Feature flags control activation."`

Regras especificas sao seguidas. Regras vagas sao ignoradas.

### 2. "O agente mistura features"

**Causa**: STATE.md nao esta claro ou nao tem sessao marcada como "In Progress".

Solucao: Sempre tenha exatamente UMA sessao como "In Progress" no STATE.md.

### 3. "Os testes quebraram e ninguem percebeu"

**Causa**: Nao rodou `make validate` no final da sessao.

Solucao: A regra "Zero regressions" no CLAUDE.md forca o agente a validar. Mas voce tambem deve cobrar: "roda make validate antes de commitar".

### 4. "O agente cria arquivos em lugares errados"

**Causa**: A tabela "Where to Modify" esta incompleta.

Solucao: Adicione TODAS as operacoes comuns. Se o agente criou algo no lugar errado, adicione uma linha na tabela para prevenir na proxima vez.

### 5. "O .env vazou nos testes"

**Causa**: O python-dotenv carrega o `.env` automaticamente.

Solucao: Nos testes, use settings com `_env_file=None` ou `monkeypatch.delenv()` para isolar.

### 6. "O agente quer criar branches"

**Causa**: E o comportamento padrao de muitos agentes.

Solucao: O `settings.json` com `deny: ["Bash(git branch *)"]` bloqueia isso. A regra no CLAUDE.md reforca.

---

## 12. Exemplos Praticos

### Exemplo: Projeto de API REST

```markdown
# MeuApp — CLAUDE.md

## Project Identity
**MeuApp** — API REST para gerenciamento de tarefas

## Critical Rules
1. Zero regressions
2. One feature per session
3. Todas as respostas seguem: { "data": ..., "error": null, "meta": {} }
4. UUID v4 para todos os IDs
5. Timestamps em UTC ISO 8601

## Where to Modify
| I need to... | Files | Tests |
|---|---|---|
| Add endpoint | src/api/routes/ | tests/api/ |
| Add model | src/domain/entities/ | tests/domain/ |
| Add business rule | src/services/ | tests/services/ |
| Add DB query | src/infra/repositories/ | tests/infra/ |
| Add middleware | src/api/middleware/ | tests/api/ |
```

### Exemplo: Projeto de Chatbot

```markdown
# OttoBot — CLAUDE.md

## Project Identity
**OttoBot** — Chatbot WhatsApp com IA para casas de eventos

## Critical Rules
1. Zero regressions
2. One feature per session
3. Todas as respostas do bot devem ter max 300 caracteres
4. Nunca expor dados de clientes nos logs
5. Fallback humano se confianca < 0.7

## Where to Modify
| I need to... | Files | Tests |
|---|---|---|
| Add webhook handler | src/webhooks/ | tests/webhooks/ |
| Add AI prompt | src/prompts/ | tests/prompts/ |
| Add conversation flow | src/flows/ | tests/flows/ |
| Add integration | src/integrations/ | tests/integrations/ |
```

### Exemplo: Projeto Frontend (Next.js)

```markdown
# MeuSite — CLAUDE.md

## Project Identity
**MeuSite** — Landing page com dashboard de metricas

## Critical Rules
1. Zero regressions
2. One feature per session
3. Mobile-first: toda UI comeca no breakpoint 375px
4. Sem bibliotecas de UI: CSS puro com design tokens
5. Acessibilidade: todo elemento interativo tem aria-label

## Where to Modify
| I need to... | Files | Tests |
|---|---|---|
| Add page | src/app/ | tests/pages/ |
| Add component | src/components/ | tests/components/ |
| Add API route | src/app/api/ | tests/api/ |
| Add design token | src/styles/tokens.css | — |
| Add hook | src/hooks/ | tests/hooks/ |
```

---

## Resumo Final

Este template nao e sobre a estrutura de pastas. E sobre **dar contexto para agentes de IA** de forma que eles produzam codigo de qualidade, no lugar certo, sem quebrar nada.

Os 4 pilares:

1. **CLAUDE.md** → O agente sabe ONDE modificar
2. **STATE.md** → O agente sabe O QUE fazer
3. **Session Protocol** → O agente sabe COMO trabalhar
4. **make validate** → O agente PROVA que nao quebrou nada

Se voce manter esses 4 pilares atualizados, qualquer agente de IA vai ser drasticamente mais produtivo no seu projeto.
