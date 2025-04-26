import 'package:flutter/material.dart';

class CustomWorkouts extends StatelessWidget {
  const CustomWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCustomWorkoutCard(
          'My Upper Body Workout',
          ['Bench Press', 'Pull-ups', 'Shoulder Press'],
          '45 mins',
        ),
        _buildCustomWorkoutCard(
          'Leg Day',
          ['Squats', 'Deadlifts', 'Lunges'],
          '60 mins',
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Create new custom workout
            },
            icon: const Icon(Icons.add),
            label: const Text('Create New Workout'),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomWorkoutCard(
      String title, List<String> exercises, String duration) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text('Duration: $duration'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
          const Divider(),
          ...exercises.map(
            (exercise) => ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(exercise),
            ),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                  // Edit workout
                },
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Start workout
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

