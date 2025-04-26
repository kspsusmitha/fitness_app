import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          '$description\nDuration: $duration',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...exercises.map((exercise) => _buildExerciseCard(exercise)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Start program
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'START PROGRAM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  style: TextStyle(
                    color: Colors.blue.shade700,
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

// Exercise class
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

// ExerciseVideoPlayer widget
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

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressColors: const ProgressBarColors(
        playedColor: Colors.blue,
        bufferedColor: Colors.grey,
      ),
    );
  }
} 