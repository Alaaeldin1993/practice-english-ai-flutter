@echo off
REM Practice English AI - Automated Build Script for Windows
REM This script automates the APK and AAB building process

echo ==========================================
echo Practice English AI - Build Script
echo ==========================================
echo.

REM Check if Flutter is installed
echo Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo [OK] Flutter found
flutter --version
echo.

REM Check Flutter doctor
echo Running Flutter doctor...
flutter doctor
echo.

REM Clean previous builds
echo Cleaning previous builds...
flutter clean
echo [OK] Clean complete
echo.

REM Get dependencies
echo Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to get dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

REM Build APK
echo Building APK (this may take a few minutes)...
flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo Error: APK build failed
    pause
    exit /b 1
)
echo [OK] APK build complete
echo.

REM Build AAB
echo Building AAB (this may take a few minutes)...
flutter build appbundle --release
if %ERRORLEVEL% NEQ 0 (
    echo Error: AAB build failed
    pause
    exit /b 1
)
echo [OK] AAB build complete
echo.

REM Build split APKs
echo Building split APKs...
flutter build apk --split-per-abi --release
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Split APK build failed (optional)
) else (
    echo [OK] Split APKs build complete
)
echo.

REM Show build results
echo ==========================================
echo BUILD SUCCESSFUL!
echo ==========================================
echo.
echo Your build files are located at:
echo.
echo APK (Universal):
echo   build\app\outputs\flutter-apk\app-release.apk
echo.
echo AAB (Google Play Store):
echo   build\app\outputs\bundle\release\app-release.aab
echo.
echo Split APKs (if successful):
echo   build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk
echo   build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
echo   build\app\outputs\flutter-apk\app-x86_64-release.apk
echo.
echo ==========================================
echo Next Steps:
echo ==========================================
echo 1. Test APK on Android device
echo 2. Upload AAB to Google Play Console
echo 3. Complete store listing and submit
echo.
echo Important: Make sure you've updated:
echo   - API endpoint in lib\services\api_service.dart
echo   - AdMob IDs in lib\services\admob_service.dart
echo   - App signing for production release
echo.
echo ==========================================
echo Build completed successfully!
echo ==========================================
echo.
pause
