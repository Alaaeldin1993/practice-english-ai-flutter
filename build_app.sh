#!/bin/bash

# Practice English AI - Automated Build Script
# This script automates the APK and AAB building process

echo "=========================================="
echo "Practice English AI - Build Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo -e "${YELLOW}Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found${NC}"
flutter --version
echo ""

# Check Flutter doctor
echo -e "${YELLOW}Running Flutter doctor...${NC}"
flutter doctor
echo ""

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
flutter clean
echo -e "${GREEN}✓ Clean complete${NC}"
echo ""

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to get dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Build APK
echo -e "${YELLOW}Building APK (this may take a few minutes)...${NC}"
flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: APK build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ APK build complete${NC}"
echo ""

# Build AAB
echo -e "${YELLOW}Building AAB (this may take a few minutes)...${NC}"
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: AAB build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ AAB build complete${NC}"
echo ""

# Build split APKs
echo -e "${YELLOW}Building split APKs...${NC}"
flutter build apk --split-per-abi --release
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: Split APK build failed (optional)${NC}"
else
    echo -e "${GREEN}✓ Split APKs build complete${NC}"
fi
echo ""

# Show build results
echo "=========================================="
echo -e "${GREEN}BUILD SUCCESSFUL!${NC}"
echo "=========================================="
echo ""
echo "Your build files are located at:"
echo ""
echo -e "${GREEN}APK (Universal):${NC}"
echo "  build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo -e "${GREEN}AAB (Google Play Store):${NC}"
echo "  build/app/outputs/bundle/release/app-release.aab"
echo ""
echo -e "${GREEN}Split APKs (if successful):${NC}"
echo "  build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk"
echo "  build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
echo "  build/app/outputs/flutter-apk/app-x86_64-release.apk"
echo ""

# Show file sizes
echo "File sizes:"
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "  APK: $APK_SIZE"
fi
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
    echo "  AAB: $AAB_SIZE"
fi
echo ""

echo "=========================================="
echo -e "${GREEN}Next Steps:${NC}"
echo "=========================================="
echo "1. Test APK on Android device"
echo "2. Upload AAB to Google Play Console"
echo "3. Complete store listing and submit"
echo ""
echo -e "${YELLOW}Important:${NC} Make sure you've updated:"
echo "  - API endpoint in lib/services/api_service.dart"
echo "  - AdMob IDs in lib/services/admob_service.dart"
echo "  - App signing for production release"
echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
