import 'package:flutter/material.dart';

class MoreTipsPage extends StatelessWidget {
  const MoreTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Nutrition Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategorySection(
                        'Protein Tips',
                        [
                          _buildTipCard(
                            'Protein Timing',
                            'Consume protein within 30 minutes after your workout to maximize muscle recovery and growth.',
                            Icons.timer,
                          ),
                          _buildTipCard(
                            'Plant-Based Protein',
                            'Combine different plant proteins like beans and rice to get all essential amino acids if you\'re vegetarian or vegan.',
                            Icons.eco,
                          ),
                          _buildTipCard(
                            'Protein Distribution',
                            'Spread your protein intake throughout the day instead of consuming it all in one meal for better absorption.',
                            Icons.access_time,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildCategorySection(
                        'Hydration Tips',
                        [
                          _buildTipCard(
                            'Pre-Workout Hydration',
                            'Drink 16-20 oz of water at least 4 hours before exercise and 8-10 oz 10-15 minutes before starting.',
                            Icons.fitness_center,
                          ),
                          _buildTipCard(
                            'Electrolyte Balance',
                            "For workouts lasting over an hour, consider drinks with electrolytes to replace what's lost through sweat.",
                            Icons.bolt,
                          ),
                          _buildTipCard(
                            'Hydration Tracking',
                            'Monitor your urine color - pale yellow indicates good hydration, while dark yellow suggests you need more fluids.',
                            Icons.colorize,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildCategorySection(
                        'Carbohydrate Tips',
                        [
                          _buildTipCard(
                            'Pre-Workout Carbs',
                            'Consume easily digestible carbs 30-60 minutes before exercise to fuel your workout.',
                            Icons.sports,
                          ),
                          _buildTipCard(
                            'Post-Workout Window',
                            'Eat carbs with protein within 30 minutes after exercise to replenish glycogen stores and aid recovery.',
                            Icons.restore,
                          ),
                          _buildTipCard(
                            'Complex Carbs',
                            'Focus on whole grains, fruits, and vegetables for sustained energy throughout the day.',
                            Icons.grain,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildCategorySection(
                        'Fat Consumption Tips',
                        [
                          _buildTipCard(
                            'Healthy Fats',
                            'Include sources of omega-3 fatty acids like fatty fish, walnuts, and flaxseeds to reduce inflammation.',
                            Icons.set_meal,
                          ),
                          _buildTipCard(
                            'Fat Timing',
                            'Avoid high-fat meals right before workouts as they can slow digestion and cause discomfort.',
                            Icons.schedule,
                          ),
                          _buildTipCard(
                            'Balanced Fat Intake',
                            'Aim for a mix of monounsaturated, polyunsaturated, and saturated fats, with limited trans fats.',
                            Icons.balance,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildCategorySection(
                        'Meal Planning Tips',
                        [
                          _buildTipCard(
                            'Meal Prep',
                            "Prepare meals in advance to ensure you have nutritious options available when you're busy or tired.",
                            Icons.food_bank,
                          ),
                          _buildTipCard(
                            'Portion Control',
                            'Use smaller plates and measure portions to avoid overeating, even with healthy foods.',
                            Icons.straighten,
                          ),
                          _buildTipCard(
                            'Eating Schedule',
                            'Try to eat at consistent times each day to regulate hunger and optimize metabolism.',
                            Icons.watch_later,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...tips,
      ],
    );
  }

  Widget _buildTipCard(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 24),
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 