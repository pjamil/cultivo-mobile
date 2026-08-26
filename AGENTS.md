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

## Troubleshooting: Build APK OOM no runner-jvm (Gitea Actions)

**Sintomas:** `flutter build apk` falha no step "Build release APK (arm64)" com
log terminando abruptamente (sem mensagem de erro) ou com
`Could not receive a message from the daemon`. `flutter analyze` e `flutter test`
passam — só o `assembleRelease` morre.

**Causas confirmadas (Ago/2026) e correções aplicadas:**

1. **Host sem swap + memória escassa.** O host da VPS (`ssdnodes-639e56e4cabc8`)
   tem só 2 vCPUs / ~7,8 GiB RAM, compartilhados com ~27 containers. Durante o
   build, a memória disponível do host caía para <0,5 GiB e o kernel OOM killer
   matava o Gradle (log do job termina sem erro).
   - **Correção:** swap de 8 GiB no host (2 arquivos de 4G), persistido no
     `/etc/fstab` (`/swapfile` e `/swapfile2`). O `swapon` dentro do container do
     job falha (não-privilegiado), então o swap precisa ser no HOST.

2. **Sonarqube consumindo 2,2 GiB de RAM** no mesmo host, disputando memória com
   o build.
   - **Correção:** containers `sonarqube-sonarqube-1` e `sonarqube-db-1` parados e
     com `--restart=no` (reativar quando necessário).

3. **`org.gradle.configuration-cache=true`** no tuning do CI causava
   `Could not resolve all files for configuration ':app:debugCompileClasspath'`
   / "cannot choose between variants" com AGP 9.1.
   - **Correção:** remover configuration-cache do `android/gradle.properties`
     gerado pelo workflow.

4. **Limite de memória do container de build muito baixo.** O
   `config-jvm.yaml` do runner usava `container.options: "--memory=4g
   --memory-swap=5g"`. Quando o daemon + Kotlin + R8 ultrapassavam 4 GiB, o OOM
   do cgroup matava o daemon silenciosamente (sem dmesg no host).
   - **Correção:** `--memory=6g --memory-swap=8g` no `config-jvm.yaml` (arquivo
     na VPS em `/home/paulo/repos/gitea-server/runner/config-jvm.yaml`) + restart
     do container `runner-jvm`.

5. **Heap do Gradle muito alto** (`org.gradle.jvmargs=-Xmx8G` no
   `android/gradle.properties` do repo). O workflow sobrescreve com
   `-Xmx768M -XX:MaxMetaspaceSize=512M` + `UseSerialGC` + workers.max=1.

**Guards ativos no workflow** (`.gitea/workflows/android-ci-cd.yml`):

- Step **"Check host memory headroom"** falha cedo se `SwapTotal == 0` e
  `MemAvailable < 1,5 GiB`, com mensagem clara (em vez de morrer no meio do build).
- Tuning de memória do Gradle (heap baixo, SerialGC, worker único).

**Comandos úteis para diagnóstico (VPS, host `ssdnodes-639e56e4cabc8`):**

```bash
# Memória / swap do host
ssh paulo@172.93.54.123 'free -h'

# Memória disponível do host durante o build (Prometheus na porta 32770)
curl -s "http://localhost:32770/api/v1/query?query=node_memory_MemAvailable_bytes"

# OOM no kernel (requer root — usar container privileged se não houver sudo)
docker run --rm --privileged --pid=host alpine sh -c "dmesg | grep -iE 'oom|killed process' | tail"

# Config do runner (limite de memória do container de build)
cat /home/paulo/repos/gitea-server/runner/config-jvm.yaml

# Status do build no Gitea (API)
curl -sL -H "Authorization: token $GITEA_TOKEN" \
  "$GITEA_URL/api/v1/repos/paulojamil/cultivo-mobile/actions/runs/<run_id>/jobs?token=$GITEA_TOKEN"
```

**Regra prática:** se o build morre com log truncado ou "Could not receive a
message from the daemon", verificar (nesta ordem): (1) swap do host, (2) RAM
disponível do host durante o build, (3) limite de memória do container no
`config-jvm.yaml`, (4) configuração do Gradle (não usar configuration-cache).

## Assinatura Android (release)

- O `build.gradle.kts` assina releases lendo `android/key.properties` (não versionado).
  Se ausente, usa a keystore de debug (fallback para dev local).
- Secrets do Gitea usados no CI: `RELEASE_TOKEN`, `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
- `android/key.properties` e `**/*.jks` estão no `.gitignore` — nunca commitar.

## Backend / Mock API

- Mock API local na porta `3001` (iniciada via `pm2` em `cultivo-web`)
- `baseUrl` configurado em `lib/core/api/endpoints.dart`
- Para testar local: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3001/api`
  (o `server.js` da mock reescreve a URL removendo `/api/v1`; sem o `--dart-define`,
  o default é `https://cultivo-dev.pjamil.dev/api`)
- Credenciais seed da mock: `maria@teste.com` / `admin123` (em `db.json` do cultivo-web)

## Android Network Security

- `android/app/src/main/res/xml/network_security_config.xml` declara confiança nos
  CAs do sistema (`<certificates src="system" />`).
- Referenciado no `AndroidManifest.xml` via `android:networkSecurityConfig`.
- **Sem esse config**, o Dart HTTP client (Dio) em release builds não consegue
  verificar certificados SSL em alguns dispositivos Android — resulta em
  `DioExceptionType.connectionError` ("Sem conexão com a internet") mesmo com
  rede e backend funcionais. O browser do celular funciona porque usa seu próprio
  trust store.
- **Teste local com HTTP (cleartext):** builds debug/profile liberam cleartext via
  overlays em `android/app/src/debug/res/xml/network_security_config.xml` e
  `android/app/src/profile/res/xml/network_security_config.xml`
  (`cleartextTrafficPermitted="true"`), referenciados nos manifests de debug/profile.
  Builds release seguem bloqueando cleartext (produção segura).

## Emulador Android no notebook de dev

- Instalado: `emulator` + imagens `system-images;android-36;google_apis;x86_64` e
  `system-images;android-36;default;x86_64`; AVDs `cultivo` e `cultivo-aosp` em `~/.android/avd/`.
- **Inviável nesta máquina**: o notebook (Toshiba Satellite A505, Intel Core i3 M 330,
  2010) não tem AVX/AES. O emulador força o AVD a 1 vCPU
  (`WARNING: ... Setting AVD to run with 1 vCPU core only` — mesmo com `-cores 4`).
  Com 1 vCPU, `pm install` de um APK real bloqueia o `system_server` >60s e o watchdog
  do Android mata o sistema (`*** WATCHDOG KILLING SYSTEM PROCESS`), em loop de crash.
  Não é contornável por config — usar o fluxo web + mock (seção Backend / Mock API).
- **adb PATH quebrado (corrigido):** `flutter doctor` acusava "adb not found" porque o
  adb real está em `~/Android/Sdk/platform-tools-2/adb`, não em `~/Android/Sdk/platform-tools/adb`.
  Correção aplicada com symlink:
  `ln -s ~/Android/Sdk/platform-tools-2/adb ~/Android/Sdk/platform-tools/adb`.
- **Testar num Android real com a mock local:** build debug/profile (cleartext liberado
  pelos overlays acima) + `adb reverse tcp:3001 tcp:3001` +
  `flutter run --dart-define=API_BASE_URL=http://localhost:3001/api`.

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

