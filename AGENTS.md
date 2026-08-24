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

## Padrões de Idioma e Unidades

- **Idioma padrão**: Português do Brasil (PT-BR) para toda documentação, comentários e interface
- **Unidades de medida**: Sistema métrico PT-BR
  - Volume: mL (mililitros), L (litros)
  - Massa: g (gramas), kg (quilogramas)
  - Comprimento: mm, cm, m (metros)
  - Área: cm², m², ha (hectares)
  - Temperatura: °C (Celsius)
  - pH: sem unidade (escala 0-14)
- **Formatação de números**: Separador decimal vírgula (ex: 1,5 kg), separador de milhar ponto (ex: 1.000 mL)
- **Datas**: Formato DD/MM/AAAA (ex: 22/08/2026)
- **Horário**: Formato 24h (ex: 14:30)

## Testes

- Testes unitários dos modelos em `test/unit/`
- Testes de integração em `integration_test/`
- Scripts shell de teste na raiz: `test_*.sh` (mock API) e `test_ui.sh` (ADB)

## CI/CD Android (Gitea Actions)

- Workflow: `.gitea/workflows/android-ci-cd.yml` — roda a cada push: builda o APK
  release arm64 (`--target-platform android-arm64`) e publica na release `latest` do Gitea.
- Download no celular (arm64): `https://gitea.pjamil.dev/paulojamil/cultivo-mobile/releases/latest/download/app-arm64-v8a-release.apk`
- O job roda em `container: eclipse-temurin:17-jdk`, instala Flutter SDK 3.47.0 e
  Android SDK sob demanda (sem imagem Flutter de terceiros).

## Assinatura Android (release)

- O `build.gradle.kts` assina releases lendo `android/key.properties` (não versionado).
  Se ausente, usa a keystore de debug (fallback para dev local).
- Secrets do Gitea usados no CI: `RELEASE_TOKEN`, `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
- `android/key.properties` e `**/*.jks` estão no `.gitignore` — nunca commitar.

## Backend / Mock API

- Mock API local na porta `3001` (iniciada via `pm2` em `cultivo-web`)
- `baseUrl` configurado em `lib/core/api/endpoints.dart`

## Android Network Security

- `android/app/src/main/res/xml/network_security_config.xml` declara confiança nos
  CAs do sistema (`<certificates src="system" />`).
- Referenciado no `AndroidManifest.xml` via `android:networkSecurityConfig`.
- **Sem esse config**, o Dart HTTP client (Dio) em release builds não consegue
  verificar certificados SSL em alguns dispositivos Android — resulta em
  `DioExceptionType.connectionError` ("Sem conexão com a internet") mesmo com
  rede e backend funcionais. O browser do celular funciona porque usa seu próprio
  trust store.

## Variáveis com Access Tokens e URLs

- Os access tokens para portainer, gitea, sonar e github e suas urls estão definidas em ~/.env
- Importante, não exponha seus valores no chat, use as variáveis

## Built-in Kotlin e Warning de KGP

- O projeto usa **built-in Kotlin** (`android.builtInKotlin=true` no `gradle.properties`
  e no override do CI). Requer AGP 9+, Gradle 8.13+ e plugins compatíveis.
- O CI pode exibir `WARNING: Your app uses the following plugins that apply Kotlin
  Gradle Plugin (KGP): flutter_image_compress_common`. É um **falso positivo benigno**:
  o Flutter faz scan textual por `apply plugin: 'kotlin-android'` no build.gradle do
  plugin, mas no `flutter_image_compress_common` essa linha é guardada por
  `if (!useBuiltInKotlin)` e não é aplicada em runtime. Não é corrigível pelo app
  (sem versão mais nova do plugin). Não bloquear o build por causa dele.
- `share_plus` deve permanecer em 13.x (migrado para built-in Kotlin). Se um upgrade
  exigir `win32 ^6`, o `flutter_secure_storage` precisa estar em 10.x+ (o 9.x exige
  `win32 ^5`). Não usar `flutter_secure_storage` 11.x sem migrar dados antigos
  (remove `encryptedSharedPreferences`).

