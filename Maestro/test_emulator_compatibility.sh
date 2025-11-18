#!/bin/bash

echo "=== Testing DrinkPrime app on different emulator configurations ==="

APK_FILE="android-customer-app-changes-may-s1.apk"

if [ ! -f "$APK_FILE" ]; then
    echo "APK file not found: $APK_FILE"
    exit 1
fi

echo "1. Installing APK with force reinstall..."
adb install -r "$APK_FILE"

echo "2. Getting package info..."
PACKAGE_NAME=$(aapt dump badging "$APK_FILE" | grep "package:" | sed -n "s/.*name='\([^']*\)'.*/\1/p" || echo "waterwala.com.prime")
echo "Package name: $PACKAGE_NAME"

echo "3. Checking device capabilities..."
adb shell getprop ro.product.cpu.abi
adb shell getprop ro.build.version.sdk

echo "4. Clearing app data..."
adb shell pm clear "$PACKAGE_NAME" 2>/dev/null || echo "Could not clear app data"

echo "5. Granting permissions..."
adb shell pm grant "$PACKAGE_NAME" android.permission.READ_PHONE_STATE 2>/dev/null || echo "Permission already granted or not needed"
adb shell pm grant "$PACKAGE_NAME" android.permission.INTERNET 2>/dev/null || echo "Internet permission already granted"

echo "6. Attempting to start app..."
adb shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1

echo "7. Waiting and checking if app is running..."
sleep 10
adb shell ps | grep "$PACKAGE_NAME" || echo "App not found in running processes"

echo "8. Taking screenshot..."
adb shell screencap -p > test_screenshot.png

echo "9. Running crash debug flow..."
maestro test crash_debug_flow.yaml

echo "Done! Check the screenshots to see what happened."