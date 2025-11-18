#!/bin/zsh

echo "Uploading app and running on Maestro's native cloud (maestro.dev)..."
echo "Note: This requires signing up at https://app.maestro.dev"
echo ""

# Update flow to use local package name instead of BrowserStack ID
cat > sample_flow.yaml << 'EOF'
appId: waterwala.com.prime
# Optional: Specify device for Maestro Cloud
# devices:
#   - "Google Pixel 7-12.0"
#   - "Samsung Galaxy S22-12.0"
---
- launchApp
- tapOn: "Mobile Number"
- inputText: "9999999999"
- tapOn: "Request OTP"
# OTP Entry and Validation
- assertVisible: "Enter OTP"
- assertVisible: "Submit the 4-digit OTP we sent to your mobile number 9999999999"
# OTP Entry using element id and index
- tapOn:
    id: "waterwala.com.prime:id/otp_view"
    index: 1
- inputText: "1"
- tapOn:
    id: "waterwala.com.prime:id/otp_view"
    index: 2
- inputText: "2"
- tapOn:
    id: "waterwala.com.prime:id/otp_view"
    index: 3
- inputText: "3"
- tapOn:
    id: "waterwala.com.prime:id/otp_view"
    index: 4
- inputText: "4"
- tapOn: "Continue"
# Optionally, assert next screen or success message
EOF

# Try with local APK if available
if [ -f "../dp_mobile_automation/src/test/resources/drinkPrimeAPK/dp-customer-app-may-changes-qa.apk" ]; then
    echo "Found local APK, using it..."
    maestro cloud --app-file ../dp_mobile_automation/src/test/resources/drinkPrimeAPK/dp-customer-app-may-changes-qa.apk sample_flow.yaml
else
    echo "No local APK found. You need to either:"
    echo "1. Put your APK file in this directory and run: maestro cloud --app-file your-app.apk sample_flow.yaml"
    echo "2. Or sign up at https://app.maestro.dev to upload your app there"
    echo ""
    echo "For now, trying without app file (will fail but shows you the process):"
    maestro cloud sample_flow.yaml
fi

echo ""
echo "Do you want to keep the Maestro logs? (y/n): "
read keep_logs

if [[ "$keep_logs" == "n" ]]; then
  rm -rf ~/.maestro/logs
  echo "Logs deleted."
else
  echo "Logs kept."
fi