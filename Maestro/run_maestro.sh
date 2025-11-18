#!/bin/zsh

echo "Running Maestro test locally..."
echo ""

# Check if APK file exists
APK_PATH="../dp_mobile_automation/src/test/resources/drinkPrimeAPK/dp-customer-app-may-changes-qa.apk"

if [ -f "$APK_PATH" ]; then
    echo "Found APK at: $APK_PATH"
    echo "Installing APK on connected device/emulator..."
    adb install "$APK_PATH"
    echo ""
    echo "Running Maestro test..."
    maestro test sample_flow.yaml
else
    echo "APK not found at: $APK_PATH"
    echo "Available APK files:"
    find .. -name "*.apk" -type f 2>/dev/null || echo "No APK files found"
    echo ""
    echo "Please ensure your APK is available at the expected path"
    exit 1
fi

echo "Do you want to keep the Maestro logs? (y/n): "
read keep_logs

if [[ "$keep_logs" == "n" ]]; then
  rm -rf ~/.maestro/logs
  echo "Logs deleted."
else
  echo "Logs kept."
fi