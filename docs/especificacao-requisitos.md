# cultivo-mobile — Especificação de Requisitos

Data da especificação: Ago 2026

## Índice

1. [Visão Geral](#1-visão-geral)
2. [Auth](#2-auth)
3. [Dashboard](#3-dashboard)
4. [Plantas](#4-plantas)
5. [Cultivos](#5-cultivos)
6. [Tarefas](#6-tarefas)
7. [Diário](#7-diário)
8. [Ambientes](#8-ambientes)
9. [Variedade](#9-variedade)
10. [Meio de Cultivo](#10-meio-de-cultivo)
11. [Insumos](#11-insumos)
12. [Analytics](#12-analytics)
13. [Usuário](#13-usuário)
14. [Settings](#14-settings)
15. [Dados Ambientais](#15-dados-ambientais)
16. [Infraestrutura Compartilhada](#16-infraestrutura-compartilhada)
17. [Status de Implementação](#17-status-de-implementação)

---

## 1. Visão Geral

### Stack

- Flutter 3.47.0 / Dart 3.13.0
- Riverpod (StateNotifierProvider)
- GoRouter (navegação)
- Dio (HTTP client)
- Hive (storage offline)
- fl_chart (gráficos)
- image_picker + flutter_image_compress (fotos)
- share_plus (exportação)
- flutter_secure_storage (tokens JWT)

### Arquitetura

Cada feature segue o padrão em `lib/features/<feature>/`:

- `data/<feature>_repository.dart` — camada de acesso à API (Dio)
- `providers/<feature>_provider.dart` — `StateNotifierProvider` com State + Notifier
- `presentation/*_page.dart` — páginas (list, form, detail)
- `presentation/widgets/` — widgets específicos da feature

Modelos ficam em `lib/core/models/`. Widgets compartilhados em `lib/shared/widgets/`.

### API

- **Base URL:** Configurada via `--dart-define=API_BASE_URL=...`. Default: `https://cultivo-dev.pjamil.dev/api`
- **Client:** Dio com interceptors (Auth, Error, Logging)
- **Timeouts:** 30s connect, 30s receive
- **Headers:** `Content-Type: application/json`, `Accept: application/json`
- **Respostas:** Suporta array direto e wrapper paginado `{ "content": [...] }`

### Navegação

GoRouter com `ShellRoute` provide `MainScaffold` (bottom nav + drawer).

**Bottom nav (5 tabs):**

| Index | Rota | Ícone | Label |
|-------|------|-------|-------|
| 0 | `/` | home | Home |
| 1 | `/plantas` | grass | Plantas |
| 2 | `/cultivos` | spa | Cultivos |
| 3 | `/tarefas` | task_alt | Tarefas |
| 4 | `/configuracoes` | settings | Config |

**Drawer (features secundárias):**
Ambientes, Variedades, Meios de Cultivo, Insumos, Analytics, Diário

### Tema

Material 3, cor semente verde (#2E7D32), temas light + dark, `ThemeMode.system`.

---

## 2. Auth

### Modelo: `Usuario` (Hive typeId: 0)

| Campo | Tipo | Obrigatório | Default | Descrição |
|-------|------|-------------|---------|-----------|
| `id` | `int` | sim | — | ID único |
| `nome` | `String` | sim | — | Nome do usuário |
| `email` | `String` | sim | — | Email |
| `papel` | `String` | sim | — | Papel (ADMINISTRADOR/USUARIO) |
| `ativo` | `bool` | não | `true` | Status ativo |
| `dataCadastro` | `DateTime?` | não | `null` | Data de cadastro |

**Getter computado:** `isAdmin` -> `papel == 'ADMINISTRADOR'`

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| POST | `/v1/auth/login` | Login (email + senha) -> JWT tokens |
| POST | `/v1/auth/register` | Registro (nome, email, senha) |
| POST | `/v1/auth/refresh` | Refresh token |
| POST | `/v1/auth/logout` | Logout (invalida refresh token) |

### State Machine

```
initial -> loading -> authenticated
                  -> unauthenticated
                  -> error
```

### Tokens

- Access token + refresh token armazenados em `flutter_secure_storage`
- Android: encrypted SharedPreferences
- iOS: Keychain

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/login` | `LoginPage` | Fora do shell |
| `/register` | `RegisterPage` | Fora do shell |

### Regras de Negócio

- Logout chama endpoint remoto com refresh token (ignora falha), depois limpa tokens locais
- Auto-redirecionamento para `/` após login bem-sucedido
- Erros exibidos via SnackBar

### Bugs Conhecidos

- Testes de integração quebrados: usam `find.byKey(Key('email-input'))` mas os widgets não definem Keys

---

## 3. Dashboard

### Modelo: `DashboardData` (inline)

| Campo | Tipo | JSON Key | Descrição |
|-------|------|----------|-----------|
| `cultivosAtivos` | `int` | `cultivosAtivos` | Cultivos ativos |
| `tarefasPendentes` | `int` | `tarefasPendentes` | Tarefas pendentes |
| `alertasEstoque` | `int` | `alertasEstoque` | Alertas de estoque baixo |
| `atividadesRecentes` | `List<AtividadeRecente>` | `atividadesRecentes` | Feed de atividades |
| `cultivosPorStatus` | `Map<String, int>` | `cultivosPorStatus` | Nao exibido na UI |

### Modelo: `AtividadeRecente`

| Campo | Tipo | JSON Key | Descrição |
|-------|------|----------|-----------|
| `tipo` | `String` | `tipo` | Tipo (PLANTA, CULTIVO, TAREFA, DIARIO) |
| `titulo` | `String` | `titulo` | Titulo |
| `data` | `DateTime` | `data` | Timestamp ISO 8601 |

### Endpoint

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/dashboard` | Dados do dashboard |

### Widgets

- **`SummaryCard`** — Card reutilizavel: icone + valor + titulo
- **`ActivityFeed`** — Lista cronologica de atividades com icones coloridos por tipo

### Rota

| Rota | Página | Contexto |
|------|--------|----------|
| `/` | `DashboardPage` | ShellRoute (bottom nav) |

### Regras de Negocio

- Auto-load no construtor
- Pull-to-refresh
- Card de alertas: vermelho se `alertasEstoque > 0`, cinza caso contrario
- Tipos de atividade: PLANTA=verde, CULTIVO=azul, TAREFA=laranja, DIARIO=roxo

### Gaps

- `cultivosPorStatus` buscado da API mas nao exibido na UI
- Cards sem `onTap` (nao navegam para features)

---

## 4. Plantas

### Modelo: `Planta` (Hive typeId: 3)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `nome` | `String` | sim | — | Nome da planta |
| 2 | `especie` | `String` | sim | — | Espécie |
| 3 | `status` | `String` | não | `'ATIVA'` | Status lifecycle |
| 4 | `dataPlantio` | `DateTime?` | não | `null` | Data de plantio |
| 5 | `dataColheita` | `DateTime?` | não | `null` | Data de colheita |
| 6 | `notas` | `String?` | não | `null` | Notas |
| 7 | `rendimentoGramas` | `double?` | não | `null` | Rendimento em gramas |
| 8 | `variedadeId` | `int?` | não | `null` | FK para Variedade |
| 9 | `meioCultivoId` | `int?` | não | `null` | FK para MeioCultivo |
| 10 | `ambienteId` | `int?` | não | `null` | FK para Ambiente |
| 11 | `usuarioId` | `int?` | não | `null` | FK para Usuario |
| 12 | `comecandoDe` | `String` | não | `'SEMENTE'` | Material de propagação |

### Status

| Status | Cor | Ícone | Significado |
|--------|-----|-------|-------------|
| `ATIVA` | verde | eco | Planta ativa/viva |
| `COLHIDA` | laranja | check_circle | Colhida |
| `PERDIDA` | vermelho | cancel | Perdida/destruída |

**Getter:** `isActive` -> `status == 'ATIVA'`

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/plantas` | Listar |
| GET | `/v1/plantas/:id` | Buscar por ID |
| POST | `/v1/plantas` | Criar |
| PUT | `/v1/plantas/:id` | Atualizar |
| DELETE | `/v1/plantas/:id` | Excluir |
| POST | `/v1/plantas/:id/colher` | Colher |
| POST | `/v1/plantas/:id/perder` | Marcar como perdida |

### Serialização

- `toCreateJson()` mapeia `variedadeId` -> `genetica_id`
- `fromJson()` aceita camelCase e snake_case

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/plantas` | `PlantasListPage` | ShellRoute (bottom nav) |
| `/plantas/nova` | `PlantaFormPage` | Fora do shell |
| `/plantas/:id` | `PlantaDetailPage` | Fora do shell |
| `/plantas/:id/editar` | `PlantaFormPage` | Fora do shell |

### UI

- **Lista:** `PlantaCard` com avatar colorido por status, nome, espécie, data plantio
- **Detalhe:** Card de info + PhotoTimeline + botões de ação
- **Form:** nome (obrigatório), espécie (obrigatório), data plantio, variedade (dropdown), notas

### Regras de Negócio

- Nova planta sempre começa com `status = 'ATIVA'` e `id = 0`
- `dataPlantio` não pode ser futuro (date picker: 2020 -> hoje)
- `comecandoDe` sempre default `'SEMENTE'` (sem campo no form)

### Bugs / Incompleto

- **UI para `colher`/`perder`:** Repository e provider existem mas nenhum botão na UI dispara
- **UI para `meioCultivoId`:** Rastreado no state mas sem dropdown no form
- **UI para `ambienteId`:** Rastreado no state mas sem dropdown no form
- **`comecandoDe`:** Sem campo no form, sempre default
- **Hive:** `comecandoDe` (HiveField 12) não é persistido pelo adapter gerado
- **Fotos:** Botão existe mas upload é placeholder (snackbar)
- **Fotos:** PhotoTimeline recebe `const []` hardcoded — nunca busca da API

---

## 5. Cultivos

### Modelo: `Cultivo` (Hive typeId: 4)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `nome` | `String` | sim | — | Nome do ciclo |
| 2 | `status` | `String` | não | `'PLANEJADO'` | Status lifecycle |
| 3 | `dataInicio` | `DateTime?` | não | `null` | Data início |
| 4 | `dataFim` | `DateTime?` | não | `null` | Data fim |
| 5 | `notas` | `String?` | não | `null` | Notas |
| 6 | `plantaId` | `int?` | não | `null` | FK para Planta |
| 7 | `ambienteId` | `int?` | não | `null` | FK para Ambiente |
| 8 | `usuarioId` | `int?` | não | `null` | FK para Usuario |

### Máquina de Estados (7 fases)

| Status | Cor Badge | Ícone Foto | Terminal |
|--------|-----------|------------|----------|
| `PLANEJADO` | cinza | edit_calendar | não |
| `GERMINANDO` | marrom | spa | não |
| `PLANTADO` | verde claro | grass | não |
| `VEGETATIVO` | verde | park | não |
| `FLORACAO` | rosa | local_florist | não |
| `FRUTIFICACAO` | laranja | eco | não |
| `COLHIDO` | azul | agriculture | **sim** |
| `CANCELADO` | vermelho | cancel | **sim** |

**Fluxo:**
```
PLANEJADO -> GERMINANDO -> PLANTADO -> VEGETATIVO -> FLORACAO -> FRUTIFICACAO -> COLHIDO
     └── [qualquer ativo] ── cancelar -> CANCELADO
```

**Getter:** `isActive` -> `status != 'COLHIDO' && status != 'CANCELADO'`

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/cultivos` | Listar |
| GET | `/v1/cultivos/:id` | Buscar por ID |
| POST | `/v1/cultivos` | Criar |
| PUT | `/v1/cultivos/:id` | Atualizar |
| DELETE | `/v1/cultivos/:id` | Excluir |
| POST | `/v1/cultivos/:id/avancar-estado` | Avançar fase |
| POST | `/v1/cultivos/:id/cancelar` | Cancelar (requer motivo) |
| POST | `/v1/cultivos/:id/colher` | Colher (requer data, quantidade) |

### Serialização

- `toCreateJson()` usa snake_case: `planta_id`, `data_inicio`, `data_fim`, `ambiente_id`
- `toUpdateJson()` omite `planta_id` (imutável após criação)

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/cultivos` | `CultivosListPage` | ShellRoute (bottom nav) |
| `/cultivos/novo` | `CultivoFormPage` | Fora do shell |
| `/cultivos/:id` | `CultivoDetailPage` | Fora do shell |
| `/cultivos/:id/editar` | `CultivoFormPage` | Fora do shell |

### UI

- **Lista:** `CultivoCard` com `StateBadge`
- **Detalhe:** Info + botão "Avançar Estado" + botão "Cancelar Cultivo" + GroupedPhotoTimeline
- **Form:** nome (obrigatório), data início, planta (dropdown), notas
- **StateBadge:** Pill com cor do status
- **GroupedPhotoTimeline:** Fotos agrupadas por `cultivoEstado`

### Regras de Negócio

- Novo cultivo sempre começa como `PLANEJADO`
- Ações de lifecycle só visíveis quando `isActive == true`
- `avancarEstado` é confirmação simples — backend decide próxima fase
- `cancelar` requer motivo (botão desabilitado enquanto vazio)
- `colher` requer data e quantidade

### Incompleto

- **`colher`:** Repository/endpoint existe mas sem provider method e sem UI
- **`ambienteId`:** Rastreado no form state mas sem widget UI — sempre `null`

---

## 6. Tarefas

### Modelo: `Tarefa` (Hive typeId: 8)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `titulo` | `String` | sim | — | Título |
| 2 | `descricao` | `String?` | não | `null` | Descrição |
| 3 | `status` | `String` | não | `'PENDENTE'` | Status |
| 4 | `prioridade` | `String` | não | `'MEDIA'` | Prioridade |
| 5 | `dataCriacao` | `DateTime?` | não | `null` | Data criação |
| 6 | `dataVencimento` | `DateTime?` | não | `null` | Data vencimento |
| 7 | `usuarioId` | `int?` | não | `null` | FK para Usuario |
| 8 | `cultivoId` | `int?` | não | `null` | FK para Cultivo |
| 9 | `recorrencia` | `String?` | não | `null` | Tipo recorrência |
| 10 | `dataFimRecorrencia` | `DateTime?` | não | `null` | Fim da recorrência |

### Status

| Status | Cor Badge | Texto |
|--------|-----------|-------|
| `PENDENTE` | cinza | Pendente |
| `EM_ANDAMENTO` | azul | Em Andamento |
| `CONCLUIDA` | verde | Concluída |

### Prioridade

| Prioridade | Cor Avatar |
|------------|------------|
| `ALTA` | vermelho |
| `MEDIA` | laranja |
| `BAIXA` | verde |

### Recorrência

| Valor | Descrição |
|-------|-----------|
| `NENHUMA` | Sem recorrência |
| `DIARIA` | +1 dia |
| `SEMANAL` | +7 dias |
| `QUINZENAL` | +15 dias |
| `MENSAL` | +1 mês |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/tarefas` | Listar |
| GET | `/v1/tarefas/:id` | Buscar por ID |
| POST | `/v1/tarefas` | Criar |
| PUT | `/v1/tarefas/:id` | Atualizar |
| DELETE | `/v1/tarefas/:id` | Excluir |

### Serialização

- `fromJson()` normaliza: `'pendente'` -> `'PENDENTE'`, `'em_andamento'` -> `'EM_ANDAMENTO'`
- `toCreateJson()` omite `status`, `recorrencia`, `cultivoId`
- `toUpdateJson()` inclui `status` (necessário para marcar como concluída)

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/tarefas` | `TarefasListPage` | ShellRoute (bottom nav) |
| `/tarefas/nova` | `TarefaFormPage` | Fora do shell |
| `/tarefas/:id` | `TarefaDetailPage` | Fora do shell |
| `/tarefas/:id/editar` | `TarefaFormPage` | Fora do shell |
| `/tarefas/calendario` | `CalendarPage` | Fora do shell |

### UI

- **Lista:** `TarefaCard` com avatar por prioridade, badge de status, data vencimento
- **Detalhe:** Info rows (status, prioridade, vencimento, descrição)
- **Form:** título (obrigatório), descrição, data vencimento, prioridade, status, recorrência, data fim recorrência
- **Calendário:** Grid mensal com dots laranjas nos dias com tarefas
- **Calendário:** Bottom sheet ao clicar no dia lista tarefas

### Regras de Negócio

- Título é o único campo obrigatório
- Ao marcar tarefa recorrente como `CONCLUIDA`, cria automaticamente próxima ocorrência
- Recorrência para quando `dataFimRecorrencia` é excedida
- Calendário mostra apenas mês atual (sem navegação entre meses)
- Tarefas atrasadas: texto "Vence:" fica vermelho no card
- Descrição truncada para 50 chars no card

### Incompleto

- Teste de integração espera `Key('titulo-input')` mas widget não define

---

## 7. Diário

### Modelo: `DiarioCultivo` (Hive typeId: 5)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `titulo` | `String` | sim | — | Título |
| 2 | `conteudo` | `String` | sim | — | Conteúdo |
| 3 | `data` | `DateTime?` | não | `null` | Data |
| 4 | `userId` | `int?` | não | `null` | FK para Usuario |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/diario-cultivo` | Listar |
| GET | `/v1/diario-cultivo/:id` | Buscar por ID |
| POST | `/v1/diario-cultivo` | Criar |
| PUT | `/v1/diario-cultivo/:id` | Atualizar |
| DELETE | `/v1/diario-cultivo/:id` | Excluir |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/diario` | `DiarioListPage` | ShellRoute (drawer) |
| `/diario/novo` | `DiarioFormPage` | Fora do shell |
| `/diario/:id` | `DiarioDetailPage` | Fora do shell |
| `/diario/:id/editar` | `DiarioFormPage` | Fora do shell |

### UI

- **Lista:** Card com CircleAvatar azul (ícone livro), título, conteúdo truncado (50 chars), data
- **Detalhe:** Título + data + conteúdo + PhotoTimeline (hardcoded vazio)
- **Form:** título (obrigatório), data (default hoje), conteúdo (obrigatório, 10 linhas)

### Regras de Negócio

- Data default: `DateTime.now()` na criação
- Date picker: 2020 -> hoje

### Incompleto

- PhotoTimeline recebe `const []` hardcoded
- `userId` não editável

---

## 8. Ambientes

### Modelo: `Ambiente` (Hive typeId: 6)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `nome` | `String` | sim | — | Nome |
| 2 | `descricao` | `String?` | não | `null` | Descrição |
| 3 | `tipo` | `String` | sim | `'OUTRO'` | Tipo |
| 4 | `comprimento` | `double?` | não | `null` | Comprimento (m) |
| 5 | `altura` | `double?` | não | `null` | Altura (m) |
| 6 | `largura` | `double?` | não | `null` | Largura (m) |
| 7 | `tempoExposicao` | `String?` | não | `null` | Tempo exposição solar |
| 8 | `orientacao` | `String?` | não | `null` | Orientação |

### Tipos de Ambiente

| Valor | Label |
|-------|-------|
| `INDOOR` | Indoor |
| `OUTDOOR` | Outdoor |
| `ESTUFA` | Estufa |
| `GROW_TENT` | Grow Tent |
| `OUTRO` | Outro |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/ambientes` | Listar |
| GET | `/v1/ambientes/:id` | Buscar por ID |
| POST | `/v1/ambientes` | Criar |
| PUT | `/v1/ambientes/:id` | Atualizar |
| DELETE | `/v1/ambientes/:id` | Excluir |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/ambientes` | `AmbientesListPage` | ShellRoute (drawer) |
| `/ambientes/novo` | `AmbienteFormPage` | Fora do shell |
| `/ambientes/:id` | `AmbienteDetailPage` | Fora do shell |
| `/ambientes/:id/editar` | `AmbienteFormPage` | Fora do shell |

### UI

- **Lista:** CircleAvatar laranja (home_work), nome, tipo
- **Detalhe:** Todos os campos não-nulos
- **Form:** nome (obrigatório), tipo (dropdown), descrição, comprimento + largura (lado a lado), altura, tempo exposição, orientação
## 9. Variedade

### Modelo: `Variedade` (Hive typeId: 2)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID único |
| 1 | `nome` | `String` | sim | — | Nome |
| 2 | `descricao` | `String?` | não | `null` | Descrição |
| 3 | `tipoVariedade` | `String` | sim | `'INDICA'` | Tipo genética |
| 4 | `tipoEspecie` | `String` | sim | `'REGULAR'` | Tipo espécie |
| 5 | `tempoFloracao` | `String?` | não | `null` | Tempo floração |
| 6 | `origem` | `String?` | não | `null` | Origem |
| 7 | `caracteristicas` | `String?` | não | `null` | Características |

### Tipos de Variedade

| Valor | Label |
|-------|-------|
| `INDICA` | Indica |
| `SATIVA` | Sativa |
| `HIBRIDA` | Híbrida |
| `RUDERALIS` | Ruderalis |

### Tipos de Espécie

| Valor | Label |
|-------|-------|
| `REGULAR` | Regular |
| `FEMININA` | Feminina |
| `AUTOMATICA` | Automática |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/geneticas` | Listar |
| GET | `/v1/geneticas/:id` | Buscar por ID |
| POST | `/v1/geneticas` | Criar |
| PUT | `/v1/geneticas/:id` | Atualizar |
| DELETE | `/v1/geneticas/:id` | Excluir |

**Nota:** Endpoint usa `/v1/geneticas` (não `/v1/variedades`). `toCreateJson()` mapeia `tipoVariedade` -> `tipoGenetica`.

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/variedades` | `VariedadeListPage` | ShellRoute (drawer) |
| `/variedades/nova` | `VariedadeFormPage` | Fora do shell |
| `/variedades/:id` | `VariedadeDetailPage` | Fora do shell |
| `/variedades/:id/editar` | `VariedadeFormPage` | Fora do shell |

### UI

- **Lista:** CircleAvatar verde (local_florist), nome, tipo-especie
- **Detalhe:** Todos os campos
- **Form:** nome (obrigatorio), descricao, tipo variedade (dropdown), tipo especie (dropdown), tempo floração, origem, caracteristicas

---

## 10. Meio de Cultivo

### Modelo: `MeioCultivo` (Hive typeId: 7)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID unico |
| 1 | `tipo` | `String` | sim | — | Tipo |
| 2 | `descricao` | `String?` | não | `null` | Descricao |

### Tipos

| Valor | Label |
|-------|-------|
| `solo` | Solo |
| `hidroponia` | Hidroponia |
| `aeroponia` | Aeroponia |
| `substrato` | Substrato |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/meios-cultivos` | Listar |
| GET | `/v1/meios-cultivos/:id` | Buscar por ID |
| POST | `/v1/meios-cultivos` | Criar |
| PUT | `/v1/meios-cultivos/:id` | Atualizar |
| DELETE | `/v1/meios-cultivos/:id` | Excluir |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/meios-cultivo` | `MeioCultivoListPage` | ShellRoute (drawer) |
| `/meios-cultivo/novo` | `MeioCultivoFormPage` | Fora do shell |
| `/meios-cultivo/:id` | `MeioCultivoDetailPage` | Fora do shell |
| `/meios-cultivo/:id/editar` | `MeioCultivoFormPage` | Fora do shell |

### UI

- **Lista:** CircleAvatar azul (water_drop), tipo (nao nome), descricao
- **Detalhe:** Tipo + descricao
- **Form:** tipo (dropdown), descricao

---

## 11. Insumos

### Modelo: `Insumo` (Hive typeId: 9)

| HiveField | Nome | Tipo | Obrigatório | Default | Descrição |
|-----------|------|------|-------------|---------|-----------|
| 0 | `id` | `int` | sim | — | ID unico |
| 1 | `codigo` | `String` | sim | — | Codigo/SKU |
| 2 | `nome` | `String` | sim | — | Nome |
| 3 | `tipo` | `String` | sim | — | Tipo |
| 4 | `quantidade` | `double` | sim | — | Quantidade atual |
| 5 | `unidadeMedida` | `String` | sim | — | Unidade (kg, L, un) |
| 6 | `estoqueMinimo` | `double` | sim | — | Estoque minimo |
| 7 | `dataCadastro` | `DateTime?` | não | `null` | Data cadastro (servidor) |

**Getter:** `isEstoqueBaixo` -> `quantidade <= estoqueMinimo`

### Tipos de Insumo

| Valor | Label |
|-------|-------|
| `ADUBO` | Adubo |
| `SEMENTE` | Semente |
| `DEFENSIVO` | Defensivo |
| `SUBSTRATO` | Substrato |
| `FERRAMENTA` | Ferramenta |
| `OUTRO` | Outro |

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/insumos` | Listar |
| GET | `/v1/insumos/:id` | Buscar por ID |
| POST | `/v1/insumos` | Criar |
| PUT | `/v1/insumos/:id` | Atualizar |
| DELETE | `/v1/insumos/:id` | Excluir |

### Serialização

- `toCreateJson()`: snake_case — `unidade_medida`, `estoque_minimo`
- `toUpdateJson()`: camelCase — omite `codigo`, `tipo`, `unidadeMedida` (imutaveis)

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/insumos` | `InsumosListPage` | ShellRoute (drawer) |
| `/insumos/novo` | `InsumoFormPage` | Fora do shell |
| `/insumos/:id` | `InsumoDetailPage` | Fora do shell |
| `/insumos/:id/editar` | `InsumoFormPage` | Fora do shell |

### UI

- **Lista:** Banner laranja no topo (N insumos com estoque baixo). Cards: CircleAvatar verde/vermelho (se estoque baixo), nome, quantidade unidade
- **Detalhe:** Nome + warning se estoque baixo, codigo, tipo, quantidade, estoque minimo, data cadastro
- **Form:** codigo (obrigatorio), nome (obrigatorio), tipo (dropdown), quantidade + unidade (lado a lado), estoque minimo

### Regras de Negocio

- Alerta visual: `quantidade <= estoqueMinimo`
- Banner no topo da lista com contagem de insumos abaixo do minimo

---

## 12. Analytics

### Modelos (inline)

**`AnalyticsData`:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `rendimentoPorVariedade` | `List<YieldData>` | Rendimento por variedade |
| `duracaoCiclo` | `List<CycleData>` | Duracao por fase |
| `custoPorCultivo` | `List<CostData>` | Custo por cultivo |

**`YieldData`:** `variedade` (String), `rendimentoMedio` (double)

**`CycleData`:** `fase` (String), `diasMedios` (double)

**`CostData`:** `cultivo` (String), `custoTotal` (double)

### Endpoint

| Método | Path | Descrição |
|--------|------|-----------|
| — | `/v1/analytics` | **Não implementado** — retorna dados vazios |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/analytics` | `AnalyticsPage` | ShellRoute (drawer) |

### UI

- **YieldChart:** BarChart — rendimento por variedade (verde)
- **CycleChart:** BarChart — duracao media por fase (cores variadas)
- **CostChart:** BarChart — custo por cultivo (laranja)
- **Export CSV:** Gera CSV com 3 secoes, salva em documents dir, share via share_plus

### Gaps

- Backend nao expoe endpoint — graficos mostram "Sem dados"
- Sem filtro de data

---

## 13. Usuario

### Modelo: `Usuario` (reutilizado do Auth)

### Endpoints

| Método | Path | Descrição |
|--------|------|-----------|
| GET | `/v1/meus-dados` | Buscar perfil |
| PUT | `/v1/meus-dados` | Atualizar nome |
| DELETE | `/v1/minha-conta` | Excluir conta |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/meus-dados` | `MeusDadosPage` | Fora do shell |
| `/meus-dados/editar` | `UsuarioFormPage` | Fora do shell |

### UI

- **Detalhe:** Avatar, nome, email, papel, status, data cadastro + botao "Excluir Conta"
- **Form:** Apenas campo nome (obrigatorio)

### Regras de Negocio

- Excluir conta -> DELETE `/v1/minha-conta` -> logout -> redireciona `/login`
- Apenas nome e editavel

---

## 14. Settings

### Modelo: `SettingsState` (inline)

| Campo | Tipo | Default | Descrição |
|-------|------|---------|-----------|
| `tarefaReminder` | `bool` | `true` | Lembretes de tarefas |
| `estoqueAlert` | `bool` | `true` | Alertas de estoque |

### Rotas

| Rota | Página | Contexto |
|------|--------|----------|
| `/configuracoes` | `SettingsPage` | ShellRoute (bottom nav) |
| `/configuracoes/notificacoes` | `NotificationSettingsPage` | Fora do shell |

### UI

- **SettingsPage:** 3 itens — Notificacoes, Meus Dados, Sobre (v1.0.0)
- **NotificationSettingsPage:** 2 SwitchListTile — Lembretes de Tarefas, Alertas de Estoque

### Bugs / Incompleto

- **Bug:** `NotificationSettingsPage` usa `setState` local em vez do `settingsProvider`
- **Sem persistencia:** Configuracoes resetam no restart do app
- **Sem dark mode toggle**

---

## 15. Dados Ambientais

**Status: NAO IMPLEMENTADO**

- Endpoint definido: `/v1/dados-ambientais` (nao utilizado)
- Diretorio vazio em `lib/features/dados_ambientais/`
- Sem modelo, repository, provider, paginas ou rotas

---

## 16. Infraestrutura Compartilhada

### Widgets Compartilhados

| Widget | Uso |
|--------|-----|
| `MainScaffold` | Shell com AppBar, Drawer, BottomNav |
| `ConfirmationDialog` | Dialogo de confirmacao (destrutivo) |
| `EmptyState` | Estado vazio (icone + titulo + mensagem + acao) |
| `ErrorWidget` | Erro (icone + mensagem + retry) |
| `LoadingOverlay` | Overlay de loading semi-transparente |
| `PhotoTimeline` | Lista vertical de fotos |
| `GroupedPhotoTimeline` | Fotos agrupadas por fase |
| `PhotoGallery` | Grid 3 colunas de thumbnails |
| `PhotoUploadButton` | Botao de upload (camera/galeria) |
| `FullScreenImageViewer` | Visualizacao full-screen com zoom |

### Modelo: `Foto` (Hive typeId: 10)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | `int` | ID unico |
| `url` | `String` | URL imagem completa |
| `thumbnailUrl` | `String?` | URL thumbnail |
| `legenda` | `String?` | Legenda |
| `entityType` | `String` | Tipo entidade (planta, cultivo, diario) |
| `entityId` | `int` | ID da entidade pai |
| `cultivoEstado` | `String?` | Fase do ciclo quando foto tirada |
| `createdAt` | `DateTime?` | Timestamp |

### FotoService

| Método | HTTP | Path |
|--------|------|------|
| `listarPorEntidade` | GET | `/v1/fotos?entityType=&entityId=` |
| `criar` | POST | `/v1/fotos` |
| `excluir` | DELETE | `/v1/fotos/:id` |
| `atualizarLegenda` | PUT | `/v1/fotos/:id` |

### CRUD Generico

Features que usam `CrudRepository<T>` + `CrudNotifier<T>`:
Plantas, Diario, Ambientes, Variedade, Meio de Cultivo, Insumos

### Modelo: `OfflineOperation` (Hive typeId: 11)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | `String` | ID da operacao |
| `operation` | `String` | Metodo HTTP |
| `entity` | `String` | Tipo entidade |
| `entityId` | `int?` | ID entidade |
| `data` | `Map<String, dynamic>?` | Body |
| `url` | `String` | Endpoint |
| `timestamp` | `int` | Timestamp |
| `synced` | `bool` | Sincronizado? |
| `syncedAt` | `DateTime?` | Quando sincronizado |
| `error` | `String?` | Erro |

**Nota:** Infraestrutura de fila offline pronta mas sem scheduler automatico de sync.

### Hive TypeId Registry

| typeId | Modelo |
|--------|--------|
| 0 | Usuario |
| 1 | *(reservado)* |
| 2 | Variedade |
| 3 | Planta |
| 4 | Cultivo |
| 5 | DiarioCultivo |
| 6 | Ambiente |
| 7 | MeioCultivo |
| 8 | Tarefa |
| 9 | Insumo |
| 10 | Foto |
| 11 | OfflineOperation |

---

## 17. Status de Implementacao

| Feature | Modelo | Repo | Provider | Paginas | Rotas | Status |
|---------|--------|------|----------|---------|-------|--------|
| Auth | ✅ | ✅ | ✅ | 2 | 2 | ✅ Completo |
| Dashboard | ✅ inline | ✅ | ✅ | 1 | 1 | ✅ Completo* |
| Plantas | ✅ | ✅ | ✅ | 3 | 4 | ⚠️ Parcial** |
| Cultivos | ✅ | ✅ | ✅ | 3 | 4 | ⚠️ Parcial*** |
| Tarefas | ✅ | ✅ | ✅ | 4 | 5 | ✅ Completo |
| Diario | ✅ | ✅ | ✅ | 3 | 4 | ⚠️ Parcial**** |
| Ambientes | ✅ | ✅ | ✅ | 3 | 4 | ✅ Completo |
| Variedade | ✅ | ✅ | ✅ | 3 | 4 | ✅ Completo |
| Meio Cultivo | ✅ | ✅ | ✅ | 3 | 4 | ✅ Completo |
| Insumos | ✅ | ✅ | ✅ | 3 | 4 | ✅ Completo |
| Analytics | ✅ inline | ✅ | ✅ | 1 | 1 | ⚠️ Parcial***** |
| Usuario | ✅ | ✅ | ✅ | 2 | 2 | ⚠️ Parcial****** |
| Settings | ✅ inline | — | ✅ | 2 | 2 | ⚠️ Parcial******* |
| Dados Ambientais | ❌ | ❌ | ❌ | 0 | 0 | ❌ Nao implementado |

* Dashboard: `cultivosPorStatus` nao exibido, sem `onTap` nos cards
** Plantas: sem UI para colher/perder, meioCultivoId, ambienteId; Hive nao persiste `comecandoDe`; fotos placeholder
*** Cultivos: `colher` sem provider/UI; `ambienteId` sem UI
**** Diario: fotos hardcoded, userId nao editavel
***** Analytics: backend nao expoe endpoint, dados vazios
****** Usuario: apenas nome editavel, sem avatar
******* Settings: bug no NotificationSettingsPage (usa setState local), sem persistencia
