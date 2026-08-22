# Registros de Ação — Rega, Adubação, Transplante

## Overview

Permitir que o usuário registre ações realizadas em seus cultivos (rega, adubação, transplante) com data, detalhes e opcionalmente fotos, criando um histórico organizado por cultivo/planta. Inspirado na funcionalidade de "Actions" do app Grow with Jane.

**Short Name**: action-records  
**Created**: 2026-08-22  
**Status**: Draft

---

## User Scenarios & Testing

### Primary User Scenario

1. O usuário acessa a página de detalhe de um cultivo
2. Toca no botão "Registrar Ação" (FAB ou botão na AppBar)
3. Seleciona o tipo de ação (rega, adubação, transplante ou outra)
4. Preenche os campos obrigatórios (data, detalhes da ação)
5. Opcionalmente adiciona fotos, quantidades, produto utilizado
6. Salva o registro
7. O registro aparece na timeline/histórico do cultivo

### Ponto de Acesso

- **Localização**: Página de detalhe do cultivo (`CultivoDetailPage`)
- **Elemento**: FAB (FloatingActionButton) ou botão na AppBar
- **Contexto**: Ao acessar, o usuário já está no contexto do cultivo — não precisa selecionar

### Alternative Scenarios

- **Ação em lote**: Usuário pode registrar a mesma ação para múltiplas plantas de uma vez (ex: regar todas as plantas do ambiente X)
- **Edição**: Usuário pode editar um registro existente para corrigir informações
- **Exclusão**: Usuário pode excluir um registro incorreto
- **Visualização**: Usuário pode ver todos os registros de um cultivo/planta filtrados por tipo e período

### Testing Scenarios

- **Happy Path**: Usuário cria registro de rega completo com todos os campos obrigatórios
- **Validação**: Sistema rejeita registro sem campos obrigatórios
- **Ação em lote**: Usuário registra ação para 5 plantas simultaneamente
- **Edição**: Usuário altera quantidade de fertilizante em registro existente
- **Exclusão**: Usuário remove registro incorreto
- **Filtros**: Usuário filtra registros por tipo e período
- **Timeline**: Registros aparecem cronologicamente na timeline do cultivo

---

## Functional Requirements

### FR-1: Tipos de Ação

O sistema deve suportar os seguintes tipos de ação pré-definidos:
- **Rega**: Registro de irrigação da planta
- **Adubação**: Aplicação de fertilizantes ou nutrientes
- **Transplante**: Mudança de vaso ou substrato
- **Outros**: Ações customizadas definidas pelo usuário

Cada tipo deve ter campos específicos relevantes (ex: adubação requer produto e quantidade).

### FR-2: Campos Obrigatórios

Todos os registros de ação devem conter:
- **Tipo da ação**: Selecionado pelo usuário
- **Data e hora**: Quando a ação foi realizada (padrão: data/hora atual)
- **Cultivo/Planta associado**: Qual cultivo/planta recebeu a ação

### FR-3: Campos Específicos por Tipo

**Rega**:
- Quantidade de água (opcional)
- Unidade de medida: mL, L (sistema métrico PT-BR)
- Método de rega (manual, gotejamento, etc.) - opcional

**Adubação**:
- Produto/nutriente utilizado (opcional)
- Quantidade aplicada (opcional)
- Unidade de medida: g, mL, L (sistema métrico PT-BR)
- Concentração/diluição (opcional)

**Transplante**:
- Tamanho do vaso anterior (opcional) — em litros (L)
- Tamanho do vaso novo (opcional) — em litros (L)
- Substrato utilizado (opcional)
- Motivo do transplante (opcional)

### FR-4: Campos Opcionais Globais

- **Notas/Observações**: Texto livre para detalhes adicionais
- **Fotos**: Possibilidade de anexar até 5 fotos ao registro

### FR-5: Ação em Lote

- Usuário pode selecionar múltiplas plantas do mesmo ambiente
- Aplica a mesma ação (tipo + detalhes) para todas selecionadas
- Cria registros individuais para cada planta

### FR-6: Histórico e Timeline

- Exibir lista cronológica de todos os registros de ação
- Filtrar por tipo de ação (rega, adubação, transplante)
- Filtrar por período (semana, mês, período customizado)
- Cada registro exibe: data, tipo, resumo dos detalhes, miniatura de fotos
- Paginação infinita: carregar 20 registros por vez, sem limite máximo

### FR-7: Edição e Exclusão

- Usuário pode editar qualquer campo de um registro existente
- Usuário pode excluir registros com confirmação
- Alterações são sincronizadas com o backend

### FR-8: Lembrete de Rega (Opcional Futuro)

- Usuário pode configurar lembretes de rega periódicos
- Sistema envia notificação no horário configurado

---

## Success Criteria

### Quantitative

- Usuário consegue criar um registro de ação em menos de 30 segundos
- 90% dos registros são criados sem erros de validação
- Histórico carrega em menos de 2 segundos para cultivos com até 100 registros
- Usuário pode filtrar registros em menos de 2 toques

### Qualitative

- Usuário sente que tem controle sobre o histórico de cuidados com as plantas
- Interface é intuitiva e não requer tutorial
- Registros são ficientemente legíveis na timeline
- Usuário consegue identificar rapidamente padrões de cuidado

---

## Key Entities

### RegistroAcao (ActionRecord)

- **id**: Identificador único
- **tipo**: Tipo da ação (REGA, ADUBACAO, TRANSPLANTE, OUTRO)
- **data**: Data e hora da realização
- **cultivoId**: Referência ao cultivo
- **plantaId**: Referência à planta (pode ser nulo se ação em lote)
- **detalhes**: Campos específicos por tipo (JSON flexível)
- **notas**: Observações adicionais
- **fotos**: Lista de fotos associadas
- **usuarioId**: Quem registrou
- **dataCriacao**: Quando foi criado no sistema
- **dataAtualizacao**: Última atualização

**Nota**: Registros não possuem estados intermediários — são imediatamente visíveis e permanentes ao serem salvos.

### Relacionamentos

- **RegistroAcao** pertence a um **Cultivo**
- **RegistroAcao** pode estar associado a uma **Planta**
- **RegistroAcao** pode ter múltiplas **Fotos**
- **RegistroAcao** é criado por um **Usuário**

---

## Assumptions

1. **Backend existente**: O backend já suporta ou suportará o endpoint para registros de ação
2. **Autenticação**: Usuário está autenticado ao criar registros
3. **Offline-first**: Registros criados offline são salvos na fila `OfflineOperation` existente, com sincronização automática e retry quando a conexão retornar. Usuário recebe notificação do status da sincronização
4. **Fotos**: Fotos são armazenadas em cloud storage (S3 ou similar)
5. **Notificações**: Sistema de push notifications já está configurado (para lembretes futuros)
6. **Permissões**: Qualquer usuário autenticado pode criar e gerenciar seus próprios registros. Apenas o criador pode editar/excluir seus registros
7. **Granularidade**: Cada registro está vinculado a um cultivo específico, com opcional vinculação a planta

---

## Dependencies

- **Cultivos feature**: Necessária para selecionar o cultivo alvo
- **Plantas feature**: Necessária para vincular registros a plantas específicas
- **Fotos feature**: Necessária para upload e gerenciamento de fotos
- **Dados Ambientais feature**: Pode complementar com dados de temperatura/umidade no momento da ação

---

## Out of Scope

- Integração com sistemas de irrigação automática
- Análise preditiva de necessidades de rega
- Integração com sensores IoT
- Sincronização com apps de terceiros
- Exportação de dados (pode ser adicionado em fase futura)

---

## Clarifications

### Session 2026-08-22

- Q: Onde exatamente na interface o botão "Registrar Ação" será acessível? → A: Na página de detalhe do cultivo (FAB ou botão na AppBar)
- Q: Como o sistema deve lidar com falhas de rede ao salvar registros offline? → A: Fila automática com retry + notificação quando sincronizar
- Q: Os registros de ação podem ter estados ou são sempre imediatamente visíveis e permanentes? → A: Sem estados — sempre visíveis e permanentes ao salvar
- Q: Quais tipos de usuário podem criar e gerenciar registros de ação? → A: Qualquer usuário autenticado pode criar/gerenciar seus próprios registros
- Q: Qual o limite máximo de registros de ação por cultivo para manter a performance? → A: Sem limite, paginação infinita (20 registros por carga)
