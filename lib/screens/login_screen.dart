import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/home.dart';
import 'package:fitness_app/screens/trainer/trainer_home_page.dart';
import 'package:fitness_app/screens/trainee/trainee_home_page.dart';
import 'package:fitness_app/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Add new validation methods
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    // Check for at least one letter
    if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Password must contain at least one letter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo and App Name
              Column(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FitLife',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your fitness journey starts here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.blue.shade800,
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(
                      text: 'Member',
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      text: 'Trainer',
                      icon: Icon(Icons.sports_gymnastics),
                    ),
                    Tab(
                      text: 'Trainee',
                      icon: Icon(Icons.directions_run),
                    ),
                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm('Member'),
                    _buildLoginForm('Trainer'),
                    _buildLoginForm('Trainee'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(String userType) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _getDescriptionText(userType),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$userType Login',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Email Field with enhanced validation
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    validator: _validateEmail,
                    onChanged: (value) {
                      // Clear any error messages as the user types
                      if (_formKey.currentState != null) {
                        _formKey.currentState!.validate();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field with enhanced validation
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    validator: _validatePassword,
                    onChanged: (value) {
                      // Clear any error messages as the user types
                      if (_formKey.currentState != null) {
                        _formKey.currentState!.validate();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _handleLogin(userType),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(userType),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _getButtonIcon(userType),
                                const SizedBox(width: 8),
                                Text(
                                  'Login as $userType',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(String userType) {
    switch (userType) {
      case 'Member':
        return 'Access your personalized workout plans, track progress, and connect with trainers.';
      case 'Trainer':
        return 'Manage your clients, create workout plans, and track their progress.';
      case 'Trainee':
        return 'Connect with your personal trainer, access assigned workouts, and track your fitness journey.';
      default:
        return '';
    }
  }

  Color _getButtonColor(String userType) {
    switch (userType) {
      case 'Member':
        return Colors.blue.shade700;
      case 'Trainer':
        return Colors.green.shade700;
      case 'Trainee':
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  Icon _getButtonIcon(String userType) {
    switch (userType) {
      case 'Member':
        return const Icon(Icons.login);
      case 'Trainer':
        return const Icon(Icons.sports_gymnastics);
      case 'Trainee':
        return const Icon(Icons.directions_run);
      default:
        return const Icon(Icons.login);
    }
  }

  Future<void> _handleLogin(String userType) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String dbPath;

    // Determine database path
    switch (userType.toLowerCase()) {
      case 'member':
        dbPath = 'users/members';
        break;
      case 'trainer':
        dbPath = 'users/trainers';
        break;
      case 'trainee':
        dbPath = 'users/trainees';
        break;
      default:
        dbPath = 'users/members';
    }

    try {
      final db = FirebaseDatabase.instance.ref();
      final snapshot = await db.child(dbPath).orderByChild('email').equalTo(email).get();

      setState(() => _isLoading = false);

      if (!snapshot.exists) {
        _showError('No $userType found with this email.');
        return;
      }

      final userMap = (snapshot.value as Map).values.first as Map;
      if (userMap['password'] != password) {
        _showError('Incorrect password.');
        return;
      }

      // Save login info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', userType.toLowerCase());
      await prefs.setString('email', email);

      // Navigate to the correct home page
      switch (userType.toLowerCase()) {
        case 'member':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          break;
        case 'trainer':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TrainerHomePage()),
          );
          break;
        case 'trainee':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TraineeHomePage()),
          );
          break;
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Login failed: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.of(context).pushReplacementNamed('/login');
} 