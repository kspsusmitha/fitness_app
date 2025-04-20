import 'package:flutter/material.dart';

class DietPlanTab extends StatefulWidget {
  const DietPlanTab({super.key});

  @override
  State<DietPlanTab> createState() => _DietPlanTabState();
}

class _DietPlanTabState extends State<DietPlanTab> {
  bool _isVegetarian = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Diet Type Toggle
              Center(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Vegetarian'),
                      icon: Icon(Icons.grass),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Non-Vegetarian'),
                      icon: Icon(Icons.restaurant),
                    ),
                  ],
                  selected: {_isVegetarian},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _isVegetarian = newSelection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Daily Meal Plans
              Text(
                '${_isVegetarian ? "Vegetarian" : "Non-Vegetarian"} Meal Plan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              _buildMealCard(
                'Breakfast',
                _isVegetarian
                    ? ['Oatmeal with fruits', 'Greek yogurt', 'Nuts and seeds']
                    : ['Eggs and toast', 'Chicken sausage', 'Fresh fruits'],
                '8:00 AM',
                Icons.breakfast_dining,
              ),
              
              _buildMealCard(
                'Morning Snack',
                _isVegetarian
                    ? ['Mixed fruit smoothie', 'Handful of almonds']
                    : ['Protein shake', 'Mixed nuts'],
                '11:00 AM',
                Icons.coffee,
              ),
              
              _buildMealCard(
                'Lunch',
                _isVegetarian
                    ? ['Quinoa bowl', 'Mixed vegetables', 'Lentil soup']
                    : ['Grilled chicken', 'Brown rice', 'Steamed vegetables'],
                '1:00 PM',
                Icons.lunch_dining,
              ),
              
              _buildMealCard(
                'Evening Snack',
                _isVegetarian
                    ? ['Hummus with carrots', 'Green tea']
                    : ['Tuna sandwich', 'Green tea'],
                '4:00 PM',
                Icons.restaurant,
              ),
              
              _buildMealCard(
                'Dinner',
                _isVegetarian
                    ? ['Stir-fried tofu', 'Brown rice', 'Steamed broccoli']
                    : ['Grilled fish', 'Quinoa', 'Roasted vegetables'],
                '7:00 PM',
                Icons.dinner_dining,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(String mealTime, List<String> items, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(mealTime),
        subtitle: Text(time),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 12),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
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
