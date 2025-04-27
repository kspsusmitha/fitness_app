import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class WorkoutPlansPage extends StatelessWidget {
  const WorkoutPlansPage({super.key});

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
          _buildExpandableWorkoutPlan(
            'Weight Loss Program',
            'Coach Michael',
            '8 weeks',
            0.3,
            ['Cardio', 'HIIT', 'Strength'],
            ['Monday', 'Wednesday', 'Friday'],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableWorkoutPlan(
    String title,
    String trainer,
    String duration,
    double progress,
    List<String> focus,
    List<String> schedule,
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
          trainer,
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

                // Focus Areas
                const Text(
                  'Focus Areas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: focus.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.orange.shade50,
                  )).toList(),
                ),
                const SizedBox(height: 16),

                // Workout Details Section
                const Text(
                  'Workout Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildWorkoutDay(
                  'Monday - Upper Body',
                  [
                    _buildExercise(
                      'Push-ups',
                      '3 sets x 12 reps',
                      'https://example.com/pushup.mp4',
                    ),
                    _buildExercise(
                      'Dumbbell Rows',
                      '3 sets x 10 reps',
                      'https://example.com/rows.mp4',
                    ),
                    _buildExercise(
                      'Shoulder Press',
                      '3 sets x 10 reps',
                      'https://example.com/press.mp4',
                    ),
                  ],
                ),
                _buildWorkoutDay(
                  'Wednesday - Lower Body',
                  [
                    _buildExercise(
                      'Squats',
                      '4 sets x 12 reps',
                      'https://example.com/squats.mp4',
                    ),
                    _buildExercise(
                      'Lunges',
                      '3 sets x 10 reps each leg',
                      'https://example.com/lunges.mp4',
                    ),
                    _buildExercise(
                      'Calf Raises',
                      '3 sets x 15 reps',
                      'https://example.com/calfraises.mp4',
                    ),
                  ],
                ),
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

  Widget _buildWorkoutDay(String title, List<Widget> exercises) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title),
        children: exercises,
      ),
    );
  }

  Widget _buildExercise(String name, String sets, String videoUrl) {
    return ListTile(
      title: Text(name),
      subtitle: Text(sets),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          // Show video in a dialog
          // _showVideoDialog(context, name, videoUrl);
        },
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