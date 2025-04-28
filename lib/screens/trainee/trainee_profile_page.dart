import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TraineeProfilePage extends StatefulWidget {
  const TraineeProfilePage({super.key});

  @override
  State<TraineeProfilePage> createState() => _TraineeProfilePageState();
}

class _TraineeProfilePageState extends State<TraineeProfilePage> {
  Map<String, dynamic>? _traineeData;
  bool _loading = true;
  bool _editing = false;

  // Controllers for editing
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _traineeKey; // Firebase key for updating

  @override
  void initState() {
    super.initState();
    _fetchTraineeData();
  }

  Future<void> _fetchTraineeData() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    final db = FirebaseDatabase.instance.ref();
    final snapshot = await db.child('users/trainees').orderByChild('email').equalTo(email).get();

    if (snapshot.exists) {
      final entry = (snapshot.value as Map).entries.first;
      final traineeMap = entry.value as Map;
      setState(() {
        _traineeKey = entry.key;
        _traineeData = Map<String, dynamic>.from(traineeMap);
        _loading = false;
      });
    } else {
      setState(() {
        _traineeData = null;
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _showEditProfileDialog() {
    // Pre-fill controllers
    _nameController.text = _traineeData?['name'] ?? '';
    _phoneController.text = _traineeData?['phone'] ?? '';
    _ageController.text = _traineeData?['age']?.toString() ?? '';
    _heightController.text = _traineeData?['height']?.toString() ?? '';
    _weightController.text = _traineeData?['weight']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField(_nameController, 'Name', Icons.person),
              const SizedBox(height: 12),
              _buildEditField(_phoneController, 'Phone', Icons.phone),
              const SizedBox(height: 12),
              _buildEditField(_ageController, 'Age', Icons.cake, isNumber: true),
              const SizedBox(height: 12),
              _buildEditField(_heightController, 'Height (cm)', Icons.height, isNumber: true),
              const SizedBox(height: 12),
              _buildEditField(_weightController, 'Weight (kg)', Icons.monitor_weight, isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveProfileEdits,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _saveProfileEdits() async {
    if (_traineeKey == null) return;
    final db = FirebaseDatabase.instance.ref();
    await db.child('users/trainees/$_traineeKey').update({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? '',
      'height': int.tryParse(_heightController.text.trim()) ?? '',
      'weight': int.tryParse(_weightController.text.trim()) ?? '',
    });
    Navigator.pop(context);
    _fetchTraineeData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_traineeData == null) {
      return const Scaffold(
        body: Center(child: Text('Profile not found.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        title: Text(_traineeData?['name'] ?? 'Trainee Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.orange.shade700),
                ),
                const SizedBox(height: 16),
                Text(
                  _traineeData?['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _traineeData?['email'] ?? '',
                  style: TextStyle(
                    color: Colors.orange.shade100,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _profileInfoRow(Icons.phone, 'Phone', _traineeData?['phone']),
                    const Divider(),
                    _profileInfoRow(Icons.cake, 'Age', _traineeData?['age']?.toString()),
                    const Divider(),
                    _profileInfoRow(Icons.height, 'Height', _traineeData?['height']?.toString(), suffix: 'cm'),
                    const Divider(),
                    _profileInfoRow(Icons.monitor_weight, 'Weight', _traineeData?['weight']?.toString(), suffix: 'kg'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              color: Colors.orange.shade100,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('Fitness Goals'),
                subtitle: Text(_traineeData?['goal'] ?? 'No goals set'),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _profileInfoRow(IconData icon, String label, String? value, {String? suffix}) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange.shade700),
        const SizedBox(width: 16),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value == null || value.isEmpty ? 'Not set' : '$value${suffix ?? ''}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
} 