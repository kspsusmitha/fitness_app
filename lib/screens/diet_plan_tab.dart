import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietPlanTab extends StatefulWidget {
  const DietPlanTab({super.key});

  @override
  State<DietPlanTab> createState() => _DietPlanTabState();
}

class _DietPlanTabState extends State<DietPlanTab> {
  bool _isVegetarian = true;
  int _selectedWeek = 1;
  int _selectedDay = 1;
  
  // Water tracking
  int _waterGlasses = 4;
  final int _waterGoal = 8;

  // Firebase
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _userId;
  Map<String, Map<String, Map<String, bool>>> _completedMeals = {};

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      
      if (email == null || email.isEmpty) {
        print('Error: Email not found in SharedPreferences');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: Please log in again'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      
      print('Retrieving user ID for email: $email');
      
      // First, check if the users/trainees node exists
      final usersSnapshot = await _database.child('users/members').get();
      if (!usersSnapshot.exists) {
        print('Error: No trainees found in database');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: No user data found'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Then query for the specific email
      final snapshot = await _database
          .child('users/members')
          .orderByChild('email')
          .equalTo(email)
          .get();

      print('Database query result: ${snapshot.value}');

      if (!snapshot.exists) {
        print('Error: User not found in database for email: $email');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: User profile not found. Please contact support.'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final userData = (snapshot.value as Map).entries.first;
      _userId = userData.key;
      print('User ID retrieved: $_userId');
      
      if (_userId == null) {
        print('Error: User ID is null');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: Invalid user ID'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Verify the user exists in the database
      final userSnapshot = await _database.child('users/members/$_userId').get();
      if (!userSnapshot.exists) {
        print('Error: User data not found for ID: $_userId');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: User data not found'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      print('User data found: ${userSnapshot.value}');
      await _loadCompletedMeals();
    } catch (e) {
      print('Error initializing user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Error: Failed to load user data. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _loadCompletedMeals() async {
    if (_userId == null) return;

    try {
      final snapshot = await _database
          .child('users/members/$_userId/completedMeals')
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          _completedMeals = Map<String, Map<String, Map<String, bool>>>.from(
            data.map((weekKey, weekData) => MapEntry(
              weekKey,
              Map<String, Map<String, bool>>.from(
                (weekData as Map).map((dayKey, dayData) => MapEntry(
                  dayKey,
                  Map<String, bool>.from(
                    (dayData as Map).map((mealKey, value) => MapEntry(
                      mealKey,
                      value is Map ? value['completed'] == true : value == true,
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

  Future<void> _markMealAsCompleted(String mealName) async {
    if (_userId == null) return;

    final weekKey = 'Week_$_selectedWeek';
    final dayKey = 'Day_$_selectedDay';
    final mealKey = mealName.replaceAll(' ', '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    try {
      // Update completed meals
      await _database
          .child('users/members/$_userId/completedMeals/$weekKey/$dayKey')
          .update({
        mealKey: {
          'completed': true,
          'timestamp': timestamp,
          'mealName': mealName,
          'calories': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['calories'],
          'time': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['time'],
        },
      });

      // Update progress
      final totalMeals = _getMealPlan(_selectedWeek, _selectedDay).length;
      final completedCount = _getCompletedMealsCount();
      final newProgress = (completedCount + 1) / totalMeals;

      await _database
          .child('users/members/$_userId/dietProgress/$weekKey/$dayKey')
          .update({
        'progress': newProgress,
        'completedMeals': completedCount + 1,
        'totalMeals': totalMeals,
        'lastUpdated': timestamp,
        'lastCompletedMeal': {
          'name': mealName,
          'time': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['time'],
          'timestamp': timestamp,
        },
      });

      // Update daily progress
      await _database
          .child('users/members/$_userId/dailyProgress/$weekKey/$dayKey')
          .update({
        'date': timestamp,
        'completedMeals': completedCount + 1,
        'totalMeals': totalMeals,
        'progress': newProgress,
        'lastCompletedMeal': {
          'name': mealName,
          'time': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['time'],
          'timestamp': timestamp,
        },
      });

      // Update meal history
      await _database
          .child('users/members/$_userId/mealHistory')
          .push()
          .set({
        'mealName': mealName,
        'week': _selectedWeek,
        'day': _selectedDay,
        'timestamp': timestamp,
        'calories': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['calories'],
        'time': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['time'],
        'items': _getMealPlan(_selectedWeek, _selectedDay)[mealName]!['items'],
      });

      // Show success message with animation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('$mealName marked as completed!'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // Show completion animation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 60,
                ),
              ),
            ),
          ),
        );

        // Dismiss the dialog after animation
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }

      // Reload completed meals
      await _loadCompletedMeals();
    } catch (e) {
      print('Error marking meal as completed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Error marking meal as completed: $e'),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  bool _isMealCompleted(String mealName) {
    final weekKey = 'Week_$_selectedWeek';
    final dayKey = 'Day_$_selectedDay';
    final mealKey = mealName.replaceAll(' ', '_');
    return _completedMeals[weekKey]?[dayKey]?[mealKey] ?? false;
  }

  int _getCompletedMealsCount() {
    final weekKey = 'Week_$_selectedWeek';
    final dayKey = 'Day_$_selectedDay';
    return _completedMeals[weekKey]?[dayKey]?.values.where((v) => v).length ?? 0;
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with nutrition summary
              _buildNutritionHeader(),
              
              // Diet Type Toggle
              _buildDietTypeToggle(),
              
              // Water Tracker
              _buildWaterTracker(),
              
              // Week and Day Selection
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
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
                    // Week Selection
                    Text(
                      'Select Week',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text('Week ${index + 1}'),
                              selected: _selectedWeek == index + 1,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedWeek = index + 1;
                                });
                              },
                              selectedColor: Colors.blue.shade100,
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: _selectedWeek == index + 1
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade700,
                                fontWeight: _selectedWeek == index + 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Day Selection
                    Text(
                      'Select Day',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          7,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                    [index],
                              ),
                              selected: _selectedDay == index + 1,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedDay = index + 1;
                                });
                              },
                              selectedColor: Colors.blue.shade100,
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: _selectedDay == index + 1
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade700,
                                fontWeight: _selectedDay == index + 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Meal Plan
              _buildMealPlan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
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
          const Text(
            'Daily Nutrition',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientCircle('Calories', '1,850', '2,200', Colors.amber),
              _buildNutrientCircle('Protein', '95g', '120g', Colors.red.shade300),
              _buildNutrientCircle('Carbs', '210g', '250g', Colors.green.shade300),
              _buildNutrientCircle('Fat', '65g', '73g', Colors.purple.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCircle(String label, String value, String goal, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: 0.75,
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'of $goal',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDietTypeToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Diet Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          Switch.adaptive(
            value: _isVegetarian,
            activeColor: Colors.green,
            activeTrackColor: Colors.green.withOpacity(0.5),
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.red.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                _isVegetarian = value;
              });
            },
          ),
          Text(
            _isVegetarian ? 'Vegetarian' : 'Non-Vegetarian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _isVegetarian ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTracker() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water Intake',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                '$_waterGlasses of $_waterGoal glasses',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            percent: _waterGlasses / _waterGoal,
            lineHeight: 20,
            animation: true,
            animationDuration: 1000,
            backgroundColor: Colors.blue.shade100,
            progressColor: Colors.blue.shade500,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _waterGlasses > 0
                    ? () {
                        setState(() {
                          _waterGlasses--;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.remove),
              ),
              Row(
                children: List.generate(
                  _waterGoal,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.water_drop,
                      color: index < _waterGlasses
                          ? Colors.blue.shade500
                          : Colors.grey.shade300,
                      size: 24,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _waterGlasses < _waterGoal
                    ? () {
                        setState(() {
                          _waterGlasses++;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green.shade700,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlan() {
    final mealPlan = _getMealPlan(_selectedWeek, _selectedDay);
    final totalMeals = mealPlan.length;
    final completedMeals = _getCompletedMealsCount();
    final progress = totalMeals > 0 ? completedMeals / totalMeals : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: Colors.blue.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Meal Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  percent: progress,
                  lineHeight: 8.0,
                  animation: true,
                  animationDuration: 1000,
                  backgroundColor: Colors.blue.shade100,
                  progressColor: Colors.blue.shade700,
                  barRadius: const Radius.circular(4),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedMeals of $totalMeals meals completed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    if (progress == 1.0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'All meals completed!',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ...mealPlan.entries.map((entry) {
            final mealName = entry.key;
            final mealData = entry.value;
            final isCompleted = _isMealCompleted(mealName);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: mealName == mealPlan.entries.last.key
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      )
                    : null,
                boxShadow: mealName == mealPlan.entries.last.key
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
                  child: Icon(
                    mealData['icon'] as IconData,
                    color: isCompleted ? Colors.green.shade700 : Colors.blue.shade800,
                  ),
                ),
                title: Text(
                  mealName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.green.shade700 : null,
                  ),
                ),
                subtitle: Text(
                  '${mealData['time']} • ${mealData['calories']}',
                  style: TextStyle(
                    color: isCompleted ? Colors.green.shade600 : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                trailing: isCompleted
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      )
                    : ElevatedButton(
                        onPressed: () => _markMealAsCompleted(mealName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: const Text('Finish'),
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...(mealData['items'] as List<String>).map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: isCompleted ? Colors.green.shade500 : Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isCompleted ? Colors.green.shade700 : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            _showNutritionalInfo(context, mealName);
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Nutritional Info'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade800,
                            side: BorderSide(color: Colors.blue.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showNutritionalInfo(BuildContext context, String mealName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$mealName Nutritional Info',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNutrientRow('Calories', '450 kcal'),
                  _buildNutrientRow('Protein', '25g'),
                  _buildNutrientRow('Carbohydrates', '55g'),
                  _buildNutrientRow('Fat', '15g'),
                  _buildNutrientRow('Fiber', '8g'),
                  _buildNutrientRow('Sugar', '12g'),
                  _buildNutrientRow('Sodium', '400mg'),
                  _buildNutrientRow('Potassium', '600mg'),
                  _buildNutrientRow('Vitamin A', '20% DV'),
                  _buildNutrientRow('Vitamin C', '35% DV'),
                  _buildNutrientRow('Calcium', '15% DV'),
                  _buildNutrientRow('Iron', '10% DV'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String nutrient, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, dynamic>> _getMealPlan(int week, int day) {
    if (_isVegetarian) {
      return {
        'Breakfast': {
          'items': _getBreakfastItems(week, day),
          'time': '7:30 AM',
          'icon': Icons.breakfast_dining,
          'calories': '450 kcal',
        },
        'Morning Snack': {
          'items': _getMorningSnackItems(week, day),
          'time': '10:00 AM',
          'icon': Icons.apple,
          'calories': '150 kcal',
        },
        'Lunch': {
          'items': _getLunchItems(week, day),
          'time': '12:30 PM',
          'icon': Icons.lunch_dining,
          'calories': '550 kcal',
        },
        'Evening Snack': {
          'items': _getEveningSnackItems(week, day),
          'time': '4:00 PM',
          'icon': Icons.restaurant,
          'calories': '200 kcal',
        },
        'Dinner': {
          'items': _getDinnerItems(week, day),
          'time': '7:00 PM',
          'icon': Icons.dinner_dining,
          'calories': '500 kcal',
        },
      };
    } else {
      return {
        'Breakfast': {
          'items': _getNonVegBreakfastItems(week, day),
          'time': '7:30 AM',
          'icon': Icons.breakfast_dining,
          'calories': '500 kcal',
        },
        'Morning Snack': {
          'items': _getMorningSnackItems(week, day),
          'time': '10:00 AM',
          'icon': Icons.apple,
          'calories': '150 kcal',
        },
        'Lunch': {
          'items': _getNonVegLunchItems(week, day),
          'time': '12:30 PM',
          'icon': Icons.lunch_dining,
          'calories': '650 kcal',
        },
        'Evening Snack': {
          'items': _getEveningSnackItems(week, day),
          'time': '4:00 PM',
          'icon': Icons.restaurant,
          'calories': '200 kcal',
        },
        'Dinner': {
          'items': _getNonVegDinnerItems(week, day),
          'time': '7:00 PM',
          'icon': Icons.dinner_dining,
          'calories': '600 kcal',
        },
      };
    }
  }

  List<String> _getBreakfastItems(int week, int day) {
    // Define different breakfast options for each day
    final breakfasts = [
      ['Oatmeal with banana and honey', 'Greek yogurt', 'Almonds'],
      ['Whole grain toast with avocado', 'Scrambled tofu', 'Fresh berries'],
      ['Quinoa porridge with fruits', 'Soy milk', 'Mixed seeds'],
      ['Smoothie bowl with granola', 'Chia seeds', 'Coconut flakes'],
      ['Pancakes with maple syrup', 'Fresh fruit salad', 'Green tea'],
      ['Vegetable upma', 'Coconut chutney', 'Mixed fruits'],
      ['Whole grain cereal', 'Almond milk', 'Sliced banana'],
    ];
    return breakfasts[(day - 1) % breakfasts.length];
  }

  // Add similar methods for other meal times and non-vegetarian options
  List<String> _getMorningSnackItems(int week, int day) {
    final snacks = [
      ['Mixed fruit smoothie', 'Handful of almonds'],
      ['Apple slices with peanut butter', 'Green tea'],
      ['Carrot and cucumber sticks with hummus'],
      ['Trail mix with dried fruits and nuts'],
      ['Banana with almond butter'],
      ['Mixed berries with yogurt'],
      ['Roasted chickpeas', 'Fresh orange'],
    ];
    return snacks[(day - 1) % snacks.length];
  }
  
  List<String> _getLunchItems(int week, int day) {
    final lunches = [
      ['Quinoa salad with roasted vegetables', 'Lentil soup', 'Whole grain bread'],
      ['Vegetable wrap with hummus', 'Mixed greens salad', 'Fresh fruit'],
      ['Buddha bowl with tofu and vegetables', 'Tahini dressing', 'Brown rice'],
      ['Spinach and feta stuffed peppers', 'Greek salad', 'Tzatziki'],
      ['Vegetable stir-fry with tofu', 'Brown rice', 'Steamed broccoli'],
      ['Mediterranean couscous salad', 'Falafel', 'Cucumber yogurt dip'],
      ['Vegetable curry', 'Brown rice', 'Cucumber raita'],
    ];
    return lunches[(day - 1) % lunches.length];
  }
  
  List<String> _getEveningSnackItems(int week, int day) {
    final snacks = [
      ['Greek yogurt with honey', 'Mixed nuts'],
      ['Protein shake', 'Apple'],
      ['Cottage cheese with berries'],
      ['Edamame', 'Green tea'],
      ['Rice cakes with avocado'],
      ['Vegetable smoothie', 'Handful of walnuts'],
      ['Baked sweet potato wedges', 'Guacamole'],
    ];
    return snacks[(day - 1) % snacks.length];
  }
  
  List<String> _getDinnerItems(int week, int day) {
    final dinners = [
      ['Vegetable lasagna', 'Mixed green salad', 'Garlic bread'],
      ['Stuffed bell peppers with quinoa', 'Steamed vegetables', 'Tomato sauce'],
      ['Vegetable and chickpea curry', 'Brown rice', 'Naan bread'],
      ['Eggplant parmesan', 'Whole wheat pasta', 'Roasted vegetables'],
      ['Black bean burgers', 'Sweet potato fries', 'Avocado slaw'],
      ['Mushroom risotto', 'Grilled asparagus', 'Mixed salad'],
      ['Vegetable stir-fry with tofu', 'Brown rice noodles', 'Steamed bok choy'],
    ];
    return dinners[(day - 1) % dinners.length];
  }
  
  List<String> _getNonVegBreakfastItems(int week, int day) {
    final breakfasts = [
      ['Scrambled eggs with spinach', 'Whole grain toast', 'Avocado'],
      ['Greek yogurt with granola', 'Boiled eggs', 'Fresh berries'],
      ['Protein pancakes', 'Turkey bacon', 'Fresh fruit'],
      ['Egg white omelette with vegetables', 'Whole grain toast', 'Sliced avocado'],
      ['Breakfast burrito with eggs and chicken', 'Salsa', 'Fresh fruit'],
      ['Smoked salmon on whole grain bagel', 'Cream cheese', 'Capers'],
      ['Protein smoothie with whey', 'Boiled eggs', 'Almonds'],
    ];
    return breakfasts[(day - 1) % breakfasts.length];
  }
  
  List<String> _getNonVegLunchItems(int week, int day) {
    final lunches = [
      ['Grilled chicken salad', 'Quinoa', 'Olive oil dressing'],
      ['Turkey and avocado wrap', 'Mixed greens', 'Fresh fruit'],
      ['Tuna salad with mixed greens', 'Whole grain crackers', 'Cherry tomatoes'],
      ['Chicken stir-fry with vegetables', 'Brown rice', 'Steamed broccoli'],
      ['Salmon with roasted vegetables', 'Sweet potato', 'Lemon dill sauce'],
      ['Lean beef stir-fry', 'Brown rice', 'Steamed vegetables'],
      ['Chicken and vegetable soup', 'Whole grain bread', 'Mixed green salad'],
    ];
    return lunches[(day - 1) % lunches.length];
  }
  
  List<String> _getNonVegDinnerItems(int week, int day) {
    final dinners = [
      ['Grilled salmon', 'Quinoa', 'Roasted vegetables'],
      ['Baked chicken breast', 'Sweet potato', 'Steamed broccoli'],
      ['Turkey meatballs', 'Whole wheat pasta', 'Tomato sauce'],
      ['Shrimp stir-fry', 'Brown rice', 'Mixed vegetables'],
      ['Lean beef steak', 'Baked potato', 'Grilled asparagus'],
      ['Baked cod with herbs', 'Wild rice', 'Roasted vegetables'],
      ['Chicken curry', 'Brown rice', 'Cucumber raita'],
    ];
    return dinners[(day - 1) % dinners.length];
  }
}
