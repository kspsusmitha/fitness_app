import 'package:flutter/material.dart';

class ChallengesTab extends StatefulWidget {
  const ChallengesTab({super.key});

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  // Mock data for challenges and rewards
  final Map<String, bool> dailyTasks = {
    'Complete workout': false,
    'Log meals': false,
    '10,000 steps': false,
    'Track water intake': false,
  };

  int streakDays = 5; // Mock streak count
  int totalPoints = 750; // Mock points

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
          borderRadius: BorderRadius.circular(12),
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
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$streakDays days',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Points',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      totalPoints.toString(),
                      style: const TextStyle(
                        color: Colors.white,
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
      ),
    );
  }

  Widget _buildDailyChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Challenges',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: dailyTasks.entries.map((task) {
              return CheckboxListTile(
                title: Text(task.key),
                subtitle: Text('+50 points'),
                value: task.value,
                onChanged: (bool? value) {
                  setState(() {
                    dailyTasks[task.key] = value!;
                    if (value) {
                      totalPoints += 50;
                    } else {
                      totalPoints -= 50;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Challenges',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildWeeklyChallengeItem(
                'Complete 7-day streak',
                '5/7 days',
                0.71,
                '+200 points',
              ),
              _buildWeeklyChallengeItem(
                '70,000 steps this week',
                '45,000/70,000 steps',
                0.64,
                '+300 points',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChallengeItem(
    String title,
    String progress,
    double value,
    String reward,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                reward,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(
            progress,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Rewards',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildRewardItem(
                'Free Protein Shake',
                '500 points',
                Icons.local_drink,
              ),
              _buildRewardItem(
                'Personal Training Session',
                '1000 points',
                Icons.fitness_center,
              ),
              _buildRewardItem(
                'Premium Membership (1 month)',
                '2000 points',
                Icons.star,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardItem(String title, String points, IconData icon) {
    bool canRedeem = totalPoints >= int.parse(points.split(' ')[0]);
    
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(points),
      trailing: ElevatedButton(
        onPressed: canRedeem ? () {
          // Handle reward redemption
        } : null,
        child: const Text('Redeem'),
      ),
    );
  }
}
