import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { unknown, volunteer, admin }
enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unknown;
  UserRole _userRole = UserRole.unknown;

  AuthStatus get authStatus => _authStatus;
  UserRole get userRole => _userRole;

  AppState() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final storedRole = prefs.getString('userRole'); // Recuperamos el rol guardado

    if (token == null || storedRole == null) {
      _authStatus = AuthStatus.unauthenticated;
      _userRole = UserRole.unknown;
    } else {
      _authStatus = AuthStatus.authenticated;

      // Restauramos el rol basado en lo que guardamos en el Login
      if (storedRole == 'admin') {
        _userRole = UserRole.admin;
      } else {
        _userRole = UserRole.volunteer;
      }
    }
    notifyListeners();
  }

  void login(UserRole role) {
    _authStatus = AuthStatus.authenticated;
    _userRole = role;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    _userRole = UserRole.unknown;
    notifyListeners();
  }
}