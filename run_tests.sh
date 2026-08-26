#!/bin/bash

# Script to run Flutter integration tests
# Usage: ./run_tests.sh [test_file]

set -e

echo "=========================================="
echo "Flutter Integration Tests"
echo "=========================================="

# Check if mock API is running
echo "Checking mock API..."
if curl -s http://localhost:3001/meus-dados > /dev/null 2>&1; then
    echo "✅ Mock API is running"
else
    echo "❌ Mock API is not running. Starting..."
    cd <caminho-do-cultivo-web>
    pm2 start mock-api/simple-server.js --name cultivo-api
    sleep 2
    if curl -s http://localhost:3001/meus-dados > /dev/null 2>&1; then
        echo "✅ Mock API started successfully"
    else
        echo "❌ Failed to start Mock API"
        exit 1
    fi
fi

# Check if device is connected
echo "Checking device connection..."
~/Android/Sdk/platform-tools/platform-tools/adb devices | grep -q "device$" || {
    echo "❌ No device connected"
    exit 1
}
echo "✅ Device connected"

# Check if reverse proxy is configured
echo "Checking reverse proxy..."
~/Android/Sdk/platform-tools/platform-tools/adb reverse --list | grep -q "tcp:3001" || {
    echo "❌ Reverse proxy not configured. Configuring..."
    ~/Android/Sdk/platform-tools/platform-tools/adb reverse tcp:3001 tcp:3001
}
echo "✅ Reverse proxy configured"

# Run tests
echo ""
echo "Running tests..."
echo "=========================================="

if [ -n "$1" ]; then
    # Run specific test file
    echo "Running: $1"
    flutter test integration_test/$1
else
    # Run all tests
    echo "Running all integration tests..."
    flutter test integration_test/
fi

echo ""
echo "=========================================="
echo "Tests completed!"
echo "=========================================="
