# cultivo-mobile vs Grow with Jane — Comparação de Funcionalidades

Data da análise: Ago 2026

## Rastreamento Básico

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Cadastro de plantas** | ✅ CRUD completo (nome, espécie, status, datas) | ✅ Árvores + profiles |
| **Ambientes/espaços** | ✅ CRUD (dimensões, orientação, exposição solar) | ✅ Ambientes unificados na Garden view |
| **Variedades/genética** | ✅ CRUD (tipo, espécie, floração, origem) | ✅ Strains com metadados (classe, tipo, floração, auto) |
| **Meio de cultivo** | ✅ CRUD (tipo, descrição) | ❌ Não explícito |
| **Ciclos de cultivo** | ✅ CRUD com **máquina de estados** (7 fases: planejado → colhido) | ✅ Growlogs (timeline de crescimento) |
| **Diário de cultivo** | ✅ CRUD de entradas (título, conteúdo, data) | ✅ Growlogs (entries com fotos) |

## Ações e Registros

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Registro de rega** | ❌ Não implementado | ✅ Watering log (com quantidade e pH na v3.1) |
| **Registro de adubação** | ❌ Não implementado | ✅ Feeding log |
| **Registro de transplante** | ❌ Não implementado | ✅ Transplanting log |
| **Registro de fotos** | ✅ Upload + timeline agrupada por fase | ✅ Upload + galeria |
| **Avanço de fase do ciclo** | ✅ Ação `avancarEstado` | ✅ Explícito nos growlogs |
| **Colheita** | ✅ Ação `colher` com quantidade | ✅ Harvest tracking |
| **Perda de planta** | ✅ Ação `perder` com motivo | ❌ Não explícito |

## Tarefas e Lembretes

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Tarefas CRUD** | ✅ (título, descrição, prioridade, vencimento) | ❌ Usa lembretes por planta |
| **Recorrência** | ✅ (diária, semanal, quinzenal, mensal) | ✅ Recurring reminders |
| **Calendário** | ✅ Visualização mensal com indicators | ✅ Calendar reminders |
| **Lembretes de rega** | ❌ Não implementado | ✅ (com quantidade e pH) |
| **Lembretes de estoque** | ✅ Alertas de estoque baixo | ❌ Não |

## Inventário

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Insumos/estoque** | ✅ CRUD (código, tipo, quantidade, unidade, mínimo) | ❌ Não |
| **Alerta de estoque baixo** | ✅ Banner de warning + dashboard | ❌ Não |
| **Unidades de medida** | ✅ Campo `unidadeMedida` | ✅ Labels de unidades |

## Analytics e Dados

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Gráficos de rendimento** | ✅ YieldChart (por variedade) | ✅ Growlog Charts (tendências, stats) |
| **Gráficos de ciclo** | ✅ CycleChart (dias por fase) | ✅ Action-frequency insights |
| **Gráficos de custo** | ✅ CostChart (custo por cultivo) | ❌ Não |
| **Exportar CSV** | ✅ share_plus | ❌ Não |
| **Dashboard/KPIs** | ✅ Cultivos ativos, tarefas pendentes, alertas | ✅ Resumo de atividades |

## Dados Ambientais

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Registro de temp/pH/etc** | ❌ Feature vazia (placeholder) | ✅ Environmental tracking |
| **Sensores IoT** | ❌ Não | ❌ Não |

## IA e Assistência

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Assistente IA** | ❌ Não | ✅ Jane AI (chat, diagnóstico, insights) |
| **Diagnóstico de plantas** | ❌ Não | ✅ Upload foto → possíveis causas |
| **Resumo automático** | ❌ Não | ✅ AI summary de growlogs |

## Comunidade e Social

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Perfil público** | ❌ Não | ✅ Profile com avatar, bio, handle |
| **Growlogs públicos** | ❌ Não | ✅ Compartilhar growlogs |
| **Follow/seguidores** | ❌ Não | ✅ Follow system |
| **Comentários** | ❌ Não | ✅ Comentários em growlogs |
| **Explorar de outros** | ❌ Não | ✅ Explore feed |
| **Conquistas** | ❌ Não | ✅ Achievements system |
| **Contests** | ❌ Não | ✅ Grower contests |

## Infraestrutura

| Funcionalidade | cultivo-mobile | Grow with Jane |
|---|---|---|
| **Offline** | ✅ Fila Hive + storage local | ✅ Offline support |
| **Multi-plataforma** | ✅ Flutter (Android/iOS/Web) | ✅ iOS + Android + Web (parcial) |
| **Auth JWT** | ✅ Secure storage | ✅ Account system |
| **Dark mode** | ✅ Light + dark themes | ✅ Dark + light themes |

## Resumo

### Nossos pontos fortes (funcionalidades que GWJ não tem ou é inferior)

- Máquina de estados formal para ciclos (7 fases)
- Gestão de insumos/estoque com alertas
- Gráficos de custo por cultivo
- Exportação CSV
- Tarefas CRUD com recorrência e calendário
- Meio de cultivo como entidade separada

### Funcionalidades que GWJ tem e nós não temos (oportunidades)

1. **Registros de ação** — rega, adubação, transplante (maior gap)
2. **Jane AI** — assistente com diagnóstico de plantas
3. **Social/comunidade** — perfis, growlogs públicos, follow, comentários
4. **Lembretes por planta** — rega com quantidade/pH
5. **Dados ambientais** — feature placeholder ainda vazia
6. **Calculadoras** — presentes no GWJ
7. **Tradução on-demand**
