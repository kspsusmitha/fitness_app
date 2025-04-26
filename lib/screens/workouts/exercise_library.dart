import 'package:flutter/material.dart';

class ExerciseLibrary extends StatelessWidget {
  const ExerciseLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCategoryCard(
          'Strength Training',
          'Build muscle and increase strength',
          Icons.fitness_center,
          {
            'Chest': ['Bench Press', 'Push-ups', 'Dumbbell Flyes'],
            'Back': ['Pull-ups', 'Rows', 'Lat Pulldowns'],
            'Legs': ['Squats', 'Deadlifts', 'Lunges'],
            'Shoulders': ['Shoulder Press', 'Lateral Raises', 'Front Raises'],
          },
        ),
        _buildCategoryCard(
          'Cardio',
          'Improve heart health and endurance',
          Icons.directions_run,
          {
            'Indoor': ['Treadmill', 'Stationary Bike', 'Rowing'],
            'Outdoor': ['Running', 'Cycling', 'Swimming'],
            'HIIT': ['Burpees', 'Jump Rope', 'Mountain Climbers'],
          },
        ),
        _buildCategoryCard(
          'Flexibility',
          'Enhance mobility and reduce injury risk',
          Icons.self_improvement,
          {
            'Yoga': ['Sun Salutation', 'Warrior Pose', 'Downward Dog'],
            'Stretching': ['Dynamic Stretches', 'Static Stretches'],
            'Mobility': ['Joint Mobility', 'Foam Rolling'],
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String description, IconData icon,
      Map<String, List<String>> exercises) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        children: exercises.entries.map((category) {
          return ExpansionTile(
            title: Text(category.key),
            children: category.value.map((exercise) {
              return ListTile(
                title: Text(exercise),
                trailing: const Icon(Icons.info_outline),
                onTap: () {
                  // Show exercise details
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
