# Cultivo Mobile Constitution

Constituição do projeto cultivo-mobile — app Flutter para gestão de cultivos
multi-cultura. Equipe: Paulo + Agente AI.

## Core Principles

### I. Código Limpo

- `flutter analyze` MUST retornar 0 issues antes de qualquer commit
- Código NÃO deve conter comentários exceto quando solicitado explicitamente
- Nomes de variáveis, funções e classes devem ser semânticos e descritivos
- Funções devem ter responsabilidade única (máximo ~30 linhas)
- Formatação obrigatória com `dart format lib test integration_test`
- Never usar `withOpacity` — usar `withValues(alpha: ...)`
- Em `DropdownButtonFormField`, usar `initialValue:` (não `value:`)

### II. Arquitetura Modular

- Features isoladas em `lib/features/<feature>/`
- Padrão por feature: `data/`, `providers/`, `presentation/`
- Modelos compartilhados em `lib/core/models/`
- Widgets compartilhados em `lib/shared/widgets/`
- Dependências devem ser unidirecionais (features não dependem umas das outras)
- Cada feature deve ser independentemente testável

### III. Segurança

- Variáveis de ambiente e tokens ficam em `~/.env` — nunca expor valores no chat ou código
- `android/key.properties` e `**/*.jks` estão no `.gitignore` — nunca commitar
- Secrets do CI via Gitea Secrets (RELEASE_TOKEN, ANDROID_KEYSTORE_BASE64, etc.)
- Network security config deve habilitar confiança nos CAs do sistema
- Nunca expor chaves de API, tokens ou credenciais em código fonte

### IV. Performance

- Compressão de imagens antes de upload (`flutter_image_compress`)
- Cache de imagens com `cached_network_image`
- Uso eficiente de memória com Hive para storage offline
- Lazy loading de features não críticas
- Otimizado para dispositivos Android (arm64)

### V. CI/CD Contínuo

- GitHub Actions roda a cada push (mirror Gitea → GitHub): build + testes
- APK release arm64 automático via `--target-platform android-arm64`
- Publicação na release `latest` do Gitea
- Download: `https://gitea.pjamil.dev/paulojamil/cultivo-mobile/releases/latest/download/app-release.apk`

### VI. Documentação

- README.md sempre atualizado com setup, uso e troubleshooting
- AGENTS.md fornece contexto para agentes AI
- Código deve ser auto-documentado via naming claro
- Convenções documentadas em AGENTS.md

### VII. Acessibilidade

- Suporte a leitores de tela (Semantics widgets)
- Contraste adequado de cores (WCAG 2.1 AA)
- Tamanhos de toque mínimos de 48x48dp
- Labels em todos os campos de formulário

## Stack Tecnológica

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| Flutter | 3.x | Framework mobile |
| Dart | 3.x | Linguagem |
| Riverpod | ^2.4.0 | State management |
| GoRouter | ^13.0.0 | Navegação |
| Dio | ^5.4.0 | HTTP client |
| Hive | ^2.2.3 | Storage offline |
| fl_chart | ^0.66.0 | Gráficos |
| Firebase Messaging | - | Push notifications |

## Regras de Negócio

- App gestão de cultivos multi-cultura
- Máquina de estados para cultivos: 8 estados do ciclo de vida
- Funcionalidades: Auth, Plantas, Cultivos, Diário, Ambientes, Variedades, Meios de Cultivo, Tarefas, Insumos, Dashboard, Analytics, Fotos
- Backend via cultivo-api-springboot (produção) e cultivo-web (mock API na porta 3001)
- Repositório independente de cultivo-web

## Fluxo de Trabalho

Equipe: Paulo + Agente AI. Sem pull requests — trabalho colaborativo direto.

### Dois Fluxos

| Fluxo | Quando usar | Comandos |
|-------|-------------|----------|
| **Spec Kit (SDD)** | Novas features, tarefas complexas, arquitetura | `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement` |
| **Simples** | Bugs, ajustes, refatorações, tarefas pontuais | Agente plan → Agente build → Validar → Commit → Deploy |

### Fluxo Completo (Spec Kit) — Features Complexas

1. **Specify**: Descrever o que construir e por quê (`/speckit.specify`)
2. **Clarify**: Resolver dúvidas com o agente (`/speckit.clarify`)
3. **Plan**: Definir abordagem técnica (`/speckit.plan`)
4. **Tasks**: Quebrar em tarefas acionáveis (`/speckit.tasks`)
5. **Implement**: Agente executa tarefas (`/speckit.implement`)
6. **Validate**: Rodar `flutter analyze` + `dart format` + testes
7. **Commit**: Direto na branch `main`
8. **Deploy**: CI builda APK automaticamente

### Fluxo Simples — Atividades Corriqueiras

1. **Plan**: Agente planeja abordagem (rápido, sem spec formal)
2. **Implement**: Agente executa implementação
3. **Validate**: Rodar `flutter analyze` + `dart format` + testes
4. **Commit**: Direto na branch `main`
5. **Deploy**: CI builda APK automaticamente

### Comandos Spec Kit

| Comando | Objetivo |
|---------|----------|
| `/speckit.constitution` | Definir princípios e guardrails do projeto |
| `/speckit.specify` | Criar especificação da feature |
| `/speckit.clarify` | Resolver ambiguidades na spec |
| `/speckit.plan` | Gerar plano técnico |
| `/speckit.tasks` | Decompor em tarefas acionáveis |
| `/speckit.analyze` | Verificar consistência entre artefatos |
| `/speckit.implement` | Executar todas as tarefas |

### Regras

- Equipe pequena (Paulo + AI): sem necessidade de PRs
- Specs ficam em `.specify/specs/` como fonte de verdade
- Planos em `.specify/plans/`
- Tarefas em `.specify/tasks/`
- Constituição em `.specify/memory/constitution.md` — documento supremo
- **Decisão**: Usar fluxo SDD para features novas; fluxo simples para o resto

## Conformidade

- `flutter analyze`: 0 issues obrigatório
- Testes unitários: rodar `flutter test` antes de commit
- Testes de integração: `flutter test integration_test/` para fluxos críticos
- Scripts shell de teste: `run_all_tests.sh` para suíte completa
- Formatação: `dart format` obrigatório

## Governance

Esta constituição é o documento supremo de governança do projeto cultivo-mobile.

- **Emendas**: Requerem documentação da mudança + aprovação do Paulo
- **Versão**: Semantic versioning (MAJOR.MINOR.PATCH)
  - MAJOR: Remoção ou redefinição de princípios
  - MINOR: Novo princípio ou seção adicionada
  - PATCH: Esclarecimentos, correções de redação
- **Compliance**: Fluxo Spec Kit deve seguir esta constituição
- **Revisão**: Revisão periódica para garantir relevância
- **Spec Kit**: Constitution é o ponto de entrada para `/speckit.constitution`

**Version**: 1.1.2 | **Ratified**: 2026-08-22 | **Last Amended**: 2026-08-26
