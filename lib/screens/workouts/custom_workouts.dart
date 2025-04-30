import 'package:flutter/material.dart';
import 'dart:async';

class CustomWorkouts extends StatefulWidget {
  const CustomWorkouts({super.key});

  @override
  State<CustomWorkouts> createState() => _CustomWorkoutsState();
}

class _CustomWorkoutsState extends State<CustomWorkouts> {
  List<Workout> _workouts = [
    Workout(
      title: 'My Upper Body Workout',
      exercises: ['Bench Press', 'Pull-ups', 'Shoulder Press'],
      duration: '45 mins',
    ),
    Workout(
      title: 'Leg Day',
      exercises: ['Squats', 'Deadlifts', 'Lunges'],
      duration: '60 mins',
    ),
  ];

  void _editWorkout(int index) {
    showDialog(
      context: context,
      builder: (context) => WorkoutDialog(
        workout: _workouts[index],
        onSave: (updatedWorkout) {
          setState(() {
            _workouts[index] = updatedWorkout;
          });
        },
      ),
    );
  }

  void _startWorkout(Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSessionScreen(workout: workout),
      ),
    );
  }

  void _createWorkout() {
    showDialog(
      context: context,
      builder: (context) => WorkoutDialog(
        onSave: (newWorkout) {
          setState(() {
            _workouts.add(newWorkout);
          });
        },
      ),
    );
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._workouts.asMap().entries.map((entry) {
          final index = entry.key;
          final workout = entry.value;
          return _buildCustomWorkoutCard(workout, index);
        }),
        Center(
          child: TextButton.icon(
            onPressed: _createWorkout,
            icon: const Icon(Icons.add),
            label: const Text('Create New Workout'),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomWorkoutCard(Workout workout, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(workout.title),
            subtitle: Text('Duration: ${workout.duration}'),
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
              onSelected: (value) {
                if (value == 'edit') {
                  _editWorkout(index);
                } else if (value == 'delete') {
                  _deleteWorkout(index);
                }
              },
            ),
          ),
          const Divider(),
          ...workout.exercises.map(
            (exercise) => ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(exercise),
            ),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () => _editWorkout(index),
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () => _startWorkout(workout),
                child: const Text('Start'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Workout {
  final String title;
  final List<String> exercises;
  final String duration;

  Workout({
    required this.title,
    required this.exercises,
    required this.duration,
  });
}

class WorkoutDialog extends StatefulWidget {
  final Workout? workout;
  final Function(Workout) onSave;

  const WorkoutDialog({
    super.key,
    this.workout,
    required this.onSave,
  });

  @override
  State<WorkoutDialog> createState() => _WorkoutDialogState();
}

class _WorkoutDialogState extends State<WorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late List<TextEditingController> _exerciseControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.workout?.title ?? '');
    _durationController = TextEditingController(text: widget.workout?.duration ?? '');
    _exerciseControllers = widget.workout?.exercises
            .map((e) => TextEditingController(text: e))
            .toList() ??
        [TextEditingController()];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    for (var controller in _exerciseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addExerciseField() {
    setState(() {
      _exerciseControllers.add(TextEditingController());
    });
  }

  void _removeExerciseField(int index) {
    setState(() {
      _exerciseControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.workout == null ? 'Create Workout' : 'Edit Workout'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Workout Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (e.g., 45 mins)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Exercises:'),
              ..._exerciseControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Exercise ${index + 1}',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter exercise name';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeExerciseField(index),
                    ),
                  ],
                );
              }),
              TextButton.icon(
                onPressed: _addExerciseField,
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final workout = Workout(
                title: _titleController.text,
                exercises: _exerciseControllers
                    .map((controller) => controller.text)
                    .toList(),
                duration: _durationController.text,
              );
              widget.onSave(workout);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({super.key, required this.workout});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  bool _isWorkoutStarted = false;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _totalSets = 3; // Default number of sets
  int _restTime = 60; // Default rest time in seconds
  int _elapsedSeconds = 0;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _nextExercise() {
    setState(() {
      if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
        _currentExerciseIndex++;
        _currentSet = 1;
      } else {
        _isWorkoutStarted = false;
        _timer.cancel();
        _currentExerciseIndex = 0;
        _currentSet = 1;
      }
    });
  }

  void _nextSet() {
    setState(() {
      if (_currentSet < _totalSets) {
        _currentSet++;
      } else {
        _nextExercise();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isWorkoutStarted) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Current Exercise:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.workout.exercises[_currentExerciseIndex],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Set $_currentSet of $_totalSets',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Time: ${_formatTime(_elapsedSeconds)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _nextSet,
                  child: const Text('Next Set'),
                ),
                ElevatedButton(
                  onPressed: _nextExercise,
                  child: const Text('Next Exercise'),
                ),
              ],
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration: ${widget.workout.duration}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Exercises:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...widget.workout.exercises.map((exercise) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.fitness_center, size: 20),
                              const SizedBox(width: 8),
                              Text(exercise),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Workout Settings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Number of Sets:'),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _totalSets,
                          items: [1, 2, 3, 4, 5]
                              .map((sets) => DropdownMenuItem(
                                    value: sets,
                                    child: Text('$sets'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _totalSets = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Rest Time (seconds):'),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _restTime,
                          items: [30, 45, 60, 90, 120]
                              .map((seconds) => DropdownMenuItem(
                                    value: seconds,
                                    child: Text('$seconds'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _restTime = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isWorkoutStarted = true;
                  _startTimer();
                });
              },
              child: const Text('Start Workout'),
            ),
          ],
        ],
      ),
    );
  }
}

