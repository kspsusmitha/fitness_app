import 'package:firebase_database/firebase_database.dart';

class TrainerService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // 1. Create or update trainer profile
  Future<void> setTrainerProfile(String trainerId, Map<String, dynamic> profileData) async {
    await _db.child('users/trainers/$trainerId').update(profileData);
  }

  // 2. Set or update specializations
  Future<void> setSpecializations(String trainerId, List<String> specializations) async {
    await _db.child('users/trainers/$trainerId/specializations').set(specializations);
  }

  // 3. Add or update certifications
  Future<void> setCertifications(String trainerId, List<Map<String, dynamic>> certifications) async {
    await _db.child('users/trainers/$trainerId/certifications').set(certifications);
  }

  // 4. Assign a client to trainer
  Future<void> assignClient(String trainerId, String clientId) async {
    await _db.child('users/trainers/$trainerId/clients/$clientId').set(true);
  }

  // 5. Create or update a workout plan
  Future<void> setWorkoutPlan(String trainerId, String planId, Map<String, dynamic> planData) async {
    await _db.child('users/trainers/$trainerId/workoutPlans/$planId').set(planData);
  }

  // 6. Set trainer's availability
  Future<void> setAvailability(String trainerId, Map<String, dynamic> availability) async {
    await _db.child('users/trainers/$trainerId/availability').set(availability);
  }

  // 7. Add notification token
  Future<void> setNotificationToken(String trainerId, String token) async {
    await _db.child('users/trainers/$trainerId/notificationToken').set(token);
  }
}