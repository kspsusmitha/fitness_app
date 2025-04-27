import 'package:flutter/material.dart';
import 'workout_plans_page.dart';
import 'diet_plan_page.dart';
import 'trainer_details_page.dart';
import 'status_page.dart';
import 'trainee_profile_page.dart';

class TraineeHomePage extends StatefulWidget {
  const TraineeHomePage({super.key});

  @override
  State<TraineeHomePage> createState() => _TraineeHomePageState();
}

class _TraineeHomePageState extends State<TraineeHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700.withOpacity(0.8),
        elevation: 0,
        title: const Text(
          'Fitness Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TraineeProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade300,
              Colors.orange.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              WorkoutPlansPage(),
              DietPlanPage(),
              TrainerDetailsPage(),
              StatusPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Diet Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Trainer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Status',
          ),
        ],
      ),
    );
  }
} 