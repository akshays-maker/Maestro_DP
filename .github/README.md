# Maestro Mobile Test Automation

This repository contains Maestro mobile test automation for the Water Wala app using GitHub Actions.

## GitHub Actions Workflow

The workflow is configured to:
- Run automatically on pushes to `main` and `develop` branches
- Run on pull requests to `main` branch
- Allow manual triggering with test file selection

### Manual Workflow Trigger

You can manually run the test by:
1. Going to the "Actions" tab in your GitHub repository
2. Selecting "Maestro Mobile Test" workflow
3. Clicking "Run workflow" 
4. Optionally selecting which test file to run:
   - `simple_flow.yaml` (default)
   - `sample_flow.yaml`
   - `debug_flow.yaml`

### Test Flow

Your `simple_flow.yaml` contains the following test steps (preserved exactly as you wrote them):

1. Launch the Water Wala app (`waterwala.com.prime`)
2. Enter mobile number: 9876543210
3. Request OTP
4. Enter OTP: 8875 (using individual input fields)
5. Navigate through the app:
   - Continue to subscriber layout
   - Access device info
   - Check plan information
   - Test data refresh
   - Navigate to Payments
   - Access help desk
   - Access menu

### Workflow Features

- **Android Emulator**: Uses Android API 30 with x86_64 architecture
- **APK Installation**: Automatically installs your app APK
- **Screenshot Capture**: Saves screenshots during test execution
- **Artifact Upload**: Saves test results and screenshots for 30 days
- **Maestro Logs**: Captures detailed execution logs

### Test Artifacts

After each test run, you can download:
- Test screenshots (available for 7 days)
- Maestro execution logs (available for 30 days)

### Local Testing

To run tests locally, use the existing script:
```bash
cd Maestro
./run_maestro.sh
```

## Requirements

- Android APK file: `android-customer-app-changes-may-s1.apk`
- Maestro test files in the `Maestro/` directory
- GitHub repository with Actions enabled