import 'package:flutter/foundation.dart';
import 'api_service.dart';

class RewardsService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  int _currentPoints = 0;
  int _totalEarned = 0;
  int _totalRedeemed = 0;
  List<PointTransaction> _recentTransactions = [];
  List<Payout> _payouts = [];
  Map<String, dynamic> _rewardsSettings = {};

  int get currentPoints => _currentPoints;
  int get totalEarned => _totalEarned;
  int get totalRedeemed => _totalRedeemed;
  List<PointTransaction> get recentTransactions => _recentTransactions;
  List<Payout> get payouts => _payouts;
  Map<String, dynamic> get rewardsSettings => _rewardsSettings;

  Future<void> loadUserPoints() async {
    try {
      final response = await _apiService.get('/rewards/points');
      if (response['success'] == true) {
        final data = response['data'];
        _currentPoints = data['current_points'] ?? 0;
        _totalEarned = data['total_earned'] ?? 0;
        _totalRedeemed = data['total_redeemed'] ?? 0;
        _recentTransactions = (data['recent_transactions'] as List?)
            ?.map((item) => PointTransaction.fromJson(item))
            .toList() ?? [];
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user points: $e');
      }
    }
  }

  Future<List<PointTransaction>> getPointsHistory({String? type}) async {
    try {
      String endpoint = '/rewards/points/history';
      if (type != null) {
        endpoint += '?type=$type';
      }
      
      final response = await _apiService.get(endpoint);
      if (response['success'] == true) {
        final data = response['data']['data'] as List;
        return data.map((item) => PointTransaction.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error loading points history: $e');
      }
      return [];
    }
  }

  Future<bool> recordAdReward(String adType, String adUnitId, int rewardAmount) async {
    try {
      final response = await _apiService.post('/rewards/ad-reward', {
        'ad_type': adType,
        'ad_unit_id': adUnitId,
        'reward_amount': rewardAmount,
      });
      
      if (response['success'] == true) {
        final data = response['data'];
        _currentPoints = data['total_points'] ?? _currentPoints;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error recording ad reward: $e');
      }
      return false;
    }
  }

  Future<bool> awardActivityPoints(String activityType, {String? referenceId}) async {
    try {
      final response = await _apiService.post('/rewards/activity-points', {
        'activity_type': activityType,
        'reference_id': referenceId,
      });
      
      if (response['success'] == true) {
        final data = response['data'];
        _currentPoints = data['total_points'] ?? _currentPoints;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error awarding activity points: $e');
      }
      return false;
    }
  }

  Future<bool> requestPayout(int amount, String payoutMethod, Map<String, dynamic> payoutDetails) async {
    try {
      final response = await _apiService.post('/rewards/payout', {
        'amount': amount,
        'payout_method': payoutMethod,
        'payout_details': payoutDetails,
      });
      
      if (response['success'] == true) {
        _currentPoints -= amount;
        notifyListeners();
        await loadPayouts(); // Refresh payouts list
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting payout: $e');
      }
      return false;
    }
  }

  Future<void> loadPayouts() async {
    try {
      final response = await _apiService.get('/rewards/payouts');
      if (response['success'] == true) {
        final data = response['data']['data'] as List;
        _payouts = data.map((item) => Payout.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading payouts: $e');
      }
    }
  }

  Future<void> loadRewardsSettings() async {
    try {
      final response = await _apiService.get('/rewards/settings');
      if (response['success'] == true) {
        _rewardsSettings = response['data'];
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading rewards settings: $e');
      }
    }
  }

  double pointsToUSD(int points) {
    final pointsPerDollar = _rewardsSettings['points_per_dollar'] ?? 100;
    return points / pointsPerDollar;
  }

  int usdToPoints(double usd) {
    final pointsPerDollar = _rewardsSettings['points_per_dollar'] ?? 100;
    return (usd * pointsPerDollar).round();
  }

  bool canRequestPayout(int amount) {
    final minimumPayout = _rewardsSettings['minimum_payout'] ?? 1000;
    return _currentPoints >= amount && amount >= minimumPayout;
  }

  int get minimumPayoutAmount => _rewardsSettings['minimum_payout'] ?? 1000;
}

class PointTransaction {
  final int id;
  final String type;
  final int points;
  final String source;
  final String description;
  final DateTime createdAt;

  PointTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.source,
    required this.description,
    required this.createdAt,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      type: json['type'],
      points: json['points'],
      source: json['source'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Payout {
  final int id;
  final int pointsAmount;
  final double usdAmount;
  final String payoutMethod;
  final String status;
  final DateTime createdAt;
  final DateTime? processedAt;

  Payout({
    required this.id,
    required this.pointsAmount,
    required this.usdAmount,
    required this.payoutMethod,
    required this.status,
    required this.createdAt,
    this.processedAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'],
      pointsAmount: json['points_amount'],
      usdAmount: json['usd_amount'].toDouble(),
      payoutMethod: json['payout_method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at']) 
          : null,
    );
  }
}

