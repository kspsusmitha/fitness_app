import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedWorkoutPlan;
  bool _isLoading = true;
  List<Map<String, dynamic>> _trainees = [];
  String? _trainerId;
  StreamSubscription? _traineesSubscription;

  @override
  void initState() {
    super.initState();
    _initializeTrainerData();
  }

  Future<void> _initializeTrainerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      
      // Get trainer data
      final trainerSnapshot = await _database
          .child('users/trainers')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (trainerSnapshot.exists) {
        final trainerData = (trainerSnapshot.value as Map).entries.first;
        _trainerId = trainerData.key;
        _setupTraineesListener();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error initializing trainer data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setupTraineesListener() async {
    // Cancel existing subscription if any
    _traineesSubscription?.cancel();

    setState(() => _isLoading = true);

    // Listen to trainees node
    _traineesSubscription = _database
        .child('users/trainees')
        .onValue
        .listen((DatabaseEvent event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        setState(() {
          _trainees = [];
          _isLoading = false;
        });
        return;
      }

      try {
        final traineesData = event.snapshot.value as Map;
        final List<Map<String, dynamic>> loadedTrainees = [];

        traineesData.forEach((key, value) {
          if (value is Map && value['trainerId'] == _trainerId) {
            final traineeMap = Map<String, dynamic>.from(value);
            
            // Calculate progress
            double progress = 0.0;
            if (traineeMap['progress'] is Map && 
                traineeMap['progress']['workouts'] is Map) {
              final workouts = traineeMap['progress']['workouts'];
              final completed = workouts['completed'] ?? 0;
              final total = workouts['total'] ?? 0;
              progress = total > 0 ? completed / total : 0.0;
            }

            // Format last session date
            String lastSession = 'Never';
            if (traineeMap['lastSession'] != null) {
              try {
                final timestamp = traineeMap['lastSession'] as int;
                final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                final now = DateTime.now();
                final difference = now.difference(date);

                if (difference.inDays == 0) {
                  lastSession = 'Today';
                } else if (difference.inDays == 1) {
                  lastSession = 'Yesterday';
                } else if (difference.inDays < 7) {
                  lastSession = '${difference.inDays} days ago';
                } else {
                  lastSession = '${difference.inDays ~/ 7} weeks ago';
                }
              } catch (e) {
                print('Error formatting last session: $e');
              }
            }

            loadedTrainees.add({
              'key': key,
              'name': traineeMap['name'] ?? 'No Name',
              'email': traineeMap['email'] ?? 'No Email',
              'goal': traineeMap['progress']?['goals']?['primary'] ?? 'No Goal Set',
              'progress': progress,
              'lastSession': lastSession,
              'assignedWorkout': traineeMap['workoutPlans'] is Map && 
                               traineeMap['workoutPlans'].isNotEmpty ? 
                               traineeMap['workoutPlans'].keys.first : null,
              'gender': traineeMap['gender'] ?? 'Not specified',
              'phone': traineeMap['phone'] ?? 'Not provided',
              'weight': traineeMap['progress']?['weight']?['current'],
              'height': traineeMap['height'],
              'age': traineeMap['age'],
            });
          }
        });

        setState(() {
          _trainees = loadedTrainees;
          _isLoading = false;
        });
      } catch (e) {
        print('Error processing trainees data: $e');
        setState(() {
          _trainees = [];
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Error in trainees stream: $error');
      setState(() {
        _trainees = [];
        _isLoading = false;
      });
    });
  }

  void _filterTrainees(String query) {
    if (query.isEmpty) {
      _setupTraineesListener();
      return;
    }

    setState(() {
      _trainees = _trainees.where((trainee) {
        final name = trainee['name'].toString().toLowerCase();
        final email = trainee['email'].toString().toLowerCase();
        final goal = trainee['goal'].toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) || 
               email.contains(searchLower) || 
               goal.contains(searchLower);
      }).toList();
    });
  }

  void _showAddClientDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<Map<String, dynamic>> searchResults = [];
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Existing Trainee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Email',
                    hintText: 'Enter trainee email',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      setState(() {
                        searchResults = [];
                        isSearching = false;
                      });
                      return;
                    }

                    setState(() => isSearching = true);

                    try {
                      // Search for trainees without a trainer
                      final snapshot = await _database
                          .child('users/trainees')
                          .orderByChild('email')
                          .startAt(value)
                          .endAt(value + '\uf8ff')
                          .get();

                      if (snapshot.exists) {
                        final data = snapshot.value as Map;
                        searchResults = data.entries
                            .where((entry) {
                              final trainee = entry.value as Map;
                              // Only show trainees who don't have a trainer or have this trainer
                              return trainee['trainerId'] == null || 
                                     trainee['trainerId'] == _trainerId;
                            })
                            .map((entry) => {
                                  'key': entry.key,
                                  'name': (entry.value as Map)['name'] ?? 'No Name',
                                  'email': (entry.value as Map)['email'] ?? 'No Email',
                                })
                            .toList();
                      } else {
                        searchResults = [];
                      }
                    } catch (e) {
                      print('Error searching trainees: $e');
                      searchResults = [];
                    }

                    setState(() => isSearching = false);
                  },
                ),
                const SizedBox(height: 16),
                if (isSearching)
                  const Center(child: CircularProgressIndicator())
                else if (searchResults.isNotEmpty)
                  ...searchResults.map((trainee) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text(
                            trainee['name'][0],
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(trainee['name']),
                        subtitle: Text(trainee['email']),
                        onTap: () async {
                          try {
                            // Update trainee with trainer ID
                            await _database
                                .child('users/trainees/${trainee['key']}')
                                .update({
                              'trainerId': _trainerId,
                              'assignedAt': ServerValue.timestamp,
                            });

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Trainee added successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error adding trainee: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error adding trainee: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ))
                else if (searchController.text.isNotEmpty)
                  const Center(
                    child: Text('No trainees found'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _assignWorkout(BuildContext context, String traineeKey, String traineeName) async {
    final workoutNameController = TextEditingController();
    final workoutDescController = TextEditingController();
    final durationController = TextEditingController();
    List<String> selectedExercises = [];

    final exercises = [
      'Push-ups',
      'Pull-ups',
      'Squats',
      'Deadlifts',
      'Bench Press',
      'Lunges',
      'Planks',
      'Burpees',
      'Mountain Climbers',
      'Jumping Jacks',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Assign Workout to $traineeName'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: workoutNameController,
                  decoration: const InputDecoration(
                    labelText: 'Workout Name',
                    hintText: 'Enter workout name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: workoutDescController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter workout description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (weeks)',
                    hintText: 'Enter duration in weeks',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Exercises:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: exercises.map((exercise) {
                    final isSelected = selectedExercises.contains(exercise);
                    return FilterChip(
                      label: Text(exercise),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedExercises.add(exercise);
                          } else {
                            selectedExercises.remove(exercise);
                          }
                        });
                      },
                      backgroundColor: isSelected ? Colors.green.shade100 : null,
                      checkmarkColor: Colors.green.shade700,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = workoutNameController.text.trim();
                final description = workoutDescController.text.trim();
                final duration = durationController.text.trim();

                if (name.isEmpty || description.isEmpty || duration.isEmpty || selectedExercises.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields and select exercises'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final workoutKey = DateTime.now().millisecondsSinceEpoch.toString();
                  await _database.child('users/trainees/$traineeKey/workoutPlans/$workoutKey').set({
                    'name': name,
                    'description': description,
                    'duration': int.parse(duration),
                    'exercises': selectedExercises,
                    'assignedAt': ServerValue.timestamp,
                    'status': 'active',
                    'progress': 0,
                    'completedSessions': 0,
                    'totalSessions': int.parse(duration) * 7, // Assuming daily sessions
                  });

                  // Add to trainer's assigned workouts
                  await _database.child('users/trainers/$_trainerId/assignedWorkouts/$workoutKey').set({
                    'traineeId': traineeKey,
                    'workoutName': name,
                    'assignedAt': ServerValue.timestamp,
                  });

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Workout assigned successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  print('Error assigning workout: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error assigning workout: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewClientDetails(BuildContext context, String clientName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        clientName[0],
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Member since: Jan 2024',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailSection('Current Goals', [
                  'Weight Loss - Target: 10kg',
                  'Improve Cardio Endurance',
                  'Build Core Strength',
                ]),
                _buildDetailSection('Current Measurements', [
                  'Weight: 75kg',
                  'Height: 175cm',
                  'BMI: 24.5',
                  'Body Fat: 22%',
                ]),
                _buildDetailSection('Active Workout Plans', [
                  'Weight Loss Program - Week 2/8',
                  'Core Strength Program - Week 1/4',
                ]),
                _buildDetailSection('Recent Activity', [
                  'Completed workout session - Yesterday',
                  'Updated measurements - 3 days ago',
                  'Started new program - 1 week ago',
                ]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showMessageDialog(context, clientName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Send Message'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showMessageDialog(BuildContext context, String clientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message $clientName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message sent to $clientName'),
                  backgroundColor: Colors.green.shade700,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _editClient(BuildContext context, String clientKey) {
    // Navigate to edit client page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditClientPage(clientName: clientName)));
  }

  void _sendMessage(BuildContext context, String clientKey) {
    // Navigate to messaging page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MessageClientPage(clientName: clientName)));
  }

  void _showDeleteConfirmation(BuildContext context, String clientKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Client'),
        content: Text('Are you sure you want to remove this client?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete client logic here
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _traineesSubscription?.cancel();
    _searchController.dispose();
    _nameController.dispose();
    _goalController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Trainees',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.white),
                onPressed: () {
                  _showAddClientDialog(context);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search trainees...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _filterTrainees,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _trainees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No trainees found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add trainees to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _setupTraineesListener();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _trainees.length,
                          itemBuilder: (context, index) {
                            final trainee = _trainees[index];
                            return _buildClientCard(
                              trainee['key'],
                              trainee['name'],
                              trainee['goal'],
                              trainee['lastSession'],
                              trainee['progress'],
                              trainee['assignedWorkout'],
                              context,
                            );
                          },
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientCard(
    String key,
    String name,
    String goal,
    String lastSession,
    double progress,
    String? assignedWorkout,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    name.isNotEmpty ? name[0] : '?',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        goal,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      if (assignedWorkout != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Assigned Workout: $assignedWorkout',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) => _handleMenuSelection(value, key, context),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Client'),
                    ),
                    const PopupMenuItem(
                      value: 'message',
                      child: Text('Send Message'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Remove Client'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              lastSession,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewClientDetails(context, name),
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _assignWorkout(context, key, name),
                    icon: const Icon(Icons.fitness_center),
                    label: const Text('Assign'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(String value, String key, BuildContext context) {
    switch (value) {
      case 'edit':
        _editClient(context, key);
        break;
      case 'message':
        _sendMessage(context, key);
        break;
      case 'delete':
        _showDeleteConfirmation(context, key);
        break;
    }
  }
} 