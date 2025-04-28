import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Login Method
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      // First find which type of user is trying to login
      String? userType;
      Map<dynamic, dynamic>? userData;

      // Check in members
      final memberSnapshot = await _database
          .child('users/members')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (memberSnapshot.exists) {
        userType = 'member';
        userData = memberSnapshot.value as Map<dynamic, dynamic>;
      } else {
        // Check in trainers
        final trainerSnapshot = await _database
            .child('users/trainers')
            .orderByChild('email')
            .equalTo(email)
            .get();

        if (trainerSnapshot.exists) {
          userType = 'trainer';
          userData = trainerSnapshot.value as Map<dynamic, dynamic>;
        } else {
          // Check in trainees
          final traineeSnapshot = await _database
              .child('users/trainees')
              .orderByChild('email')
              .equalTo(email)
              .get();

          if (traineeSnapshot.exists) {
            userType = 'trainee';
            userData = traineeSnapshot.value as Map<dynamic, dynamic>;
          }
        }
      }

      // If user is found
      if (userType != null && userData != null) {
        final user = userData.values.first as Map<dynamic, dynamic>;
        
        if (user['password'] == password) {
          // Update last login timestamp
          await _database
              .child('users/${userType}s/${userData.keys.first}')
              .update({'lastLogin': ServerValue.timestamp});

          return {
            'userId': userData.keys.first,
            'userType': userType,
            'name': user['name'],
            'email': user['email'],
          };
        } else {
          return {'error': 'Invalid password'};
        }
      }

      // If email not found in any category
      return {'error': 'No account found with this email'};

    } on FirebaseException catch (e) {
      print('Login error: ${e.message}');
      return {'error': e.message ?? 'Login failed'};
    } catch (e) {
      print('Login error: $e');
      return {'error': 'Login failed: $e'};
    }
  }

  // Add this helper method to check email existence
  Future<bool> _isEmailExists(String email) async {
    // Check in members
    final memberSnapshot = await _database
        .child('users/members')
        .orderByChild('email')
        .equalTo(email)
        .get();

    if (memberSnapshot.exists) return true;

    // Check in trainers
    final trainerSnapshot = await _database
        .child('users/trainers')
        .orderByChild('email')
        .equalTo(email)
        .get();

    if (trainerSnapshot.exists) return true;

    // Check in trainees
    final traineeSnapshot = await _database
        .child('users/trainees')
        .orderByChild('email')
        .equalTo(email)
        .get();

    return traineeSnapshot.exists;
  }

  // Registration Methods
  Future<Map<String, dynamic>?> registerTrainer({
    required String name,
    required String email,
    required String password,
    required String phone,
    List<String>? specializations,
  }) async {
    try {
      // Check if email exists
      if (await _isEmailExists(email)) {
        return {'error': 'Email already exists'};
      }

      final newTrainerRef = _database.child('users/trainers').push();
      final trainerId = newTrainerRef.key!;

      final trainerData = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'userType': 'trainer',
        'specializations': specializations ?? [],
        'certifications': [],
        'createdAt': ServerValue.timestamp,
        'lastLogin': ServerValue.timestamp,
        'rating': 0,
        'totalClients': 0,
        'activeClients': 0,
        'workoutPlans': {},
        'availability': {
          'monday': {'start': '09:00', 'end': '17:00'},
          'tuesday': {'start': '09:00', 'end': '17:00'},
          'wednesday': {'start': '09:00', 'end': '17:00'},
          'thursday': {'start': '09:00', 'end': '17:00'},
          'friday': {'start': '09:00', 'end': '17:00'},
        },
      };

      await newTrainerRef.set(trainerData);

      return {
        'userId': trainerId,
        'userType': 'trainer',
        'name': name,
        'email': email,
      };
    } on FirebaseException catch (e) {
      print('Registration error: ${e.message}');
      return {'error': e.message ?? 'Registration failed'};
    } catch (e) {
      print('Registration error: $e');
      return {'error': 'Registration failed: $e'};
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
      if (await _isEmailExists(email)) {
        return {'error': 'Email already exists'};
      }

      final newTraineeRef = _database.child('users/trainees').push();
      final traineeId = newTraineeRef.key!;

      final traineeData = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'userType': 'trainee',
        'createdAt': ServerValue.timestamp,
        'lastLogin': ServerValue.timestamp,
        'trainerId': null,  // Will be set when assigned to a trainer
        'progress': {
          'workouts': {
            'completed': 0,
            'total': 0,
          },
          'weight': {
            'current': null,
            'goal': null,
            'history': {},
          },
          'goals': {
            'primary': null,
            'achieved': 0,
            'total': 0,
          },
        },
        'subscriptionStatus': 'active',
        'workoutPlans': {},
        'dietPlan': null,
      };

      await newTraineeRef.set(traineeData);

      return {
        'userId': traineeId,
        'userType': 'trainee',
        'name': name,
        'email': email,
      };
    } on FirebaseException catch (e) {
      print('Registration error: ${e.message}');
      return {'error': e.message ?? 'Registration failed'};
    } catch (e) {
      print('Registration error: $e');
      return {'error': 'Registration failed: $e'};
    }
  }

  Future<Map<String, dynamic>?> registerMember({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      // Check if email exists
      if (await _isEmailExists(email)) {
        return {'error': 'Email already exists'};
      }

      final newMemberRef = _database.child('users/members').push();
      final memberId = newMemberRef.key!;

      final memberData = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'userType': 'member',
        'createdAt': ServerValue.timestamp,
        'progress': {
          'workouts': {
            'completed': 0,
            'total': 0,
          },
          'weight': {},
          'goals': {},
        },
        'subscriptionStatus': 'active',
        'lastLogin': ServerValue.timestamp,
      };

      await newMemberRef.set(memberData);

      return {
        'userId': memberId,
        'userType': 'member',
        'name': name,
        'email': email,
      };
    } on FirebaseException catch (e) {
      print('Registration error: ${e.message}');
      return {'error': e.message ?? 'Registration failed'};
    } catch (e) {
      print('Registration error: $e');
      return {'error': 'Registration failed: $e'};
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
    } on FirebaseException catch (e) {
      return {'error': e.message ?? 'Password reset failed'};
    } catch (e) {
      return {'error': 'Password reset failed: $e'};
    }
  }

  // Logout Method
  Future<void> logout() async {
    // Clear any local storage or state if needed
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId, String userType) async {
    try {
      final snapshot = await _database
          .child('users/${userType}s/$userId')
          .get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(String userId, String userType, Map<String, dynamic> updates) async {
    try {
      await _database
          .child('users/${userType}s/$userId')
          .update(updates);
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
} 