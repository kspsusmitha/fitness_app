import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  List<String> _specializations = [];
  String _selectedGender = 'Male'; // Default gender

  final List<String> _availableSpecializations = [
    'Weight Loss',
    'Muscle Gain',
    'Cardio Fitness',
    'CrossFit',
    'Nutrition',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Add validation methods
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    // Check for valid name characters
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Enhanced email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Check for valid phone number format (adjust regex based on your requirements)
    if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateSpecializations(String userType) {
    if (userType == 'trainer' && _specializations.isEmpty) {
      return 'Please select at least one specialization';
    }
    return null;
  }

  Future<void> _handleRegistration() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    // Additional validation for trainer specializations
    final specializationError = _validateSpecializations(_tabController.index == 1 ? 'trainer' : 'member');
    if (specializationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(specializationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic>? result;

      switch (_tabController.index) {
        case 0: // Member
          result = await _authService.registerMember(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
            gender: _selectedGender,
          );
          break;
        case 1: // Trainer
          result = await _authService.registerTrainer(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
            specializations: _specializations,
            gender: _selectedGender,
          );
          break;
        case 2: // Trainee
          result = await _authService.registerTrainee(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
            gender: _selectedGender,
          );
          break;
      }

      setState(() => _isLoading = false);

      if (result != null && !result.containsKey('error')) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate based on user type
        String route = switch (_tabController.index) {
          0 => '/member_home',
          1 => '/trainer_home',
          2 => '/trainee_home',
          _ => '/login',
        };
        Navigator.pushReplacementNamed(context, route);
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['error'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.blue.shade600,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'MEMBER'),
            Tab(text: 'TRAINER'),
            Tab(text: 'TRAINEE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegistrationForm('member'),
          _buildRegistrationForm('trainer'),
          _buildRegistrationForm('trainee'),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(String userType) {
    bool isTrainer = userType == 'trainer';
    String title = switch (userType) {
      'member' => 'Member',
      'trainer' => 'Trainer',
      'trainee' => 'Trainee',
      _ => '',
    };

    String subtitle = switch (userType) {
      'member' => 'Join our fitness community',
      'trainer' => 'Start your journey as a fitness trainer',
      'trainee' => 'Get personalized training from experts',
      _ => '',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join as $title',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            
            // Common Fields
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            // Gender Selection
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscurePassword,
              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),

            // Trainer-specific fields
            if (isTrainer) ...[
              const SizedBox(height: 20),
              const Text(
                'Select your specializations:',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 8,
                children: _availableSpecializations.map((spec) {
                  return FilterChip(
                    label: Text(spec),
                    selected: _specializations.contains(spec),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _specializations.add(spec);
                        } else {
                          _specializations.remove(spec);
                        }
                      });
                    },
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade700,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        switch (label) {
          case 'Full Name':
            return _validateName(value);
          case 'Email':
            return _validateEmail(value);
          case 'Phone Number':
            return _validatePhone(value);
          default:
            return value?.isEmpty ?? true ? 'Please enter $label' : null;
        }
      },
      onChanged: (value) {
        // Validate on change for immediate feedback
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (label == 'Password') {
          return _validatePassword(value);
        } else {
          return _validateConfirmPassword(value);
        }
      },
      onChanged: (value) {
        // Validate on change for immediate feedback
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
    );
  }
} 