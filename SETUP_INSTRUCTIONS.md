# Flutter App Setup Instructions

## Quick Setup Guide

### 1. Prerequisites
- Flutter SDK 3.0+
- Android Studio (for Android)
- Xcode (for iOS, macOS only)

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure API Endpoint
Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://yourdomain.com/api';
```

### 4. Configure AdMob
Edit `lib/services/admob_service.dart` and replace test ad unit IDs:
```dart
static const String _bannerAdUnitId = 'your-banner-ad-unit-id';
static const String _interstitialAdUnitId = 'your-interstitial-ad-unit-id';
static const String _rewardedAdUnitId = 'your-rewarded-ad-unit-id';
```

### 5. Update Android Configuration
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="your-admob-app-id"/>
```

### 6. Update iOS Configuration
Edit `ios/Runner/Info.plist`:
```xml
<key>GADApplicationIdentifier</key>
<string>your-admob-app-id</string>
```

### 7. Build the App

**For Android:**
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Google Play)
flutter build appbundle --release
```

**For iOS:**
```bash
flutter build ios --release
```

### 8. Test the App
```bash
flutter run
```

## Important Notes

- Replace all "your-domain.com" with your actual domain
- Replace all AdMob test IDs with your actual ad unit IDs
- Test thoroughly before publishing to app stores
- Ensure your Laravel backend is running and accessible

## App Store Deployment

### Google Play Store
1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Complete store listing
4. Submit for review

### Apple App Store
1. Build for iOS: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Complete app information
5. Submit for review

