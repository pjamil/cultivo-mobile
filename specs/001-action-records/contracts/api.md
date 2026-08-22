# API Contract: Registros de Ação

**Base URL**: `/v1/registros-acao`  
**Auth**: Bearer JWT (obrigatório)

## Endpoints

### GET /v1/registros-acao

Listar registros de ação com paginação e filtros.

**Query Parameters**:

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `cultivoId` | int | sim | Filtrar por cultivo |
| `plantaId` | int | não | Filtrar por planta |
| `tipo` | string | não | Filtrar por tipo (REGA, ADUBACAO, TRANSPLANTE, OUTRO) |
| `dataInicio` | string | não | Data início (DD/MM/AAAA) |
| `dataFim` | string | não | Data fim (DD/MM/AAAA) |
| `page` | int | não | Página (default: 0) |
| `size` | int | não | Tamanho da página (default: 20) |

**Response 200**:

```json
{
  "content": [
    {
      "id": 1,
      "tipo": "REGA",
      "data": "2026-08-22T14:30:00",
      "cultivoId": 1,
      "plantaId": 1,
      "detalhes": "{\"quantidade\":500,\"unidadeMedida\":\"mL\"}",
      "notas": "Rega após poda",
      "usuarioId": 1,
      "dataCriacao": "2026-08-22T14:30:00",
      "dataAtualizacao": null
    }
  ],
  "totalElements": 1,
  "totalPages": 1,
  "number": 0,
  "size": 20
}
```

### GET /v1/registros-acao/{id}

Buscar registro por ID.

**Response 200**:

```json
{
  "id": 1,
  "tipo": "REGA",
  "data": "2026-08-22T14:30:00",
  "cultivoId": 1,
  "plantaId": 1,
  "detalhes": "{\"quantidade\":500,\"unidadeMedida\":\"mL\"}",
  "notas": "Rega após poda",
  "usuarioId": 1,
  "dataCriacao": "2026-08-22T14:30:00",
  "dataAtualizacao": null
}
```

**Response 404**:

```json
{
  "error": "Registro não encontrado"
}
```

### POST /v1/registros-acao

Criar novo registro de ação.

**Request Body**:

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

**Response 201**:

```json
{
  "id": 1,
  "tipo": "REGA",
  "data": "2026-08-22T14:30:00",
  "cultivoId": 1,
  "plantaId": 1,
  "detalhes": "{\"quantidade\":500,\"unidadeMedida\":\"mL\"}",
  "notas": "Rega após poda",
  "usuarioId": 1,
  "dataCriacao": "2026-08-22T14:30:00",
  "dataAtualizacao": null
}
```

**Response 400**:

```json
{
  "error": "Tipo é obrigatório"
}
```

### PUT /v1/registros-acao/{id}

Atualizar registro existente.

**Request Body**:

```json
{
  "tipo": "REGA",
  "data": "2026-08-22",
  "detalhes": "{\"quantidade\":750,\"unidadeMedida\":\"mL\"}",
  "notas": "Rega após poda - quantidade aumentada"
}
```

**Response 200**: Mesmo formato do POST

### DELETE /v1/registros-acao/{id}

Excluir registro.

**Response 204**: Sem conteúdo

**Response 404**:

```json
{
  "error": "Registro não encontrado"
}
```

## Error Codes

| Code | Description |
|------|-------------|
| 400 | Dados inválidos |
| 401 | Não autenticado |
| 403 | Sem permissão |
| 404 | Registro não encontrado |
| 500 | Erro interno |

## Offline Behavior

- Registros criados offline são salvos na fila `OfflineOperation`
- Quando a conexão retorna, retry automático
- Usuário recebe notificação do status (sucesso/erro)
- Conflitos: último escritor vence
