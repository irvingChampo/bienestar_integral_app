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
    _appState.login(); // Esto notificará a GoRouter para que redirija
    // notifyListeners() no es necesario aquí porque el cambio de estado de appState lo hará
  }
}