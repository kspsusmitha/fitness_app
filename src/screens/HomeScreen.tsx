import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

const HomeScreen = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View style={styles.header}>
          <Text style={styles.title}>Fitness Management System</Text>
        </View>
        
        <View style={styles.statsContainer}>
          <View style={styles.statCard}>
            <Text style={styles.statTitle}>Daily Calories</Text>
            <Text style={styles.statValue}>2,400</Text>
          </View>
          
          <View style={styles.statCard}>
            <Text style={styles.statTitle}>Protein Intake</Text>
            <Text style={styles.statValue}>120g</Text>
          </View>
        </View>

        <View style={styles.upcomingClasses}>
          <Text style={styles.sectionTitle}>Upcoming Classes</Text>
          {/* Class list will go here */}
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
  statsContainer: {
    flexDirection: 'row',
    padding: 20,
    justifyContent: 'space-between',
  },
  statCard: {
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 10,
    width: '48%',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  statTitle: {
    fontSize: 16,
    color: '#666',
  },
  statValue: {
    fontSize: 24,
    fontWeight: 'bold',
    marginTop: 5,
  },
  upcomingClasses: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 10,
  },
});

export default HomeScreen; 