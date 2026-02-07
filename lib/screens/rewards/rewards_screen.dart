import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/rewards_service.dart';
import '../../services/admob_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/rewards_card.dart';
import '../../widgets/points_history_card.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdMobService _adMobService = AdMobService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    _adMobService.preloadAds();
  }

  Future<void> _loadData() async {
    final rewardsService = Provider.of<RewardsService>(context, listen: false);
    await Future.wait([
      rewardsService.loadUserPoints(),
      rewardsService.loadPayouts(),
      rewardsService.loadRewardsSettings(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards & Points'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Earn Points'),
            Tab(text: 'Payouts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildEarnPointsTab(),
          _buildPayoutsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<RewardsService>(
      builder: (context, rewardsService, child) {
        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Points Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your Points Balance',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${rewardsService.currentPoints}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${rewardsService.pointsToUSD(rewardsService.currentPoints).toStringAsFixed(2)} USD',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: RewardsCard(
                        title: 'Total Earned',
                        value: '${rewardsService.totalEarned}',
                        subtitle: '\$${rewardsService.pointsToUSD(rewardsService.totalEarned).toStringAsFixed(2)}',
                        icon: Icons.trending_up,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RewardsCard(
                        title: 'Total Redeemed',
                        value: '${rewardsService.totalRedeemed}',
                        subtitle: '\$${rewardsService.pointsToUSD(rewardsService.totalRedeemed).toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Recent Transactions
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                if (rewardsService.recentTransactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No transactions yet.\nStart earning points by using the app!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...rewardsService.recentTransactions.map(
                    (transaction) => PointsHistoryCard(transaction: transaction),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarnPointsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earn Points',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete activities and watch ads to earn points that can be converted to real money!',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Watch Ads Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Watch Ads',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Rewarded Video Ad
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Watch Rewarded Video'),
                  subtitle: const Text('Earn 10-50 points per video'),
                  trailing: ElevatedButton(
                    onPressed: _adMobService.isRewardedAdLoaded ? _showRewardedAd : null,
                    child: const Text('Watch'),
                  ),
                ),
                
                const Divider(),
                
                // Interstitial Ad
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('View Interstitial Ad'),
                  subtitle: const Text('Earn 5 points per ad'),
                  trailing: ElevatedButton(
                    onPressed: _adMobService.isInterstitialAdLoaded ? _showInterstitialAd : null,
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Activities Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildActivityTile(
                  'AI Conversation',
                  'Chat with AI tutor',
                  '5 points per conversation',
                  Icons.chat_bubble,
                  AppColors.primary,
                ),
                
                _buildActivityTile(
                  'Complete Video Lesson',
                  'Watch educational videos',
                  '10 points per video',
                  Icons.play_circle,
                  AppColors.green,
                ),
                
                _buildActivityTile(
                  'Finish Quiz',
                  'Test your knowledge',
                  '15 points per quiz',
                  Icons.quiz,
                  AppColors.orange,
                ),
                
                _buildActivityTile(
                  'IELTS Practice',
                  'Practice IELTS tests',
                  '20 points per session',
                  Icons.school,
                  AppColors.purple,
                ),
                
                _buildActivityTile(
                  'Daily Login',
                  'Open the app daily',
                  '2 points per day',
                  Icons.login,
                  AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String points, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          points,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPayoutsTab() {
    return Consumer<RewardsService>(
      builder: (context, rewardsService, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payout Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payout Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Minimum payout: ${rewardsService.minimumPayoutAmount} points (\$${rewardsService.pointsToUSD(rewardsService.minimumPayoutAmount).toStringAsFixed(2)})',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Payouts are processed within 3-5 business days',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Request Payout Button
              if (rewardsService.canRequestPayout(rewardsService.minimumPayoutAmount))
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showPayoutDialog(context, rewardsService),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Request Payout'),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'You need at least ${rewardsService.minimumPayoutAmount} points to request a payout',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Payout History
              const Text(
                'Payout History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              if (rewardsService.payouts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No payouts yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...rewardsService.payouts.map(
                  (payout) => _buildPayoutCard(payout),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPayoutCard(Payout payout) {
    Color statusColor;
    switch (payout.status) {
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'failed':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.grey400;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${payout.usdAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    payout.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${payout.pointsAmount} points via ${payout.payoutMethod}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Requested: ${payout.createdAt.toString().split(' ')[0]}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRewardedAd() {
    _adMobService.showRewardedAd(
      onUserEarnedReward: (points) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You earned $points points!'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadData(); // Refresh points
      },
    );
  }

  void _showInterstitialAd() {
    _adMobService.showInterstitialAd(
      onAdClosed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You earned 5 points!'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadData(); // Refresh points
      },
    );
  }

  void _showPayoutDialog(BuildContext context, RewardsService rewardsService) {
    // Implementation for payout dialog would go here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Payout'),
        content: const Text('Payout dialog implementation would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }
}

