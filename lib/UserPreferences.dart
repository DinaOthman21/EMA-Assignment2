import 'package:assignment2/JSON/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id ?? 0);
    await prefs.setString('userName', user.userName ?? '');
    await prefs.setString('userEmail', user.userEmail ?? '');
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId == null) {
      return null; // No user found
    }

    String? userName = prefs.getString('userName');
    String? userEmail = prefs.getString('userEmail');

    return User(
      id: userId,
      userName: userName,
      userEmail: userEmail,
    );
  }

  Future<void> setAuthenticated(bool isAuthenticated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', isAuthenticated);
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored data
  }
}