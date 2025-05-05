import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WorkoutPlansPage extends StatefulWidget {
  const WorkoutPlansPage({super.key});

  @override
  State<WorkoutPlansPage> createState() => _WorkoutPlansPageState();
}

class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _workoutPlans = [];
  bool _isLoading = true;
  String? _traineeId;
  StreamSubscription? _workoutPlansSubscription;
  Map<String, Map<String, bool>> _completedExercises = {};

  @override
  void initState() {
    super.initState();
    _initializeTraineeData();
  }

  Future<void> _initializeTraineeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      
      final traineeSnapshot = await _database
          .child('users/trainees')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (traineeSnapshot.exists) {
        final traineeData = (traineeSnapshot.value as Map).entries.first;
        _traineeId = traineeData.key;
        _setupWorkoutPlansListener();
        _loadCompletedExercises();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error initializing trainee data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCompletedExercises() async {
    if (_traineeId == null) return;

    try {
      final snapshot = await _database
          .child('users/trainees/$_traineeId/completedExercises')
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          _completedExercises = Map<String, Map<String, bool>>.from(
            data.map((workoutKey, workoutData) => MapEntry(
              workoutKey,
              Map<String, bool>.from(
                (workoutData as Map).map((exerciseKey, value) => MapEntry(
                  exerciseKey,
                  value == true,
                )),
              ),
            )),
          );
        });
      }
    } catch (e) {
      print('Error loading completed exercises: $e');
    }
  }

  Future<void> _markExerciseAsCompleted(String workoutKey, String exercise) async {
    if (_traineeId == null) return;

    try {
      // Update completed exercises
      await _database
          .child('users/trainees/$_traineeId/completedExercises/$workoutKey')
          .update({
        exercise: true,
      });

      // Update workout progress
      final workout = _workoutPlans.firstWhere((plan) => plan['key'] == workoutKey);
      final totalExercises = (workout['exercises'] as List).length;
      final completedCount = _completedExercises[workoutKey]?.values.where((v) => v).length ?? 0;
      final newProgress = (completedCount + 1) / totalExercises;

      await _database
          .child('users/trainees/$_traineeId/workoutPlans/$workoutKey')
          .update({
        'progress': newProgress,
        'completedSessions': completedCount + 1,
      });

      // Reload data
      await _loadCompletedExercises();
    } catch (e) {
      print('Error marking exercise as completed: $e');
    }
  }

  Future<void> _setupWorkoutPlansListener() async {
    // Cancel existing subscription if any
    _workoutPlansSubscription?.cancel();

    setState(() => _isLoading = true);

    // Listen to workout plans node
    _workoutPlansSubscription = _database
        .child('users/trainees/$_traineeId/workoutPlans')
        .onValue
        .listen((DatabaseEvent event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        setState(() {
          _workoutPlans = [];
          _isLoading = false;
        });
        return;
      }

      try {
        final workoutPlansData = event.snapshot.value as Map;
        final List<Map<String, dynamic>> loadedPlans = [];

        workoutPlansData.forEach((key, value) {
          if (value is Map) {
            final planMap = Map<String, dynamic>.from(value);
            loadedPlans.add({
              'key': key,
              'name': planMap['name'] ?? 'Unnamed Workout',
              'description': planMap['description'] ?? '',
              'duration': planMap['duration'] ?? 0,
              'exercises': planMap['exercises'] ?? [],
              'progress': planMap['progress'] ?? 0.0,
              'completedSessions': planMap['completedSessions'] ?? 0,
              'totalSessions': planMap['totalSessions'] ?? 0,
              'assignedAt': planMap['assignedAt'],
              'status': planMap['status'] ?? 'active',
            });
          }
        });

        setState(() {
          _workoutPlans = loadedPlans;
          _isLoading = false;
        });
      } catch (e) {
        print('Error processing workout plans data: $e');
        setState(() {
          _workoutPlans = [];
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Error in workout plans stream: $error');
      setState(() {
        _workoutPlans = [];
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _workoutPlansSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Workout Plans',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_workoutPlans.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No workout plans assigned yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your trainer will assign workouts soon',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._workoutPlans.map((plan) => _buildExpandableWorkoutPlan(
                  plan['name'],
                  plan['description'],
                  '${plan['duration']} weeks',
                  plan['progress'],
                  plan['exercises'] ?? [],
                  _getScheduleFromPlan(plan),
                  plan['key'],
                )),
        ],
      ),
    );
  }

  List<String> _getScheduleFromPlan(Map<String, dynamic> plan) {
    // This is a placeholder. You should implement the actual schedule logic
    // based on your workout plan structure
    return ['Monday', 'Wednesday', 'Friday'];
  }

  Widget _buildExercise(String name, String sets, String workoutKey) {
    final isCompleted = _completedExercises[workoutKey]?[name] ?? false;

    return ListTile(
      title: Text(name),
      subtitle: Text(sets),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCompleted)
            ElevatedButton(
              onPressed: () => _markExerciseAsCompleted(workoutKey, name),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Finish'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableWorkoutPlan(
    String title,
    String description,
    String duration,
    double progress,
    List<dynamic> exercises,
    List<String> schedule,
    String workoutKey,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Section
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
                ),
                Text(
                  '${(progress * 100).round()}% Complete',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Schedule Section
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Training days: ${schedule.join(", ")}'),
                const SizedBox(height: 16),

                // Exercises Section
                const Text(
                  'Exercises',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...exercises.map((exercise) => _buildExercise(
                      exercise.toString(),
                      '3 sets x 12 reps',
                      workoutKey,
                    )),
                const SizedBox(height: 16),

                // Instructions Section
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInstructionItem('Warm up properly before each session'),
                _buildInstructionItem('Rest 60-90 seconds between sets'),
                _buildInstructionItem('Stay hydrated during workouts'),
                _buildInstructionItem('Focus on proper form over weight/reps'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(instruction)),
        ],
      ),
    );
  }
}

// Add this class for video playback
class WorkoutVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const WorkoutVideoPlayer({super.key, required this.videoUrl});

  @override
  State<WorkoutVideoPlayer> createState() => _WorkoutVideoPlayerState();
}

class _WorkoutVideoPlayerState extends State<WorkoutVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator());
  }
} 