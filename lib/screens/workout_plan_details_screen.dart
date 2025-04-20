import 'package:flutter/material.dart';

class WorkoutPlanDetailsScreen extends StatelessWidget {
  final String planName;
  final String duration;
  final String frequency;

  const WorkoutPlanDetailsScreen({
    super.key,
    required this.planName,
    required this.duration,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Overview Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Duration', duration),
                    _buildInfoRow('Frequency', frequency),
                    _buildInfoRow('Difficulty', _getDifficulty()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Weekly Schedule
            const Text(
              'Weekly Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildWeeklySchedule(),
            const SizedBox(height: 24),

            // Equipment Needed
            const Text(
              'Equipment Needed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildEquipmentList(),
            const SizedBox(height: 24),

            // Expected Results
            const Text(
              'Expected Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildExpectedResults(),
            const SizedBox(height: 24),

            // Start Plan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle starting the plan
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Start Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficulty() {
    if (planName.toLowerCase().contains('beginner')) {
      return 'Beginner';
    } else if (planName.toLowerCase().contains('intermediate')) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }

  Widget _buildWeeklySchedule() {
    final schedule = [
      {'day': 'Monday', 'workout': 'Upper Body Strength'},
      {'day': 'Tuesday', 'workout': 'Cardio + Core'},
      {'day': 'Wednesday', 'workout': 'Lower Body Strength'},
      {'day': 'Thursday', 'workout': 'Rest'},
      {'day': 'Friday', 'workout': 'Full Body Circuit'},
      {'day': 'Saturday', 'workout': 'Flexibility + Mobility'},
      {'day': 'Sunday', 'workout': 'Rest'},
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: schedule.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final day = schedule[index];
          return ListTile(
            title: Text(day['day']!),
            trailing: Text(day['workout']!),
          );
        },
      ),
    );
  }

  Widget _buildEquipmentList() {
    final equipment = [
      'Dumbbells',
      'Resistance Bands',
      'Exercise Mat',
      'Jump Rope',
      'Foam Roller',
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: equipment.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(equipment[index]),
          );
        },
      ),
    );
  }

  Widget _buildExpectedResults() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Increased strength and endurance'),
            SizedBox(height: 8),
            Text('• Improved muscle definition'),
            SizedBox(height: 8),
            Text('• Better flexibility and mobility'),
            SizedBox(height: 8),
            Text('• Enhanced cardiovascular fitness'),
          ],
        ),
      ),
    );
  }
} 