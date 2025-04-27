import 'package:flutter/material.dart';

class TrainerDetailsPage extends StatelessWidget {
  const TrainerDetailsPage({super.key});

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
          _buildTrainerProfile(context),
        ],
      ),
    );
  }

  Widget _buildTrainerProfile(BuildContext context) {
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
                    'M',
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
                      const Text(
                        'Coach Michael',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: TR12345',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Certified Personal Trainer',
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
                _buildSpecializations(),
                const SizedBox(height: 24),

                _buildSectionTitle('Certifications'),
                _buildCertifications(),
                const SizedBox(height: 24),

                _buildSectionTitle('About'),
                _buildAboutSection(),
                const SizedBox(height: 24),

                _buildSectionTitle('Contact Information'),
                _buildContactInfo(),
                const SizedBox(height: 24),

                _buildSectionTitle('Available Time Slots'),
                _buildTimeSlots(),
                const SizedBox(height: 24),

                _buildSectionTitle('Client Reviews'),
                _buildClientReviews(),

                // Add these action buttons after the client reviews section
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

  Widget _buildSpecializations() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSpecializationChip('Weight Loss'),
        _buildSpecializationChip('Strength Training'),
        _buildSpecializationChip('HIIT'),
        _buildSpecializationChip('Nutrition Planning'),
        _buildSpecializationChip('Functional Training'),
      ],
    );
  }

  Widget _buildSpecializationChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.orange.shade50,
      labelStyle: TextStyle(color: Colors.orange.shade700),
    );
  }

  Widget _buildCertifications() {
    return Column(
      children: [
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
      ],
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

  Widget _buildAboutSection() {
    return Text(
      'Dedicated fitness professional with over 5 years of experience in personal training. '
      'Specializing in weight loss, strength training, and functional fitness. '
      'Committed to helping clients achieve their fitness goals through personalized '
      'workout plans and nutritional guidance.',
      style: TextStyle(
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildContactItem(Icons.email, 'Email', 'michael@trainer.com'),
        _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-4567'),
        _buildContactItem(Icons.location_on, 'Location', 'New York, NY'),
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

  Widget _buildTimeSlots() {
    return Column(
      children: [
        _buildTimeSlotItem('Monday - Friday', '6:00 AM - 8:00 PM'),
        _buildTimeSlotItem('Saturday', '8:00 AM - 4:00 PM'),
        _buildTimeSlotItem('Sunday', 'By Appointment'),
      ],
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

  Widget _buildClientReviews() {
    return Column(
      children: [
        _buildReviewItem(
          'Sarah M.',
          5,
          'Amazing trainer! Helped me achieve my weight loss goals.',
          '2 weeks ago',
        ),
        _buildReviewItem(
          'John D.',
          5,
          'Very knowledgeable and professional. Great experience!',
          '1 month ago',
        ),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 16,
                color: index < rating ? Colors.orange.shade700 : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(comment),
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