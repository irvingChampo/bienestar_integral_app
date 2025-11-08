import 'package:flutter/material.dart';

// CAMBIO 1: Se añade un enum para manejar los roles de usuario.
enum UserRole { unknown, volunteer, admin }

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unauthenticated;

  // CAMBIO 2: Se añade la propiedad para guardar el rol del usuario.
  UserRole _userRole = UserRole.unknown;

  AuthStatus get authStatus => _authStatus;

  // CAMBIO 3: Se añade el getter para poder acceder al rol desde el router.
  UserRole get userRole => _userRole;

  Future<void> checkAuthStatus() async {
    // CAMBIO: Se elimina el retraso.
    // En una app real, aquí leerías un token de SharedPreferences.
    // Si el token existe y es válido, llamarías a login().
    // Como no hay token, el estado se mantiene como 'unauthenticated'.
  }

  // CAMBIO 4: El método login ahora acepta y guarda un rol.
  // Ya no es `void login()`, ahora es `void login(UserRole role)`.
  void login(UserRole role) {
    _authStatus = AuthStatus.authenticated;
    _userRole = role; // Se guarda el rol del usuario.
    notifyListeners();
  }

  // CAMBIO 5: El método logout ahora también resetea el rol del usuario.
  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    _userRole = UserRole.unknown; // Se resetea el rol.
    notifyListeners();
  }
}