# AGENTS.md

Guia de contexto para agentes que trabalham neste repositório.

## Projeto

App Flutter (`cultivo-mobile`) para gestão de cultivos. Repositório independente
de `cultivo-web`, que hospeda o backend (Node + mock API).

## Stack

- Flutter 3.x / Dart 3.x
- Riverpod (state management, `StateNotifierProvider`)
- GoRouter (navegação)
- Dio (HTTP client)
- Hive (storage offline)

## Estrutura

Cada feature segue o padrão em `lib/features/<feature>/`:

- `data/<feature>_repository.dart` — camada de acesso à API (Dio)
- `providers/<feature>_provider.dart` — `StateNotifierProvider` com State + Notifier
- `presentation/*_page.dart` — páginas (list, form, detail)
- `presentation/widgets/` — widgets específicos da feature

Modelos ficam em `lib/core/models/`. Widgets compartilhados em `lib/shared/widgets/`.

## Comandos

```bash
# Análise estática (manter em 0 issues antes de commit)
flutter analyze

# Formatação
dart format lib test integration_test

# Testes unitários / widget (rodar após mudanças)
flutter test

# Testes de integração (requer device + mock API na porta 3001)
flutter test integration_test/

# Suíte completa (API mock via curl + UI via ADB)
./run_all_tests.sh
```

## Convenções

- Nunca usar `withOpacity` — usar `withValues(alpha: ...)`
- Em `DropdownButtonFormField`, usar `initialValue:` (não `value:`), pois `value`
  é deprecado desde Flutter 3.33
- Não adicionar comentários ao código salvo quando solicitado
- Manter `flutter analyze` em 0 issues

## Testes

- Testes unitários dos modelos em `test/unit/`
- Testes de integração em `integration_test/`
- Scripts shell de teste na raiz: `test_*.sh` (mock API) e `test_ui.sh` (ADB)

## Backend / Mock API

- Mock API local na porta `3001` (iniciada via `pm2` em `cultivo-web`)
- `baseUrl` configurado em `lib/core/api/endpoints.dart`
