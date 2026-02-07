import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/progress_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const VideosScreen(),
    const AiChatScreen(),
    const QuizScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey400,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            activeIcon: Icon(Icons.play_circle),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Good morning!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Main Title
                      const Text(
                        'Practice English AI',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Master English with AI-powered conversations, interactive lessons, and personalized feedback. Earn rewards while you learn!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Feature Cards Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FeatureCard(
                              icon: Icons.chat_bubble,
                              iconColor: AppColors.orange,
                              title: 'AI Conversation\nPractice',
                              description: 'Practice speaking with our advanced AI tutor that adapts to your level',
                              onTap: () => Navigator.pushNamed(context, '/ai-chat'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FeatureCard(
                              icon: Icons.school,
                              iconColor: AppColors.green,
                              title: 'IELTS\nPreparation',
                              description: 'Complete IELTS prep with mock tests, speaking practice, and expert feedback',
                              onTap: () => Navigator.pushNamed(context, '/ielts'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FeatureCard(
                        icon: Icons.emoji_events,
                        iconColor: AppColors.orange,
                        title: 'Earn Real Rewards',
                        description: 'Get rewarded for your progress with points that convert to real money',
                        isWide: true,
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // White Content Section
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Join Thousands of Learners',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  StatsCard(
                                    value: '10K+',
                                    label: 'Active Users',
                                    color: AppColors.orange,
                                  ),
                                  StatsCard(
                                    value: '500+',
                                    label: 'Video Lessons',
                                    color: AppColors.green,
                                  ),
                                  StatsCard(
                                    value: '\$50K+',
                                    label: 'Rewards Paid',
                                    color: AppColors.yellow,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // How It Works Section
                        const Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Column(
                          children: [
                            ProgressCard(
                              step: '1',
                              icon: Icons.person_add,
                              iconColor: AppColors.primary,
                              title: 'Sign Up',
                              description: 'Create your free account and set your learning goals',
                            ),
                            const SizedBox(height: 16),
                            ProgressCard(
                              step: '2',
                              icon: Icons.chat,
                              iconColor: AppColors.green,
                              title: 'Learn & Practice',
                              description: 'Watch lessons, take quizzes, and chat with AI',
                            ),
                            const SizedBox(height: 16),
                            ProgressCard(
                              step: '3',
                              icon: Icons.trending_up,
                              iconColor: AppColors.orange,
                              title: 'Track Progress',
                              description: 'Monitor your improvement and earn achievements',
                            ),
                            const SizedBox(height: 16),
                            ProgressCard(
                              step: '4',
                              icon: Icons.card_giftcard,
                              iconColor: AppColors.primary,
                              title: 'Earn Rewards',
                              description: 'Convert your points to real money via PayPal',
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // CTA Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppColors.ctaGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Ready to Start Learning?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Join our community and start earning rewards for improving your English today!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/ai-chat'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.rocket_launch),
                                    SizedBox(width: 8),
                                    Text(
                                      'Start Learning Now!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder screens for navigation
class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Videos Screen'),
      ),
    );
  }
}

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AI Chat Screen'),
      ),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Quiz Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}

