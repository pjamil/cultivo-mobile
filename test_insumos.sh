#!/bin/bash

# Insumos API Test Script
# Tests the Insumos endpoints

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Insumos API Tests"
echo "=========================================="

# Test 1: List Insumos
echo ""
echo "Test 1: List Insumos"
RESPONSE=$(curl -s $MOCK_API/insumos)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ List Insumos - PASS"
else
    echo "  ❌ List Insumos - FAIL"
fi

# Test 2: Get Insumo by ID
echo ""
echo "Test 2: Get Insumo by ID"
RESPONSE=$(curl -s $MOCK_API/insumos/1)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ Get Insumo by ID - PASS"
else
    echo "  ❌ Get Insumo by ID - FAIL"
fi

# Test 3: Create Insumo
echo ""
echo "Test 3: Create Insumo"
RESPONSE=$(curl -s -X POST $MOCK_API/insumos \
    -H "Content-Type: application/json" \
    -d '{"codigo":"INS001","nome":"Insumo Teste","tipo":"ADUBO","quantidade":10,"unidadeMedida":"kg","estoqueMinimo":5}')
if echo "$RESPONSE" | grep -q "id"; then
    echo "  ✅ Create Insumo - PASS"
else
    echo "  ❌ Create Insumo - FAIL"
fi

echo ""
echo "=========================================="
echo "Insumos Tests completed!"
echo "=========================================="
