import 'package:flutter/material.dart';

class MembershipTab extends StatefulWidget {
  const MembershipTab({super.key});

  @override
  State<MembershipTab> createState() => _MembershipTabState();
}

class _MembershipTabState extends State<MembershipTab> {
  bool autoRenewal = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Membership'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentPlanCard(),
              const SizedBox(height: 24),
              const Text(
                'Available Plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildAvailablePlans(),
              const SizedBox(height: 24),
              _buildSubscriptionManagement(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Premium Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Valid until: December 31, 2024',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Benefits:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem('Unlimited access to all equipment'),
              _buildBenefitItem('Free group fitness classes'),
              _buildBenefitItem('Personal trainer consultation'),
              _buildBenefitItem('Access to premium facilities'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle plan details
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              benefit,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePlans() {
    return Column(
      children: [
        _buildPlanCard(
          'Basic Plan',
          '49.99',
          ['Access to gym equipment', 'Basic fitness assessment', 'Locker access'],
          false,
          Colors.grey.shade200,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          'Premium Plan',
          '99.99',
          [
            'All Basic Plan features',
            'Unlimited fitness classes',
            'Personal trainer sessions',
            'Nutrition consultation',
          ],
          true,
          Colors.blue.shade50,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          'Elite Plan',
          '149.99',
          [
            'All Premium Plan features',
            'Priority class booking',
            'Spa access',
            'Guest passes',
            'Exclusive events',
          ],
          false,
          Colors.purple.shade50,
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    String title,
    String price,
    List<String> features,
    bool isPopular,
    Color backgroundColor,
  ) {
    return Card(
      elevation: isPopular ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isPopular
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Most Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$$price/month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isPopular ? Colors.blue : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isPopular ? Colors.blue : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular ? Colors.blue : null,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Subscribe Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionManagement() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildManagementTile(
              'Payment Method',
              'Update your payment details',
              Icons.payment,
              onTap: () {
                // Handle payment method update
              },
            ),
            _buildManagementTile(
              'Billing History',
              'View your past payments',
              Icons.history,
              onTap: () {
                // Show billing history
              },
            ),
            SwitchListTile(
              title: const Text('Auto-Renewal'),
              subtitle: const Text('Automatically renew subscription'),
              value: autoRenewal,
              onChanged: (value) {
                setState(() {
                  autoRenewal = value;
                });
              },
            ),
            _buildManagementTile(
              'Cancel Subscription',
              'End your current plan',
              Icons.cancel_outlined,
              isDestructive: true,
              onTap: () {
                _showCancellationDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile(
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

  void _showCancellationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your subscription? '
          'You will lose access to all premium features at the end of your current billing period.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle cancellation
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
} 