# Cultivo Mobile

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

### Opção 1: Flutter Web (sem celular)

```bash
flutter run -d chrome
```

Roda direto no navegador. `localhost` funciona normalmente.

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
static const String baseUrl = 'https://api.cultivo.pjamil.dev';
```

## Instalação no Celular (sem USB)

### Via release automática do CI (recomendado)

A cada push, a pipeline **Gitea Actions** (`.gitea/workflows/android-ci-cd.yml`) builda o
APK Android e publica na release `latest` do repositório.

- **URL de download (Moto G73 / arm64):**
  `https://gitea.pjamil.dev/paulojamil/cultivo-mobile/releases/latest/download/app-arm64-v8a-release.apk`

1. No celular, habilite "instalar de fontes desconhecidas" para o navegador.
2. Acesse a URL acima e baixe o APK.
3. Instale. Nas próximas versões, a mesma URL aponta para o build mais recente — instale
   por cima (mesma assinatura, sem desinstalar).

> O CI publica a release `latest` a cada push usando o `GITEA_TOKEN` (admin). Para mudar o
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
