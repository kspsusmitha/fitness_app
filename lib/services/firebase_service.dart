import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Trainer Methods
  Future<void> createTrainer(String trainerId, Map<String, dynamic> trainerData) async {
    await _database.child('users/trainers/$trainerId').set(trainerData);
  }

  Future<void> updateTrainerProfile(String trainerId, Map<String, dynamic> updates) async {
    await _database.child('users/trainers/$trainerId/personalInfo').update(updates);
  }

  Future<void> assignClientToTrainer(String trainerId, String clientId) async {
    await _database.child('users/trainers/$trainerId/clients/$clientId').set(true);
  }

  // Trainee Methods
  Future<void> createTrainee(String traineeId, Map<String, dynamic> traineeData) async {
    await _database.child('users/trainees/$traineeId').set(traineeData);
  }

  Future<void> updateTraineeProgress(String traineeId, Map<String, dynamic> progress) async {
    await _database.child('users/trainees/$traineeId/progress').update(progress);
  }

  Future<void> assignWorkoutPlan(String traineeId, String planId, Map<String, dynamic> planData) async {
    await _database.child('users/trainees/$traineeId/assignedPlans/$planId').set(planData);
  }

  // Workout Plans Methods
  Future<void> createWorkoutPlan(String trainerId, String planId, Map<String, dynamic> planData) async {
    await _database.child('users/trainers/$trainerId/workoutPlans/$planId').set(planData);
  }

  // Diet Plans Methods
  Future<void> updateDietPlan(String traineeId, Map<String, dynamic> dietPlan) async {
    await _database.child('users/trainees/$traineeId/dietPlan').update(dietPlan);
  }

  // Progress Tracking Methods
  Future<void> logWeight(String traineeId, double weight) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _database.child('users/trainees/$traineeId/progress/weight/$timestamp').set({
      'value': weight,
      'unit': 'kg'
    });
  }

  Future<void> updateWorkoutProgress(String traineeId, String planId, double progress) async {
    await _database.child('users/trainees/$traineeId/assignedPlans/$planId/progress').set(progress);
  }

  // Stream Methods
  Stream<DatabaseEvent> getTraineeProgress(String traineeId) {
    return _database.child('users/trainees/$traineeId/progress').onValue;
  }

  Stream<DatabaseEvent> getTrainerClients(String trainerId) {
    return _database.child('users/trainers/$trainerId/clients').onValue;
  }

  Stream<DatabaseEvent> getAssignedWorkoutPlans(String traineeId) {
    return _database.child('users/trainees/$traineeId/assignedPlans').onValue;
  }
} 