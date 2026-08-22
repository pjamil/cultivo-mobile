# Implementation Plan: Registros de Ação

**Branch**: `001-action-records` | **Date**: 2026-08-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-action-records/spec.md`

## Summary

Implementar feature de registros de ação (rega, adubação, transplante) para o app cultivo-mobile. Permite que usuários autenticados registrem ações realizadas em seus cultivos, com suporte a offline-first via fila existente, paginação infinita e fotos. Ponto de acesso via FAB na página de detalhe do cultivo.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x

**Primary Dependencies**: Riverpod (^2.4.0), Dio (^5.4.0), Hive (^2.2.3), image_picker, flutter_image_compress

**Storage**: Hive (offline via OfflineOperation existente) + API REST (backend Spring Boot)

**Testing**: flutter test (unit/widget), flutter test integration_test/

**Target Platform**: Android (arm64), iOS, Web

**Project Type**: mobile-app

**Performance Goals**: <2s para timeline com 100 registros, <30s para criar registro

**Constraints**: Offline-first com fila automática, paginação infinita (20 por carga), 5 fotos máximo por registro

**Scale/Scope**: 1 feature module, ~500-800 LOC, 4-5 páginas

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Princípio | Status | Notas |
|-----------|--------|-------|
| I. Código Limpo | ✅ PASS | flutter analyze 0 issues, sem comentários, naming semântico |
| II. Arquitetura Modular | ✅ PASS | Feature em `lib/features/registros_acao/`, padrão data/providers/presentation |
| III. Segurança | ✅ PASS | Autenticação via JWT existente, sem secrets no código |
| IV. Performance | ✅ PASS | Paginação infinita, lazy loading, compressão de imagens |
| V. CI/CD | ✅ PASS | Build automático via Gitea Actions |
| VI. Documentação | ✅ PASS | Spec, plan, tasks documentados |
| VII. Acessibilidade | ✅ PASS | Labels em campos, Semantics widgets |

## Project Structure

### Documentation (this feature)

```text
specs/001-action-records/
├── spec.md              # Especificação da feature
├── plan.md              # Este arquivo
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── models/
│   │   └── registro_acao.dart          # Novo modelo
│   │   └── registro_acao.g.dart        # Hive adapter gerado
│   └── api/
│       └── endpoints.dart              # Adicionar endpoint registros-acao
├── features/
│   └── registros_acao/                 # Nova feature
│       ├── data/
│       │   └── registros_acao_repository.dart
│       ├── providers/
│       │   └── registros_acao_provider.dart
│       └── presentation/
│           ├── registros_acao_list_page.dart
│           ├── registro_acao_form_page.dart
│           ├── registro_acao_detail_page.dart
│           └── widgets/
│               ├── registro_acao_card.dart
│               ├── registro_acao_tipo_selector.dart
│               ├── registro_acao_detalhes_form.dart
│               └── registros_acao_timeline.dart
└── features/
    └── cultivos/
        └── presentation/
            └── cultivo_detail_page.dart  # Adicionar FAB de registro
```

**Structure Decision**: Seguir padrão existente do projeto. Feature `registros_acao` com estrutura data/providers/presentation. Modelo em `core/models/`. Integração via FAB na `CultivoDetailPage`.

## Complexity Tracking

> Não há violações da constituição — feature segue padrão estabelecido.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
