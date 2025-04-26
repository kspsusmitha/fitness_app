import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:confetti/confetti.dart';

class ChallengesTab extends StatefulWidget {
  const ChallengesTab({super.key});

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> with SingleTickerProviderStateMixin {
  // Mock data for challenges and rewards
  final Map<String, bool> dailyTasks = {
    'Complete workout': false,
    'Log meals': false,
    '10,000 steps': false,
    'Track water intake': false,
  };

  int streakDays = 5; // Mock streak count
  int totalPoints = 750; // Mock points
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _playConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStreakCard(),
                    const SizedBox(height: 24),
                    _buildDailyChallenges(),
                    const SizedBox(height: 24),
                    _buildWeeklyChallenges(),
                    const SizedBox(height: 24),
                    _buildRewardsSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.yellow,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Streak',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$streakDays days',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Points',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              totalPoints.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(7, (index) {
                    bool isCompleted = index < streakDays;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: isCompleted ? Colors.blue : Colors.grey.shade200,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isCompleted ? Colors.blue.shade700 : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Day ${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isCompleted ? Colors.blue.shade700 : Colors.grey,
                                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyChallenges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.today, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Daily Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...dailyTasks.entries.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    dailyTasks[task.key] = !task.value;
                    if (dailyTasks[task.key]!) {
                      totalPoints += 50;
                      _playConfetti();
                    } else {
                      totalPoints -= 50;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: task.value ? Colors.blue.shade50 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: task.value ? Colors.blue.shade200 : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: task.value ? Colors.blue : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: task.value ? Colors.blue : Colors.grey,
                          ),
                        ),
                        child: task.value
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.key,
                              style: TextStyle(
                                fontWeight: task.value ? FontWeight.bold : FontWeight.normal,
                                decoration: task.value ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+50 points',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallenges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Weekly Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildWeeklyChallengeItem(
            'Complete 7-day streak',
            '5/7 days',
            0.71,
            '+200 points',
            Icons.local_fire_department,
          ),
          const SizedBox(height: 16),
          _buildWeeklyChallengeItem(
            '70,000 steps this week',
            '45,000/70,000 steps',
            0.64,
            '+300 points',
            Icons.directions_walk,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallengeItem(
    String title,
    String progress,
    double value,
    String reward,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward,
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            percent: value,
            lineHeight: 10,
            animation: true,
            animationDuration: 1000,
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.blue,
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text(
            progress,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Available Rewards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRewardItem(
            'Free Protein Shake',
            '500 points',
            Icons.local_drink,
          ),
          const SizedBox(height: 12),
          _buildRewardItem(
            'Personal Training Session',
            '1000 points',
            Icons.fitness_center,
          ),
          const SizedBox(height: 12),
          _buildRewardItem(
            'Premium Membership (1 month)',
            '2000 points',
            Icons.star,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String title, String points, IconData icon) {
    bool canRedeem = totalPoints >= int.parse(points.split(' ')[0]);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: canRedeem ? Colors.blue.shade50 : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: canRedeem ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  points,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: canRedeem
                ? () {
                    // Handle reward redemption
                    _playConfetti();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Redeemed: $title'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }
}
