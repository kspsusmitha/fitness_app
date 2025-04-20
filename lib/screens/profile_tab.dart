import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _profileImage;
  final Map<String, double> fitnessGoals = {
    'Weight Loss': 0.7,
    'Muscle Gain': 0.4,
    'Cardio Fitness': 0.6,
    'Flexibility': 0.5,
  };

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsSection(),
            _buildGoalsSection(),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : const NetworkImage(
                          'https://example.com/default_profile.jpg',
                        ),
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.camera_alt, size: 20, color: Colors.blue.shade800),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Premium Member',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Handle edit profile
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fitness Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Weight',
                  '75 kg',
                  Icons.monitor_weight,
                  Colors.blue.shade100,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Height',
                  '175 cm',
                  Icons.height,
                  Colors.green.shade100,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'BMI',
                  '22.5',
                  Icons.favorite,
                  Colors.red.shade100,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fitness Goals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Handle adding new goal
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Goal'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...fitnessGoals.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text('${(entry.value * 100).toInt()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getGoalColor(entry.value),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getGoalColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Personal Information',
            'Update your profile details',
            Icons.person_outline,
            onTap: () {
              // Handle personal info
            },
          ),
          _buildSettingsTile(
            'Notifications',
            'Manage your alerts',
            Icons.notifications_none,
            onTap: () {
              // Handle notifications
            },
          ),
          _buildSettingsTile(
            'Privacy',
            'Control your privacy settings',
            Icons.privacy_tip_outlined,
            onTap: () {
              // Handle privacy
            },
          ),
          _buildSettingsTile(
            'Help & Support',
            'Get help or contact support',
            Icons.help_outline,
            onTap: () {
              // Handle help
            },
          ),
          _buildSettingsTile(
            'Logout',
            'Sign out of your account',
            Icons.logout,
            isDestructive: true,
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.blue,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle logout
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 