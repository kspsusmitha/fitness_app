import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Login Method
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final userSnapshot = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (userSnapshot.exists) {
        final users = userSnapshot.value as Map<dynamic, dynamic>;
        final user = users.values.first as Map<dynamic, dynamic>;
        
        if (user['password'] == password) {
          return {
            'userId': users.keys.first,
            'userType': user['userType'], // 'trainer' or 'trainee'
            'name': user['name'],
            'email': user['email'],
          };
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Registration Methods
  Future<Map<String, dynamic>?> registerTrainer({
    required String name,
    required String email,
    required String password,
    required String phone,
    List<String>? specializations,
    List<Map<String, dynamic>>? certifications,
  }) async {
    try {
      // Check if email exists
      final emailCheck = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (emailCheck.exists) {
        return {'error': 'Email already exists'};
      }

      final newTrainerRef = _database.child('users/trainers').push();
      final trainerId = newTrainerRef.key!;

      final trainerData = {
        'name': name,
        'email': email,
        'password': password, // In production, use proper password hashing
        'phone': phone,
        'userType': 'trainer',
        'specializations': specializations ?? [],
        'certifications': certifications ?? [],
        'createdAt': ServerValue.timestamp,
      };

      await newTrainerRef.set(trainerData);

      return {
        'userId': trainerId,
        'userType': 'trainer',
        'name': name,
        'email': email,
      };
    } catch (e) {
      print('Registration error: $e');
      return {'error': 'Registration failed'};
    }
  }

  Future<Map<String, dynamic>?> registerTrainee({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      // Check if email exists
      final emailCheck = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (emailCheck.exists) {
        return {'error': 'Email already exists'};
      }

      final newTraineeRef = _database.child('users/trainees').push();
      final traineeId = newTraineeRef.key!;

      final traineeData = {
        'name': name,
        'email': email,
        'password': password, // In production, use proper password hashing
        'phone': phone,
        'userType': 'trainee',
        'createdAt': ServerValue.timestamp,
        'progress': {
          'workouts': {
            'completed': 0,
            'total': 0,
          },
          'weight': {},
          'goals': {},
        },
      };

      await newTraineeRef.set(traineeData);

      return {
        'userId': traineeId,
        'userType': 'trainee',
        'name': name,
        'email': email,
      };
    } catch (e) {
      print('Registration error: $e');
      return {'error': 'Registration failed'};
    }
  }

  // Password Reset Method
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final userSnapshot = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (userSnapshot.exists) {
        // Here you would implement your password reset logic
        // For now, we'll just return a success message
        return {'success': 'Password reset instructions sent to email'};
      }
      return {'error': 'Email not found'};
    } catch (e) {
      return {'error': 'Password reset failed'};
    }
  }

  // Logout Method
  Future<void> logout() async {
    // Clear any local storage or state if needed
  }
} 