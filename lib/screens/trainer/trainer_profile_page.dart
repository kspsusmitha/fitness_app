import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainerProfilePage extends StatefulWidget {
  const TrainerProfilePage({super.key});

  @override
  State<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  Map<String, dynamic>? _trainerData;
  bool _isLoading = true;
  String? _trainerKey;

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _fetchTrainerData();
  }

  Future<void> _fetchTrainerData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    final db = FirebaseDatabase.instance.ref();
    final snapshot = await db.child('users/trainers').orderByChild('email').equalTo(email).get();

    if (snapshot.exists) {
      final entry = (snapshot.value as Map).entries.first;
      final trainerMap = entry.value as Map;
      _trainerKey = entry.key;
      setState(() {
        _trainerData = Map<String, dynamic>.from(trainerMap);
        _nameController.text = _trainerData!['name'] ?? '';
        _phoneController.text = _trainerData!['phone'] ?? '';
        _ageController.text = _trainerData!['age']?.toString() ?? '';
        _heightController.text = _trainerData!['height']?.toString() ?? '';
        _weightController.text = _trainerData!['weight']?.toString() ?? '';
        _selectedGender = _trainerData!['gender'] ?? 'Male';
        _isLoading = false;
      });
    } else {
      setState(() {
        _trainerData = null;
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
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  }
                },
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
    if (_trainerKey == null) return;
    final db = FirebaseDatabase.instance.ref();
    await db.child('users/trainers/$_trainerKey').update({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'age': _ageController.text,
      'height': _heightController.text,
      'weight': _weightController.text,
      'gender': _selectedGender,
    });
    await _fetchTrainerData();
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_trainerData == null) {
      return const Scaffold(
        body: Center(child: Text('No trainer data found.')),
      );
    }

    final missing = _isMissing(_trainerData!['name']) ||
        _isMissing(_trainerData!['phone']) ||
        _isMissing(_trainerData!['age']?.toString()) ||
        _isMissing(_trainerData!['height']?.toString()) ||
        _isMissing(_trainerData!['weight']?.toString()) ||
        _isMissing(_trainerData!['gender']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Profile'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.person, size: 60, color: Colors.green.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              _trainerData!['name'] ?? 'No Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _trainerData!['email'] ?? 'No Email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (_trainerData!['phone'] != null)
              Text(
                _trainerData!['phone'],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            _buildInfoCard('Age', _trainerData!['age']?.toString()),
            _buildInfoCard('Height (cm)', _trainerData!['height']?.toString()),
            _buildInfoCard('Weight (kg)', _trainerData!['weight']?.toString()),
            _buildInfoCard('Gender', _trainerData!['gender']),
            if (_trainerData!['specializations'] != null && (_trainerData!['specializations'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Specializations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_trainerData!['specializations'] as List)
                          .map<Widget>((spec) => Chip(
                                label: Text(spec.toString()),
                                backgroundColor: Colors.green.shade100,
                                labelStyle: TextStyle(color: Colors.green.shade900),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton.icon(
                onPressed: _showEditProfileDialog,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: missing ? Colors.orange : Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    final isMissing = value == null || value.isEmpty;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: isMissing ? Colors.red.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(
          _getIconForLabel(label),
          color: isMissing ? Colors.red : Colors.green,
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
      case 'Gender':
        return Icons.person_outline;
      default:
        return Icons.info;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}