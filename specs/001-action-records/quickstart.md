# Quickstart: Registros de Ação

**Date**: 2026-08-22  
**Feature**: action-records  
**Status**: Complete

## Prerequisites

- Flutter SDK 3.x instalado
- Backend mock rodando na porta 3001 (via `pm2` em `cultivo-web`)
- Device/emulator conectado
- Usuário autenticado no app

## Setup

```bash
# 1. Instalar dependências
flutter pub get

# 2. Gerar Hive adapters
dart run build_runner build

# 3. Rodar app
flutter run
```

## Validation Scenarios

### Scenario 1: Criar Registro de Rega

1. Navegar para Cultivos → Selecionar um cultivo ativo
2. Tocar no FAB "Registrar Ação"
3. Selecionar "Rega"
4. Preencher: quantidade=500, unidade=mL, método=manual
5. Adicionar nota: "Rega após poda"
6. Salvar

**Expected**: Registro aparece na timeline do cultivo

### Scenario 2: Criar Registro em Lote

1. Na página de formulário, selecionar "Ação em lote"
2. Selecionar 3 plantas do mesmo ambiente
3. Preencher detalhes da rega
4. Salvar

**Expected**: 3 registros criados individualmente

### Scenario 3: Editar Registro

1. Na timeline, tocar em um registro existente
2. Tocar em "Editar"
3. Alterar quantidade de 500 para 750 mL
4. Salvar

**Expected**: Registro atualizado na timeline

### Scenario 4: Excluir Registro

1. Na timeline, tocar em um registro existente
2. Tocar em "Excluir"
3. Confirmar exclusão

**Expected**: Registro removido da timeline

### Scenario 5: Filtrar Registros

1. Na timeline, tocar no filtro de tipo
2. Selecionar "Rega"

**Expected**: Apenas registros de rega visíveis

### Scenario 6: Paginação Infinita

1. Criar mais de 20 registros
2. Rolar para baixo na timeline

**Expected**: Mais registros carregam automaticamente

### Scenario 7: Offline

1. Desativar conexão de rede
2. Criar um registro
3. Reativar conexão

**Expected**: Registro sincroniza automaticamente, notificação de sucesso

## Commands

```bash
# Rodar testes unitários
flutter test test/unit/registro_acao_test.dart

# Rodar testes de integração
flutter test integration_test/registros_acao_test.dart

# Verificar analyze
flutter analyze

# Formatar código
dart format lib/features/registros_acao/
```

## Artifacts Reference

- **Data Model**: [data-model.md](./data-model.md)
- **API Contract**: [contracts/api.md](./contracts/api.md)
- **Research**: [research.md](./research.md)
- **Implementation Plan**: [plan.md](./plan.md)
