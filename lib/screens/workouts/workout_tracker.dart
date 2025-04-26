
import 'package:flutter/material.dart';

class WorkoutTracker extends StatelessWidget {
  
  const WorkoutTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWeeklyProgress(),
        const SizedBox(height: 16),
        _buildRecentWorkouts(),
        const SizedBox(height: 16),
        _buildPersonalRecords(),
      ],
    );
  }

  Widget _buildWeeklyProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(value: 0.6),
            const SizedBox(height: 8),
            const Text('3 of 5 workouts completed'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Time', '180 min'),
                _buildStatItem('Calories', '850 kcal'),
                _buildStatItem('Workouts', '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRecentWorkouts() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildWorkoutHistoryItem(
            'Upper Body Workout',
            'Today',
            '45 min',
            '300 kcal',
          ),
          _buildWorkoutHistoryItem(
            'Leg Day',
            'Yesterday',
            '60 min',
            '400 kcal',
          ),
          _buildWorkoutHistoryItem(
            'Cardio Session',
            '2 days ago',
            '30 min',
            '250 kcal',
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistoryItem(
      String name, String date, String duration, String calories) {
    return ListTile(
      title: Text(name),
      subtitle: Text('$date • $duration • $calories'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Show workout details
      },
    );
  }

  Widget _buildPersonalRecords() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Personal Records',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildRecordItem('Bench Press', '80 kg'),
          _buildRecordItem('Squat', '100 kg'),
          _buildRecordItem('Deadlift', '120 kg'),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String exercise, String weight) {
    return ListTile(
      title: Text(exercise),
      trailing: Text(
        weight,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
} 