# Research: Registros de Ação

**Date**: 2026-08-22  
**Feature**: action-records  
**Status**: Complete

## Decisions

### 1. Modelo de Dados: RegistroAcao

**Decision**: Criar modelo `RegistroAcao` com typeId 12 no Hive

**Rationale**: 
- Tipohive 11 já utilizado por OfflineOperation
- Modelo precisa de campos flexíveis (JSON) para detalhes específicos por tipo
- Fotos são referenciadas via tabela Fotos existente (entityType + entityId)

**Alternatives Considered**:
- Reutilizar DiarioCultivo: Rejeitado porque diário é texto livre, não estruturado por tipo de ação
- Criar modelos separados por tipo (Rega, Adubacao, Transplante): Rejeitado porque aumenta complexidade sem benefício claro — todos compartilham campos comuns

### 2. Estratégia Offline: Fila OfflineOperation

**Decision**: Utilizar infraestrutura `OfflineOperation` existente para sincronização

**Rationale**:
- Infraestrutura já implementada e testada
- Suporta create, update, delete
- Retry automático quando conexão retorna
- Notificação de status ao usuário

**Alternatives Considered**:
- Criar fila própria: Rejeitado porque reinventar roda sem necessidade
- Não suportar offline: Rejeitado porque viola requisito de offline-first

### 3. Paginação: Infinita com cursor

**Decision**: Paginação infinita carregando 20 registros por vez, usando cursor baseado em dataCriacao

**Rationale**:
- Alinhado com resposta paginada existente (`{ "content": [...] }`)
- Cursor baseado em data é estável e ordenado
- 20 registros equilibra performance e usabilidade

**Alternatives Considered**:
- Paginação por offset: Rejeitado porque instável com dados mutáveis
- Limite fixo: Rejeitado porque restringe cultivors de longo ciclo

### 4. Upload de Fotos: Reutilizar FotoService

**Decision**: Reutilizar `FotoService` existente com entityType='REGISTRO_ACAO'

**Rationale**:
- Serviço já implementado com upload, listagem, exclusão
- Compressão de imagens já configurada
- Cache com cached_network_image já integrado

**Alternatives Considered**:
- Upload direto no repository: Rejeitado porque viola separação de responsabilidades

### 5. UI: FAB na CultivoDetailPage

**Decision**: Adicionar FAB na `CultivoDetailPage` que navega para `RegistroAcaoFormPage`

**Rationale**:
- Alinhado com clarificação do usuário
- Consistente com padrão FAB existente (ex: botão de adicionar)
- Contexto do cultivo já estabelecido

**Alternatives Considered**:
- Bottom Sheet: Rejeitado porque formulário é complexo demais para bottom sheet
- Página separada no Bottom Nav: Rejeitado porque aumenta carga cognitiva

### 6. Formulário: Page única com seções

**Decision**: Formulário em página única com seções colapsáveis por tipo de ação

**Rationale**:
- Reduz número de navegações
- Campos específicos aparecem apenas quando relevante
- Experiência fluida

**Alternatives Considered**:
- Wizard multi-step: Rejeitado porque adiciona complexidade sem benefício para formulário simples
- Formulário dinâmico via JSON: Rejeitado porque dificulta validação e testes

## Risk Assessment

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Backend não suporta endpoint | Alto | Implementar mock API para desenvolvimento |
| Conflitos offline | Médio | Último escritor vence + notificação |
| Performance com muitos registros | Baixo | Paginação infinita + lazy loading |

## Open Questions

- Nenhuma — todas as decisões foram tomadas com base na spec e constituição
