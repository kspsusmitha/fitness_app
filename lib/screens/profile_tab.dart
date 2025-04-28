import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _email;
  String? _phone;
  final Map<String, double> fitnessGoals = {
    'Weight Loss': 0.7,
    'Muscle Gain': 0.4,
    'Cardio Fitness': 0.6,
    'Flexibility': 0.5,
  };
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _userType;
  String? _userKey;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('userType') ?? 'member';
    _email = prefs.getString('email') ?? '';

    String dbPath;
    switch (_userType) {
      case 'trainer':
        dbPath = 'users/trainers';
        break;
      case 'trainee':
        dbPath = 'users/trainees';
        break;
      default:
        dbPath = 'users/members';
    }

    final db = FirebaseDatabase.instance.ref();
    final snapshot = await db.child(dbPath).orderByChild('email').equalTo(_email).get();

    if (snapshot.exists) {
      final userEntry = (snapshot.value as Map).entries.first;
      final userMap = userEntry.value as Map;
      _userKey = userEntry.key;
      setState(() {
        _userData = Map<String, dynamic>.from(userMap);
        _nameController.text = _userData!['name'] ?? '';
        _ageController.text = _userData!['age']?.toString() ?? '';
        _heightController.text = _userData!['height']?.toString() ?? '';
        _weightController.text = _userData!['weight']?.toString() ?? '';
        _phoneController.text = _userData!['phone'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _userData = null;
        _isLoading = false;
      });
    }
  }

  bool _isMissing(String? value) => value == null || value.isEmpty;

  Future<void> _showEditProfileDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
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
              await _updateProfile();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (_userKey == null) return;
    String dbPath;
    switch (_userType) {
      case 'trainer':
        dbPath = 'users/trainers';
        break;
      case 'trainee':
        dbPath = 'users/trainees';
        break;
      default:
        dbPath = 'users/members';
    }
    final db = FirebaseDatabase.instance.ref();
    await db.child('$dbPath/$_userKey').update({
      'name': _nameController.text,
      'age': _ageController.text,
      'height': _heightController.text,
      'weight': _weightController.text,
      'phone': _phoneController.text,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('phone', _phoneController.text);
    await _fetchUserData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_userData == null) {
      return const Center(child: Text('No user data found.'));
    }

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
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 60, color: Colors.blue.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                _userData!['name'] ?? 'No Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                _userData!['email'] ?? 'No Email',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              if (_userData!['phone'] != null)
                Text(
                  _userData!['phone'],
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              const SizedBox(height: 16),
              // Always show Edit Profile button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info Cards
              _buildInfoCard('Age', _userData!['age']?.toString()),
              _buildInfoCard('Height (cm)', _userData!['height']?.toString()),
              _buildInfoCard('Weight (kg)', _userData!['weight']?.toString()),

              // Prompt to update missing info
              if (_isMissing(_userData!['age']?.toString()) ||
                  _isMissing(_userData!['height']?.toString()) ||
                  _isMissing(_userData!['weight']?.toString()) ||
                  _isMissing(_userData!['phone']))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.orange.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Some of your profile information is missing.",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _showEditProfileDialog,
                            icon: const Icon(Icons.edit),
                            label: const Text("Update Profile"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    final isMissing = _isMissing(value);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: isMissing ? Colors.red.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(
          _getIconForLabel(label),
          color: isMissing ? Colors.red : Colors.blue,
        ),
        title: Text(label),
        trailing: Text(
          isMissing ? 'Not set' : value!,
          style: TextStyle(
            color: isMissing ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Age':
        return Icons.cake;
      case 'Height (cm)':
        return Icons.height;
      case 'Weight (kg)':
        return Icons.monitor_weight;
      default:
        return Icons.info;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}