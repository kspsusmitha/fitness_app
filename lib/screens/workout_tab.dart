import 'package:flutter/material.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Pre-designed'),
              Tab(text: 'Custom'),
              Tab(text: 'Library'),
              Tab(text: 'Tracker'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            PreDesignedWorkouts(),
            CustomWorkouts(),
            ExerciseLibrary(),
            WorkoutTracker(),
          ],
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {
                  // Add new custom workout
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

class PreDesignedWorkouts extends StatelessWidget {
  const PreDesignedWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWorkoutProgram(
          'Beginner Full Body',
          'Perfect for newcomers to fitness',
          '4 weeks',
          ['Full Body Workout A', 'Full Body Workout B', 'Recovery'],
          Icons.fitness_center,
        ),
        _buildWorkoutProgram(
          'Weight Loss Program',
          'High-intensity workouts for fat burning',
          '6 weeks',
          ['HIIT Cardio', 'Strength Training', 'Core Focus'],
          Icons.local_fire_department,
        ),
        _buildWorkoutProgram(
          'Muscle Builder',
          'Progressive overload for muscle gain',
          '8 weeks',
          ['Push Day', 'Pull Day', 'Leg Day'],
          Icons.sports_gymnastics,
        ),
        _buildWorkoutProgram(
          'Home Workout',
          'No equipment needed',
          '4 weeks',
          ['Bodyweight Strength', 'Cardio', 'Flexibility'],
          Icons.home,
        ),
      ],
    );
  }

  Widget _buildWorkoutProgram(String title, String description, String duration,
      List<String> workouts, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text('$description\nDuration: $duration'),
        children: [
          ...workouts.map((workout) => ListTile(
                title: Text(workout),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: () {
                  // Start workout
                },
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Start program
              },
              child: const Text('Start Program'),
            ),
          ),
        ],
      ),
    );
  }
}

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