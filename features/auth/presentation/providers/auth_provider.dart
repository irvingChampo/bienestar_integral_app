import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AppState _appState;
  AuthProvider(this._appState);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simula una llamada a la API
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;

    // --- CAMBIO PRINCIPAL AQUÍ ---
    // Ahora, en lugar de llamar a _appState.login() sin más,
    // determinamos el rol y se lo pasamos.
    if (email.trim().toLowerCase() == 'admin@bienestar.com') {
      _appState.login(UserRole.admin);
    } else {
      _appState.login(UserRole.volunteer);
    }
    // Ya no es necesario llamar a notifyListeners() aquí, porque
    // el cambio en appState se encarga de notificar a los listeners (como GoRouter).
  }
}