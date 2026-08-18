#!/bin/bash

# Ambientes API Test Script
# Tests the Ambientes endpoints

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Ambientes API Tests"
echo "=========================================="

# Test 1: List Ambientes
echo ""
echo "Test 1: List Ambientes"
RESPONSE=$(curl -s $MOCK_API/ambientes)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ List Ambientes - PASS"
else
    echo "  ❌ List Ambientes - FAIL"
fi

# Test 2: Get Ambiente by ID
echo ""
echo "Test 2: Get Ambiente by ID"
RESPONSE=$(curl -s $MOCK_API/ambientes/1)
if echo "$RESPONSE" | grep -q "nome"; then
    echo "  ✅ Get Ambiente by ID - PASS"
else
    echo "  ❌ Get Ambiente by ID - FAIL"
fi

# Test 3: Create Ambiente
echo ""
echo "Test 3: Create Ambiente"
RESPONSE=$(curl -s -X POST $MOCK_API/ambientes \
    -H "Content-Type: application/json" \
    -d '{"nome":"Ambiente Teste","tipo":"INDOOR","comprimento":2.0,"altura":2.0,"largura":2.0}')
if echo "$RESPONSE" | grep -q "id"; then
    echo "  ✅ Create Ambiente - PASS"
else
    echo "  ❌ Create Ambiente - FAIL"
fi

echo ""
echo "=========================================="
echo "Ambientes Tests completed!"
echo "=========================================="
