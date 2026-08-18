#!/bin/bash

# Tarefas API Test Script
# Tests the Tarefas endpoints

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Tarefas API Tests"
echo "=========================================="

# Test 1: List Tarefas
echo ""
echo "Test 1: List Tarefas"
RESPONSE=$(curl -s $MOCK_API/tarefas)
if echo "$RESPONSE" | grep -q "titulo"; then
    echo "  ✅ List Tarefas - PASS"
else
    echo "  ❌ List Tarefas - FAIL"
fi

# Test 2: Get Tarefa by ID
echo ""
echo "Test 2: Get Tarefa by ID"
RESPONSE=$(curl -s $MOCK_API/tarefas/1)
if echo "$RESPONSE" | grep -q "titulo"; then
    echo "  ✅ Get Tarefa by ID - PASS"
else
    echo "  ❌ Get Tarefa by ID - FAIL"
fi

# Test 3: Create Tarefa
echo ""
echo "Test 3: Create Tarefa"
RESPONSE=$(curl -s -X POST $MOCK_API/tarefas \
    -H "Content-Type: application/json" \
    -d '{"titulo":"Tarefa Teste","status":"PENDENTE","prioridade":"MEDIA"}')
if echo "$RESPONSE" | grep -q "id"; then
    echo "  ✅ Create Tarefa - PASS"
else
    echo "  ❌ Create Tarefa - FAIL"
fi

# Test 4: Update Tarefa
echo ""
echo "Test 4: Update Tarefa"
RESPONSE=$(curl -s -X PUT $MOCK_API/tarefas/1 \
    -H "Content-Type: application/json" \
    -d '{"status":"EM_ANDAMENTO"}')
if echo "$RESPONSE" | grep -q "status"; then
    echo "  ✅ Update Tarefa - PASS"
else
    echo "  ❌ Update Tarefa - FAIL"
fi

echo ""
echo "=========================================="
echo "Tarefas Tests completed!"
echo "=========================================="
