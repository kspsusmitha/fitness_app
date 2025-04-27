import 'package:flutter/material.dart';

class WorkoutPlansPage extends StatefulWidget {
  const WorkoutPlansPage({super.key});

  @override
  State<WorkoutPlansPage> createState() => _WorkoutPlansPageState();
}

class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  // Sample clients data - replace with your actual data source
  final List<String> clients = [
    'Sarah Johnson',
    'Mike Thompson',
    'Emily Davis',
    'James Wilson',
    'Lisa Brown',
  ];

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
                'Workout Plans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  _showFilterOptions(context);
                },
              ),
            ],
          ),
        ),
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
                _buildWorkoutPlanCard(
                  'Beginner Weight Loss',
                  'A 4-week program designed for beginners focusing on weight loss',
                  ['Cardio', 'HIIT', 'Light Strength'],
                  '4 weeks',
                  ['Sarah Johnson', 'Lisa Brown'],
                  context,
                ),
                _buildWorkoutPlanCard(
                  'Intermediate Muscle Building',
                  'A 6-week program for intermediate clients focusing on muscle hypertrophy',
                  ['Strength Training', 'Progressive Overload', 'Nutrition'],
                  '6 weeks',
                  ['Mike Thompson', 'James Wilson'],
                  context,
                ),
                _buildWorkoutPlanCard(
                  'Advanced Flexibility',
                  'An 8-week program for improving flexibility and mobility',
                  ['Stretching', 'Yoga', 'Mobility Work'],
                  '8 weeks',
                  ['Emily Davis'],
                  context,
                ),
                _buildWorkoutPlanCard(
                  'Core Strength',
                  'A 4-week program focusing on core strength and stability',
                  ['Planks', 'Ab Exercises', 'Lower Back Work'],
                  '4 weeks',
                  [],
                  context,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAssignToClientDialog(BuildContext context, String planTitle, List<String> currentlyAssigned) {
    List<String> selectedClients = List.from(currentlyAssigned);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Assign $planTitle'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select clients to assign this plan:'),
                const SizedBox(height: 16),
                ...clients.map((client) => CheckboxListTile(
                  title: Text(client),
                  value: selectedClients.contains(client),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedClients.add(client);
                      } else {
                        selectedClients.remove(client);
                      }
                    });
                  },
                  secondary: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      client[0],
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
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
                // Here you would update your data source with the new assignments
                Navigator.pop(context);
                _showAssignmentSuccess(context, selectedClients);
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

  void _showAssignmentSuccess(BuildContext context, List<String> clients) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          clients.isEmpty
              ? 'No clients selected'
              : 'Workout plan assigned to ${clients.length} client(s)',
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Widget _buildWorkoutPlanCard(
    String title,
    String description,
    List<String> focus,
    String duration,
    List<String> assignedClients,
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.fitness_center, color: Colors.green.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Duration: $duration',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showPlanOptions(context, title),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: focus.map((item) => _buildFocusChip(item)).toList(),
            ),
            if (assignedClients.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assigned to ${assignedClients.length} client(s)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAssignedClientsDetails(context, assignedClients),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewWorkoutPlanDetails(context, title),
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
                    onPressed: () => _showAssignToClientDialog(context, title, assignedClients),
                    icon: const Icon(Icons.person_add),
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

  Widget _buildFocusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          fontSize: 12,
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Plans'),
            leading: const Icon(Icons.all_inclusive),
            onTap: () {
              Navigator.pop(context);
              // Implement filter logic
            },
          ),
          ListTile(
            title: const Text('Assigned Plans'),
            leading: const Icon(Icons.assignment_turned_in),
            onTap: () {
              Navigator.pop(context);
              // Implement filter logic
            },
          ),
          ListTile(
            title: const Text('Unassigned Plans'),
            leading: const Icon(Icons.assignment),
            onTap: () {
              Navigator.pop(context);
              // Implement filter logic
            },
          ),
        ],
      ),
    );
  }

  void _showPlanOptions(BuildContext context, String planTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.green.shade700),
            title: const Text('Edit Plan'),
            onTap: () {
              Navigator.pop(context);
              _editWorkoutPlan(context, planTitle);
            },
          ),
          ListTile(
            leading: Icon(Icons.copy, color: Colors.blue.shade700),
            title: const Text('Duplicate Plan'),
            onTap: () {
              Navigator.pop(context);
              _duplicatePlan(context, planTitle);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red.shade700),
            title: const Text('Delete Plan'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, planTitle);
            },
          ),
        ],
      ),
    );
  }

  void _showAssignedClientsDetails(BuildContext context, List<String> clients) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigned Clients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...clients.map((client) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Text(
                  client[0],
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(client),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red,
                onPressed: () {
                  // Handle removing client from workout plan
                  Navigator.pop(context);
                  _showRemoveClientConfirmation(context, client);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showRemoveClientConfirmation(BuildContext context, String clientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Client'),
        content: Text('Remove $clientName from this workout plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle removing client
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$clientName removed from workout plan'),
                  backgroundColor: Colors.red,
                ),
              );
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

  void _viewWorkoutPlanDetails(BuildContext context, String planTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.fitness_center, 
                        color: Colors.green.shade700,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Created on: January 15, 2024',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailSection(
                  'Schedule',
                  [
                    _buildScheduleItem('Week 1-2', 'Foundation Phase'),
                    _buildScheduleItem('Week 3-4', 'Progressive Overload'),
                    _buildScheduleItem('Week 5-6', 'Intensity Increase'),
                    _buildScheduleItem('Week 7-8', 'Peak Performance'),
                  ],
                ),
                _buildDetailSection(
                  'Workouts',
                  [
                    _buildWorkoutItem(
                      'Monday - Upper Body',
                      'Chest, Shoulders, Triceps',
                      '8 exercises • 45-60 min',
                    ),
                    _buildWorkoutItem(
                      'Tuesday - Lower Body',
                      'Quads, Hamstrings, Calves',
                      '7 exercises • 40-50 min',
                    ),
                    _buildWorkoutItem(
                      'Thursday - Back & Core',
                      'Back, Biceps, Core',
                      '9 exercises • 50-65 min',
                    ),
                    _buildWorkoutItem(
                      'Friday - Full Body',
                      'Compound Movements',
                      '6 exercises • 45-55 min',
                    ),
                  ],
                ),
                _buildDetailSection2(
                  'Equipment Needed',
                  [
                    'Dumbbells (various weights)',
                    'Resistance bands',
                    'Yoga mat',
                    'Pull-up bar (optional)',
                    'Bench or stable elevated surface',
                  ],
                ),
                _buildDetailSection2(
                  'Nutrition Guidelines',
                  [
                    'Protein: 1.6-2.0g per kg of body weight',
                    'Carbs: 3-5g per kg of body weight',
                    'Fats: 0.8-1.2g per kg of body weight',
                    'Water: 3-4 liters per day',
                    'Pre and post workout meals recommended',
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _editWorkoutPlan(context, planTitle);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Workout Plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
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
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDetailSection2(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, 
                size: 20, 
                color: Colors.green.shade700
              ),
              const SizedBox(width: 8),
              Text(item),
            ],
          ),
        )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildScheduleItem(String week, String phase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.green.shade700),
        title: Text(week),
        subtitle: Text(phase),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: () {
          // Navigate to detailed week view
        },
      ),
    );
  }

  Widget _buildWorkoutItem(String day, String focus, String duration) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.fitness_center, color: Colors.green.shade700),
        title: Text(day),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(focus),
            Text(
              duration,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: () {
          // Navigate to detailed workout view
        },
      ),
    );
  }

  void _editWorkoutPlan(BuildContext context, String planTitle) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit $planTitle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Plan Title',
                    hintText: 'Enter plan title',
                  ),
                  controller: TextEditingController(text: planTitle),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter plan description',
                  ),
                  maxLines: 3,
                  controller: TextEditingController(
                    text: 'A program designed for focusing on specific goals',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    hintText: 'e.g., 4 weeks',
                  ),
                  controller: TextEditingController(text: '4 weeks'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Schedule',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildEditableSchedule(setState),
                const SizedBox(height: 16),
                const Text(
                  'Focus Areas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildEditableFocusAreas(setState),
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
                // Save changes logic here
                Navigator.pop(context);
                _showEditSuccess(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSchedule(StateSetter setState) {
    return Column(
      children: [
        ListTile(
          title: const Text('Monday - Upper Body'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editWorkoutDay(context, 'Monday'),
          ),
        ),
        ListTile(
          title: const Text('Tuesday - Lower Body'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editWorkoutDay(context, 'Tuesday'),
          ),
        ),
        // Add more days as needed
      ],
    );
  }

  Widget _buildEditableFocusAreas(StateSetter setState) {
    return Wrap(
      spacing: 8,
      children: [
        _buildEditableFocusChip('Cardio', setState),
        _buildEditableFocusChip('HIIT', setState),
        _buildEditableFocusChip('Strength', setState),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _addNewFocusArea(context, setState),
        ),
      ],
    );
  }

  Widget _buildEditableFocusChip(String label, StateSetter setState) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () {
        setState(() {
          // Remove focus area logic
        });
      },
    );
  }

  void _editWorkoutDay(BuildContext context, String day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $day Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Focus Areas',
                hintText: 'e.g., Chest, Shoulders, Triceps',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Number of Exercises',
                hintText: 'e.g., 8',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Duration',
                hintText: 'e.g., 45-60 min',
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

  void _addNewFocusArea(BuildContext context, StateSetter setState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Focus Area'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Focus Area',
            hintText: 'Enter new focus area',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add new focus area logic
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

  void _duplicatePlan(BuildContext context, String planTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$planTitle has been duplicated'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String planTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout Plan'),
        content: Text('Are you sure you want to delete "$planTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteSuccess(context, planTitle);
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

  void _showEditSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Workout plan updated successfully'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _showDeleteSuccess(BuildContext context, String planTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$planTitle has been deleted'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
} 