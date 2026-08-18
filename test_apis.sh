#!/bin/bash

# Automated Test Script using ADB
# Tests the Flutter app by interacting with it via ADB

set -e

ADB=~/Android/Sdk/platform-tools/platform-tools/adb
APP_PACKAGE="com.example.cultivo_mobile"
MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Cultivo App - Automated Tests"
echo "=========================================="

# Test 1: Check Mock API
echo ""
echo "Test 1: Mock API Status"
if curl -s $MOCK_API/meus-dados > /dev/null 2>&1; then
    echo "  ✅ Mock API is running"
else
    echo "  ❌ Mock API is not running"
    exit 1
fi

# Test 2: Check Device Connection
echo ""
echo "Test 2: Device Connection"
if $ADB devices | grep -q "device$"; then
    echo "  ✅ Device connected"
else
    echo "  ❌ No device connected"
    exit 1
fi

# Test 3: Check Reverse Proxy
echo ""
echo "Test 3: Reverse Proxy"
if $ADB reverse --list | grep -q "tcp:3001"; then
    echo "  ✅ Reverse proxy configured"
else
    echo "  ⚠️ Configuring reverse proxy..."
    $ADB reverse tcp:3001 tcp:3001
    echo "  ✅ Reverse proxy configured"
fi

# Test 4: Launch App
echo ""
echo "Test 4: Launch App"
$ADB shell monkey -p $APP_PACKAGE -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
sleep 2
echo "  ✅ App launched"

# Test 5: Check Login API
echo ""
echo "Test 5: Login API"
LOGIN_RESPONSE=$(curl -s -X POST $MOCK_API/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"maria@teste.com"}')
if echo "$LOGIN_RESPONSE" | grep -q "token"; then
    echo "  ✅ Login API working"
else
    echo "  ❌ Login API failed"
fi

# Test 6: Check Plantas API
echo ""
echo "Test 6: Plantas API"
PLANTAS_RESPONSE=$(curl -s $MOCK_API/plantas)
if echo "$PLANTAS_RESPONSE" | grep -q "nome"; then
    echo "  ✅ Plantas API working"
else
    echo "  ❌ Plantas API failed"
fi

# Test 7: Check Variedades API
echo ""
echo "Test 7: Variedades API"
VARIEDADES_RESPONSE=$(curl -s $MOCK_API/geneticas)
if echo "$VARIEDADES_RESPONSE" | grep -q "nome"; then
    echo "  ✅ Variedades API working"
else
    echo "  ❌ Variedades API failed"
fi

# Test 8: Check Cultivos API
echo ""
echo "Test 8: Cultivos API"
CULTIVOS_RESPONSE=$(curl -s $MOCK_API/cultivos)
if echo "$CULTIVOS_RESPONSE" | grep -q "nome"; then
    echo "  ✅ Cultivos API working"
else
    echo "  ❌ Cultivos API failed"
fi

# Test 9: Check Diário API
echo ""
echo "Test 9: Diário API"
DIARIO_RESPONSE=$(curl -s $MOCK_API/diario-cultivo)
if echo "$DIARIO_RESPONSE" | grep -q "titulo"; then
    echo "  ✅ Diário API working"
else
    echo "  ❌ Diário API failed"
fi

# Test 10: Check Tarefas API
echo ""
echo "Test 10: Tarefas API"
TAREFAS_RESPONSE=$(curl -s $MOCK_API/tarefas)
if echo "$TAREFAS_RESPONSE" | grep -q "titulo"; then
    echo "  ✅ Tarefas API working"
else
    echo "  ❌ Tarefas API failed"
fi

# Test 11: Check Insumos API
echo ""
echo "Test 11: Insumos API"
INSUMOS_RESPONSE=$(curl -s $MOCK_API/insumos)
if echo "$INSUMOS_RESPONSE" | grep -q "nome"; then
    echo "  ✅ Insumos API working"
else
    echo "  ❌ Insumos API failed"
fi

echo ""
echo "=========================================="
echo "Tests completed!"
echo "=========================================="
