import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String? _selectedWorkoutPlan;

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
                'My Clients',
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
            decoration: InputDecoration(
              hintText: 'Search clients...',
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
            onChanged: (value) {
              // Implement search functionality
            },
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildClientCard(
                  'Sarah Johnson',
                  'Weight Loss',
                  'Last session: 2 days ago',
                  0.7,
                  context,
                ),
                _buildClientCard(
                  'Mike Thompson',
                  'Muscle Gain',
                  'Last session: Yesterday',
                  0.5,
                  context,
                ),
                _buildClientCard(
                  'Emily Davis',
                  'Flexibility',
                  'Last session: Today',
                  0.8,
                  context,
                ),
                _buildClientCard(
                  'James Wilson',
                  'Cardio Fitness',
                  'Last session: 3 days ago',
                  0.6,
                  context,
                ),
                _buildClientCard(
                  'Lisa Brown',
                  'Strength Training',
                  'Last session: 1 week ago',
                  0.4,
                  context,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientCard(
    String name,
    String goal,
    String lastSession,
    double progress,
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
                    name[0],
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
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) => _handleMenuSelection(value, name, context),
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
                    onPressed: () => _assignWorkout(context, name),
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

  void _handleMenuSelection(String value, String clientName, BuildContext context) {
    switch (value) {
      case 'edit':
        _editClient(context, clientName);
        break;
      case 'message':
        _sendMessage(context, clientName);
        break;
      case 'delete':
        _showDeleteConfirmation(context, clientName);
        break;
    }
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Client'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter client name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  hintText: 'Enter client\'s goal',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter client\'s email',
                ),
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
            onPressed: () {
              // Add client logic here
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

  void _assignWorkout(BuildContext context, String clientName) {
    setState(() {
      _selectedWorkoutPlan = null;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Assign Workout to $clientName'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Workout Plan:'),
                const SizedBox(height: 16),
                _buildWorkoutPlanOption(
                  'Weight Loss Program',
                  '8 weeks',
                  ['Cardio', 'HIIT'],
                  context,
                  setDialogState,
                ),
                _buildWorkoutPlanOption(
                  'Strength Training',
                  '12 weeks',
                  ['Weights', 'Core'],
                  context,
                  setDialogState,
                ),
                _buildWorkoutPlanOption(
                  'Flexibility Focus',
                  '4 weeks',
                  ['Yoga', 'Stretching'],
                  context,
                  setDialogState,
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
              onPressed: _selectedWorkoutPlan == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      _showAssignmentSuccess(context, clientName);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                disabledBackgroundColor: Colors.grey.shade400,
              ),
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutPlanOption(
    String title,
    String duration,
    List<String> tags,
    BuildContext context,
    StateSetter setDialogState,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setDialogState(() {
            _selectedWorkoutPlan = title;
          });
        },
        child: ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(duration),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: tags
                    .map((tag) => Chip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                          backgroundColor: Colors.green.shade50,
                          padding: const EdgeInsets.all(4),
                        ))
                    .toList(),
              ),
            ],
          ),
          trailing: Radio<String>(
            value: title,
            groupValue: _selectedWorkoutPlan,
            onChanged: (value) {
              setDialogState(() {
                _selectedWorkoutPlan = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void _showAssignmentSuccess(BuildContext context, String clientName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout plan assigned to $clientName successfully'),
        backgroundColor: Colors.green.shade700,
      ),
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

  void _editClient(BuildContext context, String clientName) {
    // Navigate to edit client page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditClientPage(clientName: clientName)));
  }

  void _sendMessage(BuildContext context, String clientName) {
    // Navigate to messaging page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MessageClientPage(clientName: clientName)));
  }

  void _showDeleteConfirmation(BuildContext context, String clientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Client'),
        content: Text('Are you sure you want to remove $clientName?'),
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
} 