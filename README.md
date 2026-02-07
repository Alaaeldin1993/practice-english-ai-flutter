# Practice English AI - Flutter Mobile App

A comprehensive English learning mobile application with AI-powered conversations, interactive lessons, IELTS preparation, and real money rewards system.

## Features

- 🤖 **AI-Powered Conversations**: Chat with advanced AI tutor
- 📚 **Interactive Lessons**: Video content and quizzes
- 🎯 **IELTS Preparation**: Complete mock tests and practice
- 💰 **Rewards System**: Earn real money through learning
- 📊 **Progress Tracking**: Monitor your learning journey
- 🎮 **Gamification**: Points, achievements, and streaks

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode
- AdMob Account
- API Backend URL

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd practice_english_ai_flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure API endpoint**
Update the base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://yourdomain.com/api';
```

4. **Configure AdMob**
Update ad unit IDs in `lib/services/admob_service.dart`:
```dart
static const String _bannerAdUnitId = 'your-banner-ad-unit-id';
static const String _interstitialAdUnitId = 'your-interstitial-ad-unit-id';
static const String _rewardedAdUnitId = 'your-rewarded-ad-unit-id';
```

5. **Run the app**
```bash
flutter run
```

## Building for Release

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── screens/                  # UI screens
│   ├── auth/                # Authentication screens
│   ├── home/                # Home and dashboard
│   ├── ai_chat/             # AI conversation screens
│   ├── rewards/             # Rewards and points
│   ├── videos/              # Video lessons
│   ├── quiz/                # Quiz screens
│   ├── ielts/               # IELTS preparation
│   └── profile/             # User profile
├── services/                # Business logic
│   ├── api_service.dart     # API communication
│   ├── auth_service.dart    # Authentication
│   ├── admob_service.dart   # AdMob integration
│   └── rewards_service.dart # Rewards system
├── utils/                   # Utilities and helpers
│   └── app_colors.dart      # Color constants
└── widgets/                 # Reusable UI components
```

## Configuration

### Environment Setup

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://yourdomain.com/api
ADMOB_APP_ID_ANDROID=ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx
ADMOB_APP_ID_IOS=ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx
ADMOB_BANNER_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
ADMOB_INTERSTITIAL_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
ADMOB_REWARDED_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
```

### Android Configuration

1. Update `android/app/src/main/AndroidManifest.xml` with your AdMob App ID
2. Configure app signing in `android/app/build.gradle`
3. Set proper permissions for microphone, camera, and storage

### iOS Configuration

1. Update `ios/Runner/Info.plist` with your AdMob App ID
2. Configure app permissions for microphone, camera, and photo library
3. Set up proper bundle identifier and signing

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `http`: HTTP client for API calls
- `shared_preferences`: Local storage

### UI Dependencies
- `cached_network_image`: Image caching
- `shimmer`: Loading animations
- `lottie`: Lottie animations
- `flutter_svg`: SVG support

### Feature Dependencies
- `google_mobile_ads`: AdMob integration
- `speech_to_text`: Speech recognition
- `flutter_tts`: Text-to-speech
- `video_player`: Video playback
- `image_picker`: Image selection

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Deployment

### Google Play Store

1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Complete store listing with screenshots and descriptions
4. Submit for review

### Apple App Store

1. Build for iOS: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Complete app information and submit for review

## Troubleshooting

### Common Issues

**Build fails with dependency conflicts**
```bash
flutter clean
flutter pub get
```

**AdMob ads not showing**
- Verify ad unit IDs are correct
- Check AdMob account status
- Ensure test device is properly configured

**API connection issues**
- Verify backend URL is accessible
- Check CORS configuration on backend
- Ensure SSL certificate is valid

## Support

For technical support or questions:
- Check the documentation in the `docs/` folder
- Review the troubleshooting guide
- Contact the development team

## License

This project is licensed under the MIT License - see the LICENSE file for details.

