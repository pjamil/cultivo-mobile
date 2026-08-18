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
