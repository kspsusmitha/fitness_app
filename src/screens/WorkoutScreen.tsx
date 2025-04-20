import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Workout } from '../types';

const sampleWorkouts: Workout[] = [
  {
    id: '1',
    name: 'Full Body Workout',
    description: 'Complete body workout including cardio and strength training',
    duration: 60,
    caloriesBurn: 500,
    difficulty: 'intermediate',
  },
  {
    id: '2',
    name: 'HIIT Training',
    description: 'High-intensity interval training for maximum calorie burn',
    duration: 30,
    caloriesBurn: 400,
    difficulty: 'advanced',
  },
];

const WorkoutScreen = () => {
  const renderWorkoutCard = ({ item }: { item: Workout }) => (
    <TouchableOpacity style={styles.workoutCard}>
      <Text style={styles.workoutName}>{item.name}</Text>
      <Text style={styles.workoutDescription}>{item.description}</Text>
      <View style={styles.workoutDetails}>
        <Text style={styles.detailText}>{item.duration} mins</Text>
        <Text style={styles.detailText}>{item.caloriesBurn} cal</Text>
        <Text style={[styles.detailText, styles.difficulty(item.difficulty)]}>
          {item.difficulty}
        </Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Workouts</Text>
      </View>
      <FlatList
        data={sampleWorkouts}
        renderItem={renderWorkoutCard}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContainer}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  listContainer: {
    padding: 16,
  },
  workoutCard: {
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  workoutName: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  workoutDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 12,
  },
  workoutDetails: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    borderTopWidth: 1,
    borderTopColor: '#eee',
    paddingTop: 12,
  },
  detailText: {
    fontSize: 14,
    color: '#666',
  },
  difficulty: (level: string) => ({
    color: level === 'beginner' ? '#4CAF50' : level === 'intermediate' ? '#FF9800' : '#F44336',
    fontWeight: 'bold',
  }),
});

export default WorkoutScreen; 