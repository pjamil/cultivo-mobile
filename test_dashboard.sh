#!/bin/bash

# Dashboard API Test Script
# Tests the Dashboard endpoint

set -e

MOCK_API="http://localhost:3001"

echo "=========================================="
echo "Dashboard API Tests"
echo "=========================================="

# Test 1: Get Dashboard
echo ""
echo "Test 1: Get Dashboard"
RESPONSE=$(curl -s $MOCK_API/dashboard)
if echo "$RESPONSE" | grep -q "cultivosAtivos"; then
    echo "  ✅ Get Dashboard - PASS"
else
    echo "  ❌ Get Dashboard - FAIL"
fi

echo ""
echo "=========================================="
echo "Dashboard Tests completed!"
echo "=========================================="
