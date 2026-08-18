#!/bin/bash

# Cultivos API Test Script
# Tests the Cultivos endpoints

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Cultivos API Tests"
echo "=========================================="

# Test 1: List Cultivos
echo ""
echo "Test 1: List Cultivos"
RESPONSE=$(curl -s $MOCK_API/cultivos)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ List Cultivos - PASS"
else
    echo "  ❌ List Cultivos - FAIL"
fi

# Test 2: Get Cultivo by ID
echo ""
echo "Test 2: Get Cultivo by ID"
RESPONSE=$(curl -s $MOCK_API/cultivos/1)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ Get Cultivo by ID - PASS"
else
    echo "  ❌ Get Cultivo by ID - FAIL"
fi

# Test 3: Create Cultivo
echo ""
echo "Test 3: Create Cultivo"
RESPONSE=$(curl -s -X POST $MOCK_API/cultivos \
    -H "Content-Type: application/json" \
    -d '{"nome":"Cultivo Teste","status":"PLANEJADO","planta_id":1}')
if echo "$RESPONSE" | grep -q "id"; then
    echo "  ✅ Create Cultivo - PASS"
else
    echo "  ❌ Create Cultivo - FAIL"
fi

# Test 4: Update Cultivo
echo ""
echo "Test 4: Update Cultivo"
RESPONSE=$(curl -s -X PUT $MOCK_API/cultivos/1 \
    -H "Content-Type: application/json" \
    -d '{"nome":"Cultivo Atualizado"}')
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ Update Cultivo - PASS"
else
    echo "  ❌ Update Cultivo - FAIL"
fi

echo ""
echo "=========================================="
echo "Cultivos Tests completed!"
echo "=========================================="
