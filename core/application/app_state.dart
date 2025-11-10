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
    // Se llama a checkAuthStatus desde el constructor para que se ejecute al crear la instancia.
    checkAuthStatus();
  }

  // --- LÓGICA CLAVE AÑADIDA AQUÍ ---
  Future<void> checkAuthStatus() async {
    // Marcamos el estado como `unknown` mientras verificamos.
    _authStatus = AuthStatus.unknown;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Opcional: para mostrar un splash screen

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      // Si no hay token, el usuario no está autenticado.
      _authStatus = AuthStatus.unauthenticated;
    } else {
      // Si hay un token, asumimos que el usuario está autenticado.
      // NOTA: Una app de producción aquí validaría el token contra la API.
      // Por ahora, solo lo comprobamos. También necesitamos recuperar el rol.
      _authStatus = AuthStatus.authenticated;

      // Aquí podrías decodificar el token para obtener el rol si lo guardaste,
      // o guardarlo en SharedPreferences durante el login.
      // Por simplicidad, asumiremos un rol por ahora o lo leeremos si lo guardamos.
      // Vamos a guardar el rol en el login para que esto funcione.
      final roleString = prefs.getString('userRole');
      if (roleString == 'admin') {
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