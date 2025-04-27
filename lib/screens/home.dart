import 'package:fitness_app/screens/more_tips_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/step_counter_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // User data
  int _stepCount = 0;
  final int _stepGoal = 10000;
  final int _caloriesBurned = 450;
  final int _calorieGoal = 800;
  final int _waterGlasses = 4;
  final int _waterGoal = 8;
  int _proteinIntake = 85;
  int _proteinGoal = 120;
  double _userWeight = 70.0; // Default weight

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStepCount();
    // Listen for step count updates
    StepCounterService.instance.addStepCountListener((steps) {
      if (mounted) {
        setState(() {
          _stepCount = steps;
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up listeners when the widget is disposed
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final weight = prefs.getDouble('user_weight') ?? 70.0;
    
    setState(() {
      _userWeight = weight;
      // Calculate protein goal based on weight (1.6g per kg of body weight)
      _proteinGoal = (_userWeight * 1.6).round();
      
      // For demo purposes, set protein intake to 70% of goal
      _proteinIntake = (_proteinGoal * 0.7).round();
    });
  }

  Future<void> _loadStepCount() async {
    final steps = await StepCounterService.instance.getStepCount();
    if (mounted) {
      setState(() {
        _stepCount = steps;
      });
    }
  }

  void _showProteinDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Protein Intake'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current: $_proteinIntake g'),
            Text('Goal: $_proteinGoal g'),
            const SizedBox(height: 8),
            Text(
              'Calculation: ${_userWeight.toStringAsFixed(1)} kg × 1.6 g/kg = ${(_userWeight * 1.6).round()} g',
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              'Protein sources today:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildProteinSource('Chicken Breast', '30g'),
            _buildProteinSource('Protein Shake', '25g'),
            _buildProteinSource('Greek Yogurt', '15g'),
            _buildProteinSource('Eggs', '15g'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStepCountDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Step Count'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: (_stepCount / _stepGoal).clamp(0.0, 1.0),
              center: Text(
                '$_stepCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              progressColor: Colors.blue,
              backgroundColor: Colors.blue.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 16),
            Text(
              'Goal: $_stepGoal steps',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daily Step History:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildStepHistoryItem('Yesterday', '8,432'),
            _buildStepHistoryItem('2 days ago', '9,123'),
            _buildStepHistoryItem('3 days ago', '7,654'),
            _buildStepHistoryItem('4 days ago', '10,234'),
            _buildStepHistoryItem('5 days ago', '8,765'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHistoryItem(String day, String steps) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(
            steps,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProteinSource(String food, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(food),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section with user info
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              
              // Today's activity
              _buildTodayActivity(),
              const SizedBox(height: 24),
              
              // Nutrition tracking
              _buildNutritionTracking(),
              const SizedBox(height: 24),
              
              // Nutrition tips
              _buildNutritionTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.person,
                  size: 36,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning,',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.blue.shade700,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your fitness journey is 45% complete',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            percent: 0.45,
            lineHeight: 10,
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.blue.shade600,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Workouts', '12', Icons.fitness_center),
              _buildStatItem('Calories', '8,540', Icons.local_fire_department),
              _buildStatItem('Minutes', '360', Icons.timer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade700,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Today's Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showStepCountDetails(),
                  child: _buildActivityCard(
                    'Steps',
                    _stepCount.toString(),
                    _stepGoal.toString(),
                    Icons.directions_walk,
                    Colors.blue,
                    _stepCount / _stepGoal,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActivityCard(
                  'Calories',
                  _caloriesBurned.toString(),
                  _calorieGoal.toString(),
                  Icons.local_fire_department,
                  Colors.orange,
                  _caloriesBurned / _calorieGoal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActivityCard(
                  'Water',
                  _waterGlasses.toString(),
                  _waterGoal.toString(),
                  Icons.water_drop,
                  Colors.cyan,
                  _waterGlasses / _waterGoal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String value,
    String goal,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            percent: progress.clamp(0.0, 1.0),
            lineHeight: 6,
            backgroundColor: Colors.grey.shade200,
            progressColor: color,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 4),
          Text(
            'Goal: $goal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTracking() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Row(
            children: [
              Icon(Icons.restaurant, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "Today's Nutrition",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showProteinDetails(),
                  child: _buildNutrientCard(
                    'Protein',
                    '$_proteinIntake g',
                    '$_proteinGoal g',
                    Colors.purple,
                    _proteinIntake / _proteinGoal,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNutrientCard(
                  'Carbs',
                  '180 g',
                  '250 g',
                  Colors.orange,
                  0.72,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNutrientCard(
                  'Fat',
                  '45 g',
                  '65 g',
                  Colors.blue,
                  0.69,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
    String title,
    String value,
    String goal,
    Color color,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 8,
            percent: progress.clamp(0.0, 1.0),
            center: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Goal: $goal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Nutrition Tips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            'Protein Intake',
            'Aim for 1.6g of protein per kg of body weight to support muscle recovery and growth.',
            Icons.egg_alt,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            'Stay Hydrated',
            'Drink at least 8 glasses of water daily to maintain optimal performance and recovery.',
            Icons.water_drop,
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoreTipsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              label: const Text(
                'More Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
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

class Exercise {
  final String name;
  final String youtubeUrl;
  final String description;
  final String duration;

  Exercise({
    required this.name,
    required this.youtubeUrl,
    required this.description,
    required this.duration,
  });
}

class ExerciseVideoPlayer extends StatefulWidget {
  final String youtubeUrl;

  const ExerciseVideoPlayer({
    super.key,
    required this.youtubeUrl,
  });

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {
    try {
      _controller = YoutubePlayerController(
        initialVideoId: widget.youtubeUrl,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );

      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      });
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          setState(() {
            _isPlayerReady = true;
          });
        },
        onEnded: (data) {
          _controller.pause();
        },
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                      if (_isMuted) {
                        _controller.mute();
                      } else {
                        _controller.unMute();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          context,
          title: 'Beginner Full Body',
          description: 'Perfect for newcomers to fitness',
          duration: '4 weeks',
          exercises: [
            Exercise(
              name: 'Push-ups',
              youtubeUrl: 'IODxDxX7oi4',
              description: 'Basic push-up form guide',
              duration: '3 sets x 10 reps',
            ),
            Exercise(
              name: 'Squats',
              youtubeUrl: 'YaXPRqUwItQ',
              description: 'Proper squat technique',
              duration: '3 sets x 12 reps',
            ),
            Exercise(
              name: 'Plank',
              youtubeUrl: 'ASdvN_XEl_c',
              description: 'Core strengthening exercise',
              duration: '3 sets x 30 seconds',
            ),
          ],
          icon: Icons.fitness_center,
        ),
        // ... other workout programs
      ],
    );
  }

  Widget _buildWorkoutProgram(
    BuildContext context,
    {
    required String title,
    required String description,
    required String duration,
    required List<Exercise> exercises,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$description\nDuration: $duration',
          style: const TextStyle(fontSize: 14),
        ),
        children: [
          ...exercises.map((exercise) => _buildExerciseCard(exercise)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to workout detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailPage(
                      title: title,
                      description: description,
                      duration: duration,
                      exercises: exercises,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Start Program'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${exercise.duration}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this new class for the workout detail page
class WorkoutDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final List<Exercise> exercises;

  const WorkoutDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Duration: $duration',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Program Overview:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• ${exercises.length} exercises\n'
                        '• Recommended: 3-4 sessions per week\n'
                        '• Rest 1-2 minutes between sets\n'
                        '• Warm up before starting\n'
                        '• Cool down after completion',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Exercises
              const Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Exercise list with videos
              ...exercises.map((exercise) => _buildDetailedExerciseCard(exercise)),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Start workout tracking
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Workout started! Let\'s go!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'START WORKOUT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${exercise.duration}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Video Demonstration:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: ExerciseVideoPlayer(youtubeUrl: exercise.youtubeUrl),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Maintain proper form throughout\n'
              '• Focus on controlled movements\n'
              '• Breathe properly during exercise\n'
              '• Rest as needed between sets',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Make sure these classes are defined
class WorkoutDay {
  final String name;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.name,
    required this.exercises,
  });
}


