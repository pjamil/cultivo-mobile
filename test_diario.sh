#!/bin/bash

# Diário API Test Script
# Tests the Diário endpoints

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Diário API Tests"
echo "=========================================="

# Test 1: List Diário
echo ""
echo "Test 1: List Diário"
RESPONSE=$(curl -s $MOCK_API/diario-cultivo)
if echo "$RESPONSE" | grep -q "titulo"; then
    echo "  ✅ List Diário - PASS"
else
    echo "  ❌ List Diário - FAIL"
fi

# Test 2: Get Diário by ID
echo ""
echo "Test 2: Get Diário by ID"
RESPONSE=$(curl -s $MOCK_API/diario-cultivo/1)
if echo "$RESPONSE" | grep -q "titulo"; then
    echo "  ✅ Get Diário by ID - PASS"
else
    echo "  ❌ Get Diário by ID - FAIL"
fi

# Test 3: Create Diário
echo ""
echo "Test 3: Create Diário"
RESPONSE=$(curl -s -X POST $MOCK_API/diario-cultivo \
    -H "Content-Type: application/json" \
    -d '{"titulo":"Entrada Teste","conteudo":"Conteúdo da entrada","data":"2026-08-16"}')
if echo "$RESPONSE" | grep -q "id"; then
    echo "  ✅ Create Diário - PASS"
else
    echo "  ❌ Create Diário - FAIL"
fi

echo ""
echo "=========================================="
echo "Diário Tests completed!"
echo "=========================================="
