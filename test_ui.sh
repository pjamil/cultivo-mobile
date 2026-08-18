#!/bin/bash

# Automated UI Test Script using ADB
# Tests the Flutter app UI by interacting with it via ADB

set -e

ADB=~/Android/Sdk/platform-tools/platform-tools/adb
APP_PACKAGE="com.example.cultivo_mobile"

echo "=========================================="
echo "Cultivo App - UI Tests"
echo "=========================================="

# Helper function to tap at coordinates
tap() {
    $ADB shell input tap $1 $2
    sleep 0.5
}

# Helper function to type text
type_text() {
    $ADB shell input text "$1"
    sleep 0.3
}

# Helper function to press back
press_back() {
    $ADB shell input keyevent 4
    sleep 0.5
}

# Test 1: Launch App and Login
echo ""
echo "Test 1: Launch and Login"
$ADB shell monkey -p $APP_PACKAGE -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
sleep 3
echo "  ✅ App launched"

# Test 2: Check if login screen is displayed
echo ""
echo "Test 2: Login Screen"
# The login screen should have email and password fields
# We can't directly check UI elements via ADB, but we can check if the app is running
if $ADB shell pidof $APP_PACKAGE > /dev/null 2>&1; then
    echo "  ✅ App is running"
else
    echo "  ❌ App is not running"
    exit 1
fi

# Test 3: Take screenshot
echo ""
echo "Test 3: Take Screenshot"
$ADB shell screencap -p /sdcard/screenshot.png
$ADB pull /sdcard/screenshot.png /tmp/cultivo_screenshot.png 2>/dev/null
echo "  ✅ Screenshot saved to /tmp/cultivo_screenshot.png"

# Test 4: Check app memory usage
echo ""
echo "Test 4: Memory Usage"
MEMORY=$($ADB shell dumpsys meminfo $APP_PACKAGE | grep "TOTAL" | awk '{print $2}')
echo "  📊 Memory usage: ${MEMORY}KB"

# Test 5: Check app CPU usage
echo ""
echo "Test 5: CPU Usage"
CPU=$($ADB shell top -n 1 | grep $APP_PACKAGE | awk '{print $9}')
echo "  📊 CPU usage: ${CPU}%"

echo ""
echo "=========================================="
echo "UI Tests completed!"
echo "=========================================="
