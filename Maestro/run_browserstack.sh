#!/bin/zsh

# BrowserStack credentials - prefer environment variables for CI
# Provide these via environment or GitHub Actions secrets:
# - BROWSERSTACK_USERNAME
# - BROWSERSTACK_ACCESS_KEY
# - BROWSERSTACK_APP_ID (optional, falls back to the APP_ID below)
USERNAME="${BROWSERSTACK_USERNAME:-akshaysingh_cxwMG1}"
ACCESS_KEY="${BROWSERSTACK_ACCESS_KEY:-ouEEqoJBfzMGyS3wiRDK}"
APP_ID="${BROWSERSTACK_APP_ID:-bs://d3eccfa773f1b9a1b2f590f602977f175efe580a}"

echo "Step 1: Uploading test suite to BrowserStack..."
# Upload test suite
UPLOAD_RESPONSE=$(curl -s -u "$USERNAME:$ACCESS_KEY" \
  -X POST "https://api-cloud.browserstack.com/app-automate/maestro/v2/test-suite" \
  -F "file=@test_suite.zip" \
  -F "custom_id=SampleMaestroTest")

echo "Upload Response: $UPLOAD_RESPONSE"

# Extract test suite URL from response
TEST_SUITE_URL=$(echo $UPLOAD_RESPONSE | grep -o '"test_suite_url":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TEST_SUITE_URL" ]; then
  echo "Failed to upload test suite. Please check the response above."
  exit 1
fi

echo "Test suite uploaded successfully: $TEST_SUITE_URL"
echo ""
echo "Step 2: Executing tests on BrowserStack..."

# Execute tests
EXECUTE_RESPONSE=$(curl -s -u "$USERNAME:$ACCESS_KEY" \
  -X POST "https://api-cloud.browserstack.com/app-automate/maestro/v2/android/build" \
  -H "Content-Type: application/json" \
  -d '{
    "app": "'$APP_ID'",
    "testSuite": "'$TEST_SUITE_URL'",
    "project": "Maestro_Mobile_Test",
    "devices": [
      "Samsung Galaxy S22-12.0"
    ]
  }')

echo "Execution Response: $EXECUTE_RESPONSE"

# Extract build ID
BUILD_ID=$(echo $EXECUTE_RESPONSE | grep -o '"build_id":"[^"]*"' | cut -d'"' -f4)

if [ -n "$BUILD_ID" ]; then
  echo ""
  echo "✅ Test execution started successfully!"
  echo "Build ID: $BUILD_ID"
  echo "View results at: https://app-automate.browserstack.com/dashboard/v2/builds/$BUILD_ID"
else
  echo "❌ Failed to start test execution. Please check the response above."
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