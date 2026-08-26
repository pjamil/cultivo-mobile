# Cultivo Mobile

[![Build](https://github.com/pjamil/cultivo-mobile/actions/workflows/android-ci-cd.yml/badge.svg)](https://github.com/pjamil/cultivo-mobile/actions/workflows/android-ci-cd.yml)

App mobile para gestão de cultivos multi-cultura.

## Funcionalidades

- **Auth**: Login, register, perfil
- **Plantas**: CRUD com vinculação a variedades
- **Cultivos**: CRUD com máquina de estados (8 estados)
- **Diário**: CRUD de entradas
- **Ambientes**: CRUD de ambientes de cultivo
- **Variedades**: CRUD de variedades de plantas
- **Meios de Cultivo**: CRUD de meios (solo, hidroponia, etc.)
- **Tarefas**: CRUD com calendário
- **Insumos**: CRUD com controle de estoque
- **Dashboard**: Cards resumo e atividades
- **Analytics**: Gráficos de rendimento, ciclo e custos
- **Fotos**: Upload, timeline, lightbox

## Tecnologias

- **Flutter 3.x** + **Dart 3.x**
- **Riverpod** (state management)
- **GoRouter** (navegação)
- **Dio** (HTTP client)
- **Hive** (storage offline)
- **fl_chart** (gráficos)
- **Firebase Messaging** (push notifications)

## Estrutura

```
lib/
├── app/              # App, router, theme
├── core/             # API, storage, models, utils
├── features/         # Feature modules
│   ├── auth/
│   ├── plantas/
│   ├── cultivos/
│   ├── diario/
│   ├── ambientes/
│   ├── variedade/
│   ├── meio_cultivo/
│   ├── tarefas/
│   ├── insumos/
│   ├── dashboard/
│   ├── analytics/
│   ├── usuario/
│   └── settings/
└── shared/           # Widgets compartilhados
```

## Repositório

Repositório independente: https://gitea.pjamil.dev/paulojamil/cultivo-mobile

O app foi separado do `cultivo-web` como repositório independente.

## Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar em device/emulator
flutter run

# Build Android
flutter build apk

# Build iOS
flutter build ios
```

## Ambiente de Desenvolvimento e Teste

### Fluxo recomendado: Mock API local + Chrome

Fluxo padrão para desenvolver e testar sem celular. Requer a mock API do
`cultivo-web` na porta 3001 e o app apontando para ela via `--dart-define`.

```bash
# 1. Subir a mock API (se o pm2 `cultivo-api` já estiver online, pule este passo)
cd <caminho-do-cultivo-web>
pm2 start mock-api/server.js --name cultivo-api

# 2. Rodar o app no Chrome apontando para a mock
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3001/api
```

- O `server.js` da mock reescreve a URL removendo o prefixo `/api/v1` — por isso o
  `baseUrl` é `http://localhost:3001/api` (e não `http://localhost:3001`).
- Credenciais seed: `maria@teste.com` / `admin123` (usuários em `db.json` do cultivo-web).
- **Sem o `--dart-define`**, o app usa `https://cultivo-dev.pjamil.dev/api` (remoto).
- CORS: a mock responde `Access-Control-Allow-Origin: *` (json-server defaults), ok para o Chrome.

### Opção 1: Flutter Web (sem celular)

```bash
flutter run -d chrome
```

Roda direto no navegador, usando o backend remoto (default `cultivo-dev.pjamil.dev`).
Para usar a mock local, veja o fluxo recomendado acima.

### Opção 2: Emulador Android

O emulador compartilha a rede do host, então `localhost` funciona sem alterações:

```bash
flutter run
```

### Opção 3: Celular na mesma rede Wi-Fi (sem USB)

O app precisa conectar ao backend. Configure o `baseUrl` em `lib/core/api/endpoints.dart`:

```dart
static const String baseUrl = 'http://<IP-do-PC>:3001';
```

Para descobrir o IP do PC:

```bash
ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
```

**Importante:** O celular e o PC devem estar na mesma rede Wi-Fi.

### Opção 4: Tunnel (acesso de qualquer lugar)

Para testar sem depurer da rede Wi-Fi, use um tunnel para expor o backend à internet:

```bash
# Com cloudflared
cloudflared tunnel --url http://localhost:3001

# Com ngrok
ngrok http 3001
```

O app acessa a URL do tunnel em `lib/core/api/endpoints.dart`:

```dart
static const String baseUrl = 'https://<url-do-tunnel>.trycloudflare.com';
```

### Opção 5: Backend na VPS

Para testes mais longos, deploy o backend na VPS:

```dart
static const String baseUrl = 'https://<BACKEND_URL>';
```

### Emulador Android — inviável no notebook de dev

O emulador Android está instalado (AVDs `cultivo` e `cultivo-aosp`), mas o notebook
(Toshiba Satellite A505, Intel Core i3 M 330 de 2010) **não tem AVX/AES**. O emulador
detecta a ausência dessas features e **força o AVD a 1 vCPU** (mesmo com `-cores 4`).
Com 1 vCPU, qualquer `pm install` de um APK real bloqueia o `system_server` por mais
de 60s e o **watchdog do Android mata o sistema** (crashes em loop). Não há
configuração que contorne — é limitação de hardware. Prefira o fluxo web recomendado
acima ou o APK do CI em um celular real.

Para testar num Android de verdade contra a mock local (HTTP), o bloqueio de
cleartext já é liberado por overlays **só de debug/profile**:
- `android/app/src/debug/res/xml/network_security_config.xml`
- `android/app/src/profile/res/xml/network_security_config.xml`

Builds release continuam bloqueando cleartext (produção segura).

## Instalação no Celular (sem USB)

### Via release automática do CI (recomendado)

A cada push, o push mirror do Gitea espelha o repositório pro GitHub e a pipeline
**GitHub Actions** (`.github/workflows/android-ci-cd.yml`) builda o APK Android e
publica na release `latest` do repositório.

- **URL de download (Moto G73 / arm64):**
  `https://gitea.pjamil.dev/paulojamil/cultivo-mobile/releases/download/latest/app-release.apk`

1. No celular, habilite "instalar de fontes desconhecidas" para o navegador.
2. Acesse a URL acima e baixe o APK.
3. Instale. Nas próximas versões, a mesma URL aponta para o build mais recente — instale
   por cima (mesma assinatura, sem desinstalar).

> O CI publica a release `latest` a cada push usando o `RELEASE_TOKEN` (token da API do
> Gitea, armazenado como secret no GitHub). Para mudar o
> backend usado no APK, defina `API_BASE_URL` no build ou edite `lib/core/api/endpoints.dart`.

### Via ADB wireless

```bash
# No PC, ative wireless ADB (precisa parear uma vez via USB)
adb tcpip 5555
adb connect <IP-do-celular>:5555

# Agora pode instalar sem USB
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via download direto

```bash
# Suba um servidor HTTP na pasta do APK
cd build/app/outputs/flutter-apk/
python3 -m http.server 8080

# No celular, acesse: http://<IP-do-PC>:8080/app-release.apk
```

### Nota sobre Play Protect

Play Protect bloqueia APKs assinados com chaves de debug. Opções:

1. **Desativar Play Protect** temporariamente (Configurações > Play Protect > Configurações)
2. **Instalar via ADB** (ignora Play Protect)
3. **Assinar com keystore próprio** (produção) — o app já está configurado para assinar
   releases com `android/key.properties` (não versionado) quando presente.

## Testes

```bash
# Unit tests
flutter test

# Widget tests
flutter test --platforms=widget

# Integration tests
flutter test integration_test/
```

## Configuração

1. Configurar Firebase (google-services.json / GoogleService-Info.plist)
2. Configurar AWS S3 para upload de fotos
3. Configurar endpoints da API em `lib/core/api/endpoints.dart`

## AndroidManifest.xml

Para acesso à internet, o `android/app/src/main/AndroidManifest.xml` deve incluir:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Branches e Deploy

| Branch | Ambiente | URL |
|--------|----------|-----|
| `main` | Development | Local / tunnel |
