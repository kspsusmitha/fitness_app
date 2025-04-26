import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseName;
  final String category;

  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseName,
    required this.category,
  });

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // This would be replaced with actual video URL in production
    _videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      aspectRatio: 16 / 9,
      placeholder: Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        bufferedColor: Colors.blue.shade100,
      ),
    );
    
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.exerciseName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {
                        // Add to favorites
                      },
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise Video
                        Container(
                          height: 220,
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _isVideoInitialized
                                ? Chewie(controller: _chewieController!)
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Category Chip
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Chip(
                            label: Text(
                              widget.category,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.blue.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        
                        // Instructions Section
                        _buildSection(
                          'Instructions',
                          Column(
                            children: [
                              _buildInstructionStep(1, 'Start with proper form and positioning'),
                              _buildInstructionStep(2, 'Maintain controlled movement throughout'),
                              _buildInstructionStep(3, 'Focus on muscle engagement'),
                              _buildInstructionStep(4, 'Complete recommended sets and reps'),
                            ],
                          ),
                        ),
                        
                        // Target Muscles
                        _buildSection(
                          'Target Muscles',
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _getTargetMuscles(),
                          ),
                        ),
                        
                        // Sets and Reps
                        _buildSection(
                          'Recommended Sets & Reps',
                          Card(
                            elevation: 0,
                            color: Colors.grey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
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
                        ),
                        
                        // Tips Section
                        _buildSection(
                          'Pro Tips',
                          Column(
                            children: [
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
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(fontSize: 16, height: 1.5),
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
        backgroundColor: Colors.blue.shade50,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    }).toList();
  }

  List<String> _getMusclesForExercise() {
    // This could be fetched from a database in a real app
    switch (widget.category) {
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            level,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              prescription,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String tip, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    tip,
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
      ),
    );
  }
} 