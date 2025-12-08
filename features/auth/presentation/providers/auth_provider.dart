import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:bienestar_integral_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:bienestar_integral_app/features/auth/domain/usecase/login_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AppState _appState;

  late final LoginUser _loginUser = LoginUser(
    AuthRepositoryImpl(
      datasource: AuthDatasourceImpl(client: http.Client()),
    ),
  );

  AuthProvider(this._appState);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _loginUser(email, password);

      // 1. Guardar Token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', authResponse.accessToken);

      // 2. Determinar Rol basado en la respuesta JSON (ej: ["Voluntario"])
      // Convertimos a minúsculas para comparar de forma segura
      bool isAdmin = false;

      if (authResponse.roles.isNotEmpty) {
        // Buscamos si alguno de los roles contiene la palabra "admin"
        isAdmin = authResponse.roles.any((role) =>
            role.toString().toLowerCase().contains('admin')
        );
      }

      // Definimos el UserRole interno
      final UserRole userRole = isAdmin ? UserRole.admin : UserRole.volunteer;

      // 3. Guardar Rol en SharedPreferences (como string simple)
      // Esto sirve para que AppState lo recupere al reiniciar la app
      await prefs.setString('userRole', isAdmin ? 'admin' : 'volunteer');

      // 4. Actualizar el estado global de la App (esto dispara la redirección)
      _appState.login(userRole);

    } on InvalidCredentialsException catch (e) {
      _errorMessage = e.message;
    } on ServerException catch (e) {
      _errorMessage = 'Ocurrió un error en el servidor: ${e.message}';
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Un error inesperado ocurrió.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userRole');
    _appState.logout();
  }
}