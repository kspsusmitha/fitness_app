import 'package:flutter/material.dart';
import 'package:fitness_app/screens/workouts/pre_designed_workouts.dart';
import 'package:fitness_app/screens/workouts/custom_workouts.dart';
import 'package:fitness_app/screens/workouts/exercise_library.dart';
import 'package:fitness_app/screens/workouts/workout_tracker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Workouts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Pre-designed'),
                Tab(text: 'Custom'),
                Tab(text: 'Library'),
                Tab(text: 'Tracker'),
              ],
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: const [
                PreDesignedWorkouts(),
                CustomWorkouts(),
                ExerciseLibrary(),
                WorkoutTracker(),
              ],
            ),
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {
                    // Add new custom workout
                  },
                  backgroundColor: Colors.blue.shade600,
                  child: const Icon(Icons.add),
                )
              : null,
        ),
      ),
    );
  }
}

// Add Exercise class with video support
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

// Add ExerciseVideoPlayer widget
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

  @override
  void initState() {
    super.initState();
    String? videoId = widget.youtubeUrl;
    
    // Handle both full URLs and video IDs
    if (widget.youtubeUrl.contains('youtube.com') || widget.youtubeUrl.contains('youtu.be')) {
      videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    }
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
            if (_isPlayerReady) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                      _controller.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                    ),
                    onPressed: () {
                      if (_controller.value.volume == 0) {
                        _controller.unMute();
                      } else {
                        _controller.mute();
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

// Update PreDesignedWorkouts class
class PreDesignedWorkouts extends StatelessWidget {
  const PreDesignedWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWorkoutProgram(
          title: 'Beginner Full Body',
          description: 'Perfect for newcomers to fitness',
          duration: '4 weeks',
          exercises: [
            Exercise(
              name: 'Push-ups',
              youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
              description: 'Basic push-up form guide',
              duration: '3 sets x 10 reps',
            ),
            Exercise(
              name: 'Squats',
              youtubeUrl: 'https://www.youtube.com/watch?v=YaXPRqUwItQ',
              description: 'Proper squat technique',
              duration: '3 sets x 12 reps',
            ),
            Exercise(
              name: 'Plank',
              youtubeUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
              description: 'Core strengthening exercise',
              duration: '3 sets x 30 seconds',
            ),
          ],
          icon: Icons.fitness_center,
        ),
        _buildWorkoutProgram(
          title: 'Weight Loss Program',
          description: 'High-intensity workouts for fat burning',
          duration: '6 weeks',
          exercises: [
            Exercise(
              name: 'Burpees',
              youtubeUrl: 'https://www.youtube.com/watch?v=TU8QYVW0gDU',
              description: 'Full body high-intensity exercise',
              duration: '4 sets x 10 reps',
            ),
            Exercise(
              name: 'Mountain Climbers',
              youtubeUrl: 'https://www.youtube.com/watch?v=nmwgirgXLYM',
              description: 'Dynamic cardio movement',
              duration: '3 sets x 30 seconds',
            ),
            Exercise(
              name: 'Jumping Jacks',
              youtubeUrl: 'https://www.youtube.com/watch?v=c4DAnQ6DtF8',
              description: 'Classic cardio exercise',
              duration: '3 sets x 45 seconds',
            ),
          ],
          icon: Icons.local_fire_department,
        ),
        _buildWorkoutProgram(
          title: 'Core Strength',
          description: 'Build a stronger core and better stability',
          duration: '4 weeks',
          exercises: [
            Exercise(
              name: 'Crunches',
              youtubeUrl: 'https://www.youtube.com/watch?v=5ER5Of4MOPI',
              description: 'Basic ab exercise',
              duration: '3 sets x 15 reps',
            ),
            Exercise(
              name: 'Russian Twists',
              youtubeUrl: 'https://www.youtube.com/watch?v=wkD8rjkodUI',
              description: 'Rotational core exercise',
              duration: '3 sets x 20 reps',
            ),
            Exercise(
              name: 'Leg Raises',
              youtubeUrl: 'https://www.youtube.com/watch?v=l4kQd9eWclE',
              description: 'Lower ab focus',
              duration: '3 sets x 12 reps',
            ),
          ],
          icon: Icons.accessibility_new,
        ),
        _buildWorkoutProgram(
          title: 'Home Workout',
          description: 'No equipment needed',
          duration: '4 weeks',
          exercises: [
            Exercise(
              name: 'Lunges',
              youtubeUrl: 'https://www.youtube.com/watch?v=QOVaHwm-Q6U',
              description: 'Lower body strength',
              duration: '3 sets x 12 reps per leg',
            ),
            Exercise(
              name: 'Diamond Push-ups',
              youtubeUrl: 'https://www.youtube.com/watch?v=J0DnG1_S92I',
              description: 'Tricep focus push-up variation',
              duration: '3 sets x 8 reps',
            ),
            Exercise(
              name: 'Wall Sits',
              youtubeUrl: 'https://www.youtube.com/watch?v=y4Wo095zPnc',
              description: 'Lower body endurance',
              duration: '3 sets x 45 seconds',
            ),
          ],
          icon: Icons.home,
        ),
      ],
    );
  }

  Widget _buildWorkoutProgram({
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
        title: Text(title),
        subtitle: Text('$description\nDuration: $duration'),
        children: [
          ...exercises.map((exercise) => _buildExerciseCard(exercise)),
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

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
                Text(exercise.description),
                const SizedBox(height: 8),
                Text(
                  'Duration: ${exercise.duration}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ExerciseVideoPlayer(youtubeUrl: exercise.youtubeUrl),
          ),
        ],
      ),
    );
  }
}
