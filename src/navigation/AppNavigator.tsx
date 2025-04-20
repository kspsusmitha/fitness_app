import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';

import HomeScreen from '../screens/HomeScreen';
import WorkoutScreen from '../screens/WorkoutScreen';
import MembershipScreen from '../screens/MembershipScreen';
import ProfileScreen from '../screens/ProfileScreen';
import ShopScreen from '../screens/ShopScreen';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

const MainTabs = () => {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Workout" component={WorkoutScreen} />
      <Tab.Screen name="Membership" component={MembershipScreen} />
      <Tab.Screen name="Shop" component={ShopScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  );
};

const AppNavigator = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen 
          name="MainTabs" 
          component={MainTabs} 
          options={{ headerShown: false }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator; 