import 'package:flutter/material.dart';

class TrainerProfilePage extends StatelessWidget {
  const TrainerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.transparent,
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/32.jpg',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.green.shade700,
                          ),
                          onPressed: () {
                            // Implement image picker
                            _showImagePickerOptions(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Michael Johnson',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Certified Personal Trainer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileStat('5', 'Years Exp.'),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    _buildProfileStat('12', 'Clients'),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    _buildProfileStat('4.9', 'Rating'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('About Me', Icons.person_outline),
                  const SizedBox(height: 12),
                  Text(
                    'I am a certified personal trainer with 5 years of experience specializing in strength training, weight loss, and functional fitness. My approach focuses on sustainable lifestyle changes and personalized workout plans.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Certifications', Icons.verified_outlined),
                  const SizedBox(height: 12),
                  _buildCertificationItem(
                    'NASM Certified Personal Trainer',
                    'National Academy of Sports Medicine',
                    '2018',
                  ),
                  _buildCertificationItem(
                    'Precision Nutrition Level 1',
                    'Precision Nutrition',
                    '2019',
                  ),
                  _buildCertificationItem(
                    'Functional Training Specialist',
                    'American Council on Exercise',
                    '2020',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Specializations', Icons.fitness_center_outlined),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSpecializationChip('Weight Loss'),
                      _buildSpecializationChip('Strength Training'),
                      _buildSpecializationChip('Functional Fitness'),
                      _buildSpecializationChip('Nutrition Coaching'),
                      _buildSpecializationChip('HIIT'),
                      _buildSpecializationChip('Mobility'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Contact Information', Icons.contact_mail_outlined),
                  const SizedBox(height: 12),
                  _buildContactItem(Icons.email_outlined, 'michael.j@trainer.com'),
                  _buildContactItem(Icons.phone_outlined, '+1 (555) 123-4567'),
                  _buildContactItem(Icons.location_on_outlined, 'New York, NY'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _editProfile(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutConfirmation(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade700),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationItem(String title, String organization, String year) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$organization • $year',
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

  Widget _buildSpecializationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () {
              // Implement camera capture
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              // Implement gallery picker
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                controller: TextEditingController(text: 'Michael Johnson'),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter your professional title',
                ),
                controller: TextEditingController(text: 'Certified Personal Trainer'),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'About Me',
                  hintText: 'Tell us about yourself',
                ),
                maxLines: 3,
                controller: TextEditingController(
                  text: 'I am a certified personal trainer with 5 years of experience specializing in strength training, weight loss, and functional fitness.',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                controller: TextEditingController(text: 'michael.j@trainer.com'),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                ),
                controller: TextEditingController(text: '+1 (555) 123-4567'),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter your location',
                ),
                controller: TextEditingController(text: 'New York, NY'),
              ),
              const SizedBox(height: 24),
              _buildCertificationsEditor(dialogContext),
              const SizedBox(height: 24),
              _buildSpecializationsEditor(dialogContext),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showSaveSuccess(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Certifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextButton.icon(
              onPressed: () => _addCertification(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildEditableCertification(
                context,
                'NASM Certified Personal Trainer',
                'National Academy of Sports Medicine',
                '2018',
              ),
              const Divider(height: 1),
              _buildEditableCertification(
                context,
                'Precision Nutrition Level 1',
                'Precision Nutrition',
                '2019',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableCertification(
    BuildContext context,
    String title,
    String organization,
    String year,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text('$organization • $year'),
        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _editCertification(context, title, organization, year),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () => _deleteCertification(context, title),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecializationsEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Specializations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextButton.icon(
              onPressed: () => _addSpecialization(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildEditableSpecializationChip(context, 'Weight Loss'),
              _buildEditableSpecializationChip(context, 'Strength Training'),
              _buildEditableSpecializationChip(context, 'Functional Fitness'),
              _buildEditableSpecializationChip(context, 'Nutrition Coaching'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableSpecializationChip(BuildContext context, String label) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () => _deleteSpecialization(context, label),
      backgroundColor: Colors.green.shade50,
      labelStyle: TextStyle(
        color: Colors.green.shade700,
        fontWeight: FontWeight.w500,
      ),
      deleteIconColor: Colors.green.shade700,
    );
  }

  void _addCertification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Certification Title',
                hintText: 'Enter certification title',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Organization',
                hintText: 'Enter organization name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'Enter year obtained',
              ),
              keyboardType: TextInputType.number,
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editCertification(BuildContext context, String title, String organization, String year) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Certification Title',
              ),
              controller: TextEditingController(text: title),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Organization',
              ),
              controller: TextEditingController(text: organization),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              controller: TextEditingController(text: year),
              keyboardType: TextInputType.number,
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCertification(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Certification'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addSpecialization(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Specialization'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Specialization',
            hintText: 'Enter new specialization',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteSpecialization(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Specialization'),
        content: Text('Are you sure you want to delete "$label"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSaveSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
              // Implement logout logic
              Navigator.pop(context);
              // Navigate to login screen
              // Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 