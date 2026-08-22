# Data Model: Registros de Ação

**Date**: 2026-08-22  
**Feature**: action-records  
**Status**: Complete

## Entity: RegistroAcao

### Fields

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `id` | `int` | sim | — | ID único (Hive typeId: 12) |
| `tipo` | `String` | sim | — | Tipo da ação (REGA, ADUBACAO, TRANSPLANTE, OUTRO) |
| `data` | `DateTime` | sim | DateTime.now() | Data e hora da realização |
| `cultivoId` | `int` | sim | — | FK para Cultivo |
| `plantaId` | `int?` | não | null | FK para Planta (nulo se ação em lote) |
| `detalhes` | `String?` | não | null | JSON com campos específicos por tipo |
| `notas` | `String?` | não | null | Observações adicionais |
| `usuarioId` | `int?` | não | null | FK para Usuario (quem registrou) |
| `dataCriacao` | `DateTime?` | não | null | Timestamp de criação no sistema |
| `dataAtualizacao` | `DateTime?` | não | null | Última atualização |

### Enums

#### TipoAcao

| Value | Label | Cor |
|-------|-------|-----|
| `REGA` | Rega | Azul |
| `ADUBACAO` | Adubação | Verde |
| `TRANSPLANTE` | Transplante | Laranja |
| `OUTRO` | Outro | Cinza |

### Hive Adapter

```dart
@HiveType(typeId: 12)
class RegistroAcao extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tipo;

  @HiveField(2)
  final DateTime data;

  @HiveField(3)
  final int cultivoId;

  @HiveField(4)
  final int? plantaId;

  @HiveField(5)
  final String? detalhes;

  @HiveField(6)
  final String? notas;

  @HiveField(7)
  final int? usuarioId;

  @HiveField(8)
  final DateTime? dataCriacao;

  @HiveField(9)
  final DateTime? dataAtualizacao;
}
```

### Detalhes por Tipo (JSON)

#### Rega

```json
{
  "quantidade": 500.0,
  "unidadeMedida": "mL",
  "metodo": "manual"
}
```

#### Adubação

```json
{
  "produto": "NPK 10-10-10",
  "quantidade": 25.0,
  "unidadeMedida": "g",
  "concentracao": "10ml/L"
}
```

#### Transplante

```json
{
  "vasoAnterior": 5.0,
  "vasoNovo": 11.0,
  "substrato": "Terra + Perlita",
  "motivo": "Raízes saindo do vaso"
}
```

## Relationships

```
RegistroAcao ──┬── Cultivo (1:N)
               ├── Planta (1:N, opcional)
               ├── Foto (1:N, via entityType)
               └── Usuario (1:N)
```

## Validation Rules

| Field | Rule |
|-------|------|
| `tipo` | Obrigatório, deve ser valor válido do enum |
| `data` | Obrigatório, não pode ser futuro |
| `cultivoId` | Obrigatório, deve existir |
| `plantaId` | Opcional, se informado deve existir |
| `detalhes` | Opcional, JSON válido se informado |
| `notas` | Opcional, máximo 500 caracteres |

## Serialization

### toCreateJson()

```json
{
  "tipo": "REGA",
  "data": "2026-08-22",
  "cultivo_id": 1,
  "planta_id": 1,
  "detalhes": "{\"quantidade\":500,\"unidadeMedida\":\"mL\"}",
  "notas": "Rega após poda"
}
```

### fromJson()

- Aceita camelCase e snake_case
- `detalhes` é parseado como JSON string
- Datas no formato ISO 8601 ou DD/MM/AAAA

## Indexes

| Index | Fields | Purpose |
|-------|--------|---------|
| primary | `id` | Lookup by ID |
| cultivo | `cultivoId` | List records by cultivation |
| planta | `plantaId` | List records by plant |
| tipo | `tipo` | Filter by action type |
| data | `data` | Sort chronologically |
