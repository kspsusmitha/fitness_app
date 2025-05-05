import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TrainerDetailsPage extends StatefulWidget {
  const TrainerDetailsPage({super.key});

  @override
  State<TrainerDetailsPage> createState() => _TrainerDetailsPageState();
}

class _TrainerDetailsPageState extends State<TrainerDetailsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? _trainerData;
  bool _isLoading = true;
  String? _traineeId;
  StreamSubscription? _trainerSubscription;

  @override
  void initState() {
    super.initState();
    _initializeTraineeData();
  }

  Future<void> _initializeTraineeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      
      // Get trainee data
      final traineeSnapshot = await _database
          .child('users/trainees')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (traineeSnapshot.exists) {
        final traineeData = (traineeSnapshot.value as Map).entries.first;
        _traineeId = traineeData.key;
        final trainerId = (traineeData.value as Map)['trainerId'];
        
        if (trainerId != null) {
          _setupTrainerListener(trainerId);
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error initializing trainee data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setupTrainerListener(String trainerId) async {
    // Cancel existing subscription if any
    _trainerSubscription?.cancel();

    setState(() => _isLoading = true);

    // Listen to trainer data
    _trainerSubscription = _database
        .child('users/trainers/$trainerId')
        .onValue
        .listen((DatabaseEvent event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        setState(() {
          _trainerData = null;
          _isLoading = false;
        });
        return;
      }

      try {
        final trainerData = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          _trainerData = trainerData;
          _isLoading = false;
        });
      } catch (e) {
        print('Error processing trainer data: $e');
        setState(() {
          _trainerData = null;
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Error in trainer stream: $error');
      setState(() {
        _trainerData = null;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _trainerSubscription?.cancel();
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
            'My Trainer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_trainerData == null)
            Center(
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
                    'No trainer assigned yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will be assigned a trainer soon',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          else
            _buildTrainerProfile(context),
        ],
      ),
    );
  }

  Widget _buildTrainerProfile(BuildContext context) {
    // Access the trainer data directly from the root level
    final name = _trainerData!['name'] ?? 'No Name';
    final title = _trainerData!['title'] ?? 'Personal Trainer';
    final bio = _trainerData!['bio'] ?? '';
    final specializations = List<String>.from(_trainerData!['specializations'] ?? []);
    final certifications = List<Map<String, dynamic>>.from(_trainerData!['certifications'] ?? []);
    final availability = Map<String, dynamic>.from(_trainerData!['availability'] ?? {});
    final contactInfo = {
      'email': _trainerData!['email'] ?? '',
      'phone': _trainerData!['phone'] ?? '',
      'location': _trainerData!['location'] ?? '',
    };

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange.shade100,
                  child: Text(
                    name[0],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${_trainerData!['id']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Trainer Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Experience'),
                _buildExperienceInfo(),
                const SizedBox(height: 24),

                _buildSectionTitle('Specializations'),
                _buildSpecializations(specializations),
                const SizedBox(height: 24),

                _buildSectionTitle('Certifications'),
                _buildCertifications(certifications),
                const SizedBox(height: 24),

                _buildSectionTitle('About'),
                _buildAboutSection(bio),
                const SizedBox(height: 24),

                _buildSectionTitle('Contact Information'),
                _buildContactInfo(contactInfo),
                const SizedBox(height: 24),

                _buildSectionTitle('Available Time Slots'),
                _buildTimeSlots(availability),
                const SizedBox(height: 24),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Schedule Session Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _scheduleSession(context),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Schedule Training Session'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Message Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _messageTrainer(context),
                          icon: const Icon(Icons.message),
                          label: const Text('Message Trainer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange.shade700,
                            side: BorderSide(color: Colors.orange.shade700),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildExperienceInfo() {
    return Row(
      children: [
        _buildExperienceItem('5+', 'Years\nExperience'),
        _buildExperienceItem('100+', 'Clients\nTrained'),
        _buildExperienceItem('4.9', 'Rating\n(50 reviews)'),
      ],
    );
  }

  Widget _buildExperienceItem(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializations(List specializations) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specializations.map((spec) => _buildSpecializationChip(spec.toString())).toList(),
    );
  }

  Widget _buildSpecializationChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.orange.shade50,
      labelStyle: TextStyle(color: Colors.orange.shade700),
    );
  }

  Widget _buildCertifications(List certifications) {
    return Column(
      children: certifications.map((cert) => _buildCertificationItem(
        cert['title'] ?? '',
        cert['organization'] ?? '',
        cert['year'] ?? '',
      )).toList(),
    );
  }

  Widget _buildCertificationItem(String title, String organization, String year) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '$organization • $year',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String bio) {
    return Text(
      bio,
      style: TextStyle(
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  Widget _buildContactInfo(Map<String, dynamic> personalInfo) {
    return Column(
      children: [
        _buildContactItem(Icons.email, 'Email', personalInfo['email'] ?? ''),
        _buildContactItem(Icons.phone, 'Phone', personalInfo['phone'] ?? ''),
        _buildContactItem(Icons.location_on, 'Location', personalInfo['location'] ?? ''),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(Map<String, dynamic> availability) {
    return Column(
      children: availability.entries.map((entry) => _buildTimeSlotItem(
        entry.key,
        '${entry.value['start']} - ${entry.value['end']}',
      )).toList(),
    );
  }

  Widget _buildTimeSlotItem(String day, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(
            time,
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Add these methods to handle button actions

  void _scheduleSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Training Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Select Date'),
              onTap: () {
                // Implement date picker
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
              },
            ),
            // Time Slot Picker
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Select Time Slot'),
              onTap: () {
                // Implement time picker
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
            ),
            // Session Type
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Session Type',
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: const [
                DropdownMenuItem(value: 'one_on_one', child: Text('One-on-One Training')),
                DropdownMenuItem(value: 'group', child: Text('Group Session')),
                DropdownMenuItem(value: 'assessment', child: Text('Fitness Assessment')),
              ],
              onChanged: (value) {},
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
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Session scheduled successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
            ),
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _messageTrainer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Trainer'),
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
            const SizedBox(height: 16),
            // Quick Message Templates
            Wrap(
              spacing: 8,
              children: [
                _buildQuickMessage('Schedule change request'),
                _buildQuickMessage('Question about workout'),
                _buildQuickMessage('Need modification'),
              ],
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
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Message sent successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMessage(String message) {
    return GestureDetector(
      onTap: () {
        // Implement quick message selection
      },
      child: Chip(
        label: Text(message),
        backgroundColor: Colors.orange.shade50,
        labelStyle: TextStyle(color: Colors.orange.shade700),
      ),
    );
  }

  // Add these additional sections to _buildTrainerProfile
  // after the certifications section

  Widget _buildTrainingApproach() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Training Approach'),
        _buildApproachItem(
          'Personalized Programs',
          'Customized workouts based on your goals and fitness level',
        ),
        _buildApproachItem(
          'Progress Tracking',
          'Regular assessments and adjustments to ensure optimal results',
        ),
        _buildApproachItem(
          'Nutrition Guidance',
          'Dietary recommendations to complement your training',
        ),
      ],
    );
  }

  Widget _buildApproachItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
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