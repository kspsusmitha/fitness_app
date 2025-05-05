import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietPlanPage extends StatefulWidget {
  const DietPlanPage({super.key});

  @override
  State<DietPlanPage> createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _userId;
  Map<String, Map<String, Map<String, int>>> _completedMeals = {};

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      
      // Get user data
      final snapshot = await _database
          .child('users/trainees')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (snapshot.exists) {
        final userData = (snapshot.value as Map).entries.first;
        _userId = userData.key;
        _loadCompletedMeals();
      }
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }

  Future<void> _loadCompletedMeals() async {
    if (_userId == null) return;

    try {
      final snapshot = await _database
          .child('users/trainees/$_userId/completedMeals')
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          _completedMeals = Map<String, Map<String, Map<String, int>>>.from(
            data.map((weekKey, weekData) => MapEntry(
              weekKey.toString(),
              Map<String, Map<String, int>>.from(
                (weekData as Map).map((dayKey, dayData) => MapEntry(
                  dayKey.toString(),
                  Map<String, int>.from(
                    (dayData as Map).map((mealKey, timestamp) => MapEntry(
                      mealKey.toString(),
                      timestamp as int,
                    )),
                  ),
                )),
              ),
            )),
          );
        });
      }
    } catch (e) {
      print('Error loading completed meals: $e');
    }
  }

  Future<void> _markMealAsCompleted(String week, String day, String meal) async {
    if (_userId == null) return;

    try {
      final weekKey = week.replaceAll(' ', '_');
      final dayKey = day.replaceAll(' ', '_');
      final mealKey = meal.replaceAll(' ', '_');

      // Update completed meals in Firebase
      await _database
          .child('users/trainees/$_userId/completedMeals/$weekKey/$dayKey')
          .update({
        mealKey: DateTime.now().millisecondsSinceEpoch,
      });

      // Reload completed meals
      await _loadCompletedMeals();
    } catch (e) {
      print('Error marking meal as completed: $e');
    }
  }

  bool _isMealCompleted(String week, String day, String meal) {
    final weekKey = week.replaceAll(' ', '_');
    final dayKey = day.replaceAll(' ', '_');
    final mealKey = meal.replaceAll(' ', '_');

    return _completedMeals[weekKey]?[dayKey]?.containsKey(mealKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Diet Plan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildMonthlyDietPlan(),
        ],
      ),
    );
  }

  Widget _buildMonthlyDietPlan() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: const Text(
          'Weight Loss Diet Plan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nutritional Goals Section
                _buildSectionTitle('Nutritional Goals'),
                _buildNutritionalGoals(),
                const SizedBox(height: 16),

                // Daily Calorie Target
                _buildSectionTitle('Daily Calorie Target'),
                _buildCalorieInfo(),
                const SizedBox(height: 16),

                // Macro Distribution
                _buildSectionTitle('Macro Distribution'),
                _buildMacroDistribution(),
                const SizedBox(height: 16),

                // Weekly Meal Plans
                _buildSectionTitle('Weekly Meal Plans'),
                _buildWeeklyMealPlan('Week 1', 'Focus: Protein-rich diet'),
                _buildWeeklyMealPlan('Week 2', 'Focus: Carb cycling'),
                _buildWeeklyMealPlan('Week 3', 'Focus: Healthy fats'),
                _buildWeeklyMealPlan('Week 4', 'Focus: Balanced nutrition'),
                const SizedBox(height: 16),

                // Dietary Guidelines
                _buildSectionTitle('Dietary Guidelines'),
                _buildDietaryGuidelines(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNutritionalGoals() {
    return Column(
      children: [
        _buildGoalItem('Target Weight', '65 kg', 0.7),
        const SizedBox(height: 8),
        _buildGoalItem('Body Fat', '20%', 0.5),
        const SizedBox(height: 8),
        _buildGoalItem('Muscle Mass', '45 kg', 0.6),
      ],
    );
  }

  Widget _buildGoalItem(String title, String target, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(target),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
        ),
      ],
    );
  }

  Widget _buildCalorieInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1800 kcal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Daily Target',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Deficit: 500 kcal',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'For weight loss',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroDistribution() {
    return Row(
      children: [
        _buildMacroItem('Protein', '30%', Colors.blue),
        const SizedBox(width: 8),
        _buildMacroItem('Carbs', '40%', Colors.green),
        const SizedBox(width: 8),
        _buildMacroItem('Fats', '30%', Colors.orange),
      ],
    );
  }

  Widget _buildMacroItem(String macro, String percentage, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              percentage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              macro,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyMealPlan(String week, String focus) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(week),
        subtitle: Text(focus),
        children: [
          _buildDailyMeal('Monday'),
          _buildDailyMeal('Tuesday'),
          _buildDailyMeal('Wednesday'),
          _buildDailyMeal('Thursday'),
          _buildDailyMeal('Friday'),
          _buildDailyMeal('Saturday'),
          _buildDailyMeal('Sunday'),
        ],
      ),
    );
  }

  Widget _buildDailyMeal(String day) {
    return ExpansionTile(
      title: Text(day),
      children: [
        _buildMealItem('Breakfast', '8:00 AM', 'Oatmeal with fruits and nuts', '350 kcal', 'Week 1', day),
        _buildMealItem('Snack', '10:30 AM', 'Greek yogurt with honey', '150 kcal', 'Week 1', day),
        _buildMealItem('Lunch', '1:00 PM', 'Grilled chicken salad', '450 kcal', 'Week 1', day),
        _buildMealItem('Snack', '4:00 PM', 'Apple and almonds', '200 kcal', 'Week 1', day),
        _buildMealItem('Dinner', '7:00 PM', 'Baked salmon with vegetables', '550 kcal', 'Week 1', day),
      ],
    );
  }

  Widget _buildMealItem(String meal, String time, String description, String calories, String week, String day) {
    final isCompleted = _isMealCompleted(week, day, meal);

    return ListTile(
      title: Text(meal),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time),
          Text(description),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            calories,
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          if (!isCompleted)
            ElevatedButton(
              onPressed: () => _markMealAsCompleted(week, day, meal),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Finish'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDietaryGuidelines() {
    return Column(
      children: [
        _buildGuidelineItem('Drink at least 8 glasses of water daily'),
        _buildGuidelineItem('Eat slowly and mindfully'),
        _buildGuidelineItem('Avoid processed foods and sugary drinks'),
        _buildGuidelineItem('Include protein in every meal'),
        _buildGuidelineItem('Eat plenty of vegetables and fruits'),
      ],
    );
  }

  Widget _buildGuidelineItem(String guideline) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(guideline)),
        ],
      ),
    );
  }
} 