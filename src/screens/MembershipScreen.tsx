import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { MembershipPlan } from '../types';

const membershipPlans: MembershipPlan[] = [
  {
    id: '1',
    name: 'Basic Plan',
    duration: 1,
    price: 49.99,
    features: ['Access to gym equipment', 'Basic fitness assessment', 'Locker access'],
  },
  {
    id: '2',
    name: 'Premium Plan',
    duration: 3,
    price: 129.99,
    features: [
      'All Basic Plan features',
      'Personal trainer sessions',
      'Access to all classes',
      'Nutrition consultation',
    ],
  },
];

const MembershipScreen = () => {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Membership Plans</Text>
      </View>
      <ScrollView contentContainerStyle={styles.plansContainer}>
        {membershipPlans.map((plan) => (
          <View key={plan.id} style={styles.planCard}>
            <Text style={styles.planName}>{plan.name}</Text>
            <Text style={styles.planPrice}>${plan.price}/month</Text>
            <Text style={styles.planDuration}>{plan.duration} month minimum</Text>
            <View style={styles.featuresContainer}>
              {plan.features.map((feature, index) => (
                <Text key={index} style={styles.feature}>
                  • {feature}
                </Text>
              ))}
            </View>
            <TouchableOpacity style={styles.subscribeButton}>
              <Text style={styles.subscribeButtonText}>Subscribe Now</Text>
            </TouchableOpacity>
          </View>
        ))}
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
  plansContainer: {
    padding: 16,
  },
  planCard: {
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 20,
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
  planName: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  planPrice: {
    fontSize: 24,
    color: '#2196F3',
    fontWeight: 'bold',
    marginBottom: 4,
  },
  planDuration: {
    fontSize: 14,
    color: '#666',
    marginBottom: 16,
  },
  featuresContainer: {
    marginBottom: 20,
  },
  feature: {
    fontSize: 14,
    color: '#444',
    marginBottom: 8,
  },
  subscribeButton: {
    backgroundColor: '#2196F3',
    padding: 15,
    borderRadius: 8,
    alignItems: 'center',
  },
  subscribeButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default MembershipScreen; 