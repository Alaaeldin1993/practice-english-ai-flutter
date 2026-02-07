import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'api_service.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  final ApiService _apiService = ApiService();

  // Test Ad Unit IDs (replace with your actual Ad Unit IDs in production)
  static const String _bannerAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111' // Test banner
      : 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_BANNER_AD_UNIT_ID';

  static const String _interstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712' // Test interstitial
      : 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_INTERSTITIAL_AD_UNIT_ID';

  static const String _rewardedAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/5224354917' // Test rewarded
      : 'ca-app-pub-YOUR_PUBLISHER_ID/YOUR_REWARDED_AD_UNIT_ID';

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  // Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Banner Ad Methods
  void loadBannerAd({VoidCallback? onAdLoaded}) {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
          if (kDebugMode) {
            print('Banner ad loaded');
          }
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded = false;
          ad.dispose();
          if (kDebugMode) {
            print('Banner ad failed to load: $error');
          }
        },
        onAdClicked: (ad) {
          _recordAdInteraction('banner', 2);
        },
      ),
    );
    _bannerAd!.load();
  }

  BannerAd? get bannerAd => _isBannerAdLoaded ? _bannerAd : null;

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }

  // Interstitial Ad Methods
  void loadInterstitialAd({VoidCallback? onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          if (kDebugMode) {
            print('Interstitial ad loaded');
          }
          onAdLoaded?.call();

          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoaded = false;
          if (kDebugMode) {
            print('Interstitial ad failed to load: $error');
          }
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          if (kDebugMode) {
            print('Interstitial ad showed');
          }
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
          onAdClosed?.call();
          _recordAdInteraction('interstitial', 5);
          // Load next ad
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
          if (kDebugMode) {
            print('Interstitial ad failed to show: $error');
          }
        },
      );
      _interstitialAd!.show();
    } else {
      if (kDebugMode) {
        print('Interstitial ad not ready');
      }
    }
  }

  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  // Rewarded Ad Methods
  void loadRewardedAd({VoidCallback? onAdLoaded}) {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
          if (kDebugMode) {
            print('Rewarded ad loaded');
          }
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoaded = false;
          if (kDebugMode) {
            print('Rewarded ad failed to load: $error');
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required Function(int points) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (_isRewardedAdLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          if (kDebugMode) {
            print('Rewarded ad showed');
          }
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
          onAdClosed?.call();
          // Load next ad
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded = false;
          if (kDebugMode) {
            print('Rewarded ad failed to show: $error');
          }
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          final points = reward.amount.toInt() * 10; // Convert reward to points
          onUserEarnedReward(points);
          _recordAdInteraction('rewarded', points);
        },
      );
    } else {
      if (kDebugMode) {
        print('Rewarded ad not ready');
      }
    }
  }

  bool get isRewardedAdLoaded => _isRewardedAdLoaded;

  // Record ad interaction with backend
  Future<void> _recordAdInteraction(String adType, int rewardAmount) async {
    try {
      await _apiService.post('/rewards/ad-reward', {
        'ad_type': adType,
        'ad_unit_id': _getAdUnitId(adType),
        'reward_amount': rewardAmount,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to record ad interaction: $e');
      }
    }
  }

  String _getAdUnitId(String adType) {
    switch (adType) {
      case 'banner':
        return _bannerAdUnitId;
      case 'interstitial':
        return _interstitialAdUnitId;
      case 'rewarded':
        return _rewardedAdUnitId;
      default:
        return '';
    }
  }

  // Preload all ads
  void preloadAds() {
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // Dispose all ads
  void disposeAllAds() {
    disposeBannerAd();
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdLoaded = false;
  }
}

