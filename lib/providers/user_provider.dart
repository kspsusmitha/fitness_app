import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? userId;
  String? userType;
  String? name;
  String? email;
  bool isLoggedIn = false;

  Future<void> setUser(Map<String, dynamic> userData) async {
    userId = userData['userId'];
    userType = userData['userType'];
    name = userData['name'];
    email = userData['email'];
    isLoggedIn = true;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId!);
    await prefs.setString('userType', userType!);
    await prefs.setString('name', name!);
    await prefs.setString('email', email!);
    await prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      userId = prefs.getString('userId');
      userType = prefs.getString('userType');
      name = prefs.getString('name');
      email = prefs.getString('email');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    userId = null;
    userType = null;
    name = null;
    email = null;
    isLoggedIn = false;
    
    notifyListeners();
  }
}