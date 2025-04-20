import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { User } from '../types';

const sampleUser: User = {
  id: '1',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'member',
  profilePicture: 'https://example.com/profile.jpg',
};

const ProfileScreen = () => {
  const [distance, setDistance] = useState('');
  const [foodProtein, setFoodProtein] = useState('');
  const [caloriesBurned, setCaloriesBurned] = useState(0);
  const [totalProtein, setTotalProtein] = useState(0);

  const calculateCaloriesBurned = () => {
    // Simple calculation: 1km walking ≈ 60 calories burned
    const distanceNum = parseFloat(distance);
    if (!isNaN(distanceNum)) {
      setCaloriesBurned(Math.round(distanceNum * 60));
    }
  };

  const addProteinIntake = () => {
    const proteinNum = parseFloat(foodProtein);
    if (!isNaN(proteinNum)) {
      setTotalProtein(prev => prev + proteinNum);
      setFoodProtein('');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View style={styles.header}>
          <Text style={styles.title}>Profile</Text>
        </View>

        <View style={styles.profileSection}>
          <Text style={styles.name}>{sampleUser.name}</Text>
          <Text style={styles.email}>{sampleUser.email}</Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Calorie Burn Calculator</Text>
          <View style={styles.inputContainer}>
            <TextInput
              style={styles.input}
              placeholder="Enter distance (km)"
              value={distance}
              onChangeText={setDistance}
              keyboardType="numeric"
            />
            <TouchableOpacity 
              style={styles.button}
              onPress={calculateCaloriesBurned}
            >
              <Text style={styles.buttonText}>Calculate</Text>
            </TouchableOpacity>
          </View>
          <Text style={styles.result}>
            Calories Burned: {caloriesBurned} cal
          </Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Protein Calculator</Text>
          <View style={styles.inputContainer}>
            <TextInput
              style={styles.input}
              placeholder="Enter protein amount (g)"
              value={foodProtein}
              onChangeText={setFoodProtein}
              keyboardType="numeric"
            />
            <TouchableOpacity 
              style={styles.button}
              onPress={addProteinIntake}
            >
              <Text style={styles.buttonText}>Add</Text>
            </TouchableOpacity>
          </View>
          <Text style={styles.result}>
            Total Protein Today: {totalProtein}g
          </Text>
        </View>
      </ScrollView>
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
  profileSection: {
    backgroundColor: '#fff',
    padding: 20,
    marginBottom: 20,
    alignItems: 'center',
  },
  name: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  email: {
    fontSize: 16,
    color: '#666',
  },
  section: {
    backgroundColor: '#fff',
    padding: 20,
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  inputContainer: {
    flexDirection: 'row',
    marginBottom: 16,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    marginRight: 12,
  },
  button: {
    backgroundColor: '#2196F3',
    padding: 12,
    borderRadius: 8,
    justifyContent: 'center',
  },
  buttonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
  result: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#2196F3',
  },
});

export default ProfileScreen; 