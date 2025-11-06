import 'package:flutter/material.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unauthenticated;

  AuthStatus get authStatus => _authStatus;

  Future<void> checkAuthStatus() async {
    // CAMBIO: Se elimina el retraso.
    // En una app real, aquí leerías un token de SharedPreferences.
    // Si el token existe y es válido, llamarías a login().
    // Como no hay token, el estado se mantiene como 'unauthenticated'.
  }

  void login() {
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}