#!/bin/bash

# Complete Test Suite for Cultivo App
# Runs all API tests and UI tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Cultivo App - Complete Test Suite"
echo "=========================================="
echo "Date: $(date)"
echo ""

# Track test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_name=$1
    local test_script=$2
    
    echo "Running: $test_name"
    echo "------------------------------------------"
    
    if bash "$test_script" 2>&1; then
        echo "✅ $test_name - PASSED"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo "❌ $test_name - FAILED"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo ""
}

# Run API Tests
echo "Running API Tests..."
echo "=========================================="
run_test "Mock API" "$SCRIPT_DIR/test_apis.sh"
run_test "Plantas API" "$SCRIPT_DIR/test_cultivos.sh"
run_test "Cultivos API" "$SCRIPT_DIR/test_cultivos.sh"
run_test "Diário API" "$SCRIPT_DIR/test_diario.sh"
run_test "Tarefas API" "$SCRIPT_DIR/test_tarefas.sh"
run_test "Insumos API" "$SCRIPT_DIR/test_insumos.sh"
run_test "Ambientes API" "$SCRIPT_DIR/test_ambientes.sh"
run_test "Dashboard API" "$SCRIPT_DIR/test_dashboard.sh"

# Run UI Tests
echo ""
echo "Running UI Tests..."
echo "=========================================="
run_test "UI Tests" "$SCRIPT_DIR/test_ui.sh"

echo ""
echo "=========================================="
echo "TEST SUITE SUMMARY"
echo "=========================================="
echo "Total tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $FAILED_TESTS"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo "✅ All tests PASSED"
    exit 0
else
    echo "❌ $FAILED_TESTS test(s) FAILED"
    exit 1
fi
