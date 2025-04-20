import 'package:flutter/material.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final String exerciseName;
  final String category;

  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Image/Video Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),

            // Instructions Section
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInstructionStep(1, 'Start with proper form and positioning'),
            _buildInstructionStep(2, 'Maintain controlled movement throughout'),
            _buildInstructionStep(3, 'Focus on muscle engagement'),
            _buildInstructionStep(4, 'Complete recommended sets and reps'),

            const SizedBox(height: 24),

            // Target Muscles
            const Text(
              'Target Muscles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getTargetMuscles(),
            ),

            const SizedBox(height: 24),

            // Sets and Reps
            const Text(
              'Recommended Sets & Reps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSetRow('Beginner', '3 sets of 10 reps'),
                    const Divider(),
                    _buildSetRow('Intermediate', '4 sets of 12 reps'),
                    const Divider(),
                    _buildSetRow('Advanced', '5 sets of 15 reps'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tips Section
            const Text(
              'Pro Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              'Breathing',
              'Exhale during exertion, inhale during the easier phase',
              Icons.air,
            ),
            _buildTipCard(
              'Form',
              'Keep your core engaged throughout the movement',
              Icons.sports_gymnastics,
            ),
            _buildTipCard(
              'Rest',
              'Take 60-90 seconds rest between sets',
              Icons.timer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTargetMuscles() {
    final muscles = _getMusclesForExercise();
    return muscles.map((muscle) {
      return Chip(
        label: Text(muscle),
        backgroundColor: Colors.blue.withOpacity(0.1),
      );
    }).toList();
  }

  List<String> _getMusclesForExercise() {
    // This could be fetched from a database in a real app
    switch (category) {
      case 'Strength Training':
        return ['Chest', 'Shoulders', 'Triceps'];
      case 'Cardio':
        return ['Heart', 'Legs', 'Core'];
      case 'Flexibility':
        return ['Lower Back', 'Hamstrings', 'Hip Flexors'];
      default:
        return ['Full Body'];
    }
  }

  Widget _buildSetRow(String level, String prescription) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            level,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(prescription),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String tip, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(tip),
      ),
    );
  }
} 