import 'package:flutter/material.dart';

class TraineeProfilePage extends StatelessWidget {
  const TraineeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.orange.shade700,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
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
                  Text(
                    'Member since: Jan 2024',
                    style: TextStyle(
                      color: Colors.orange.shade100,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Personal Information',
                    [
                      _buildInfoItem(Icons.email, 'Email', 'john.doe@example.com'),
                      _buildInfoItem(Icons.phone, 'Phone', '+1 234 567 8900'),
                      _buildInfoItem(Icons.calendar_today, 'Age', '28 years'),
                      _buildInfoItem(Icons.height, 'Height', '175 cm'),
                      _buildInfoItem(Icons.monitor_weight, 'Weight', '68 kg'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Fitness Goals',
                    [
                      _buildGoalItem('Weight Loss', '5 kg to go'),
                      _buildGoalItem('Muscle Gain', 'In progress'),
                      _buildGoalItem('Flexibility', 'Achieved'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Account Settings',
                    [
                      _buildSettingItem(
                        Icons.edit,
                        'Edit Profile',
                        () => _editProfile(context),
                      ),
                      _buildSettingItem(
                        Icons.notifications,
                        'Notifications',
                        () => _manageNotifications(context),
                      ),
                      _buildSettingItem(
                        Icons.lock,
                        'Change Password',
                        () => _changePassword(context),
                      ),
                      _buildSettingItem(
                        Icons.logout,
                        'Logout',
                        () => _showLogoutDialog(context),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String goal, String status) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(goal),
      subtitle: Text(status),
      trailing: Icon(
        Icons.check_circle,
        color: status == 'Achieved' ? Colors.green : Colors.grey,
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.orange.shade700),
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }

  void _editProfile(BuildContext context) {
    // Implement edit profile functionality
  }

  void _manageNotifications(BuildContext context) {
    // Implement notifications management
  }

  void _changePassword(BuildContext context) {
    // Implement password change functionality
  }

  void _showLogoutDialog(BuildContext context) {
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
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
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