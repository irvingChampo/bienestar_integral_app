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

  // Se inicializa el caso de uso con todas sus dependencias.
  // Esto encapsula toda la lógica de login fuera del provider.
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
      // 1. Llama al caso de uso para obtener la respuesta de la API.
      final authResponse = await _loginUser(email, password);

      // 2. Guarda los datos de la sesión de forma persistente.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', authResponse.accessToken);

      // 3. Determina el rol del usuario a partir de la respuesta.
      final userRole = authResponse.roles.any((role) => role.toLowerCase() == 'admin')
          ? UserRole.admin
          : UserRole.volunteer;

      // 4. Guarda el rol para que pueda ser recuperado al reiniciar la app.
      await prefs.setString('userRole', userRole == UserRole.admin ? 'admin' : 'volunteer');

      // 5. Actualiza el estado en memoria de la aplicación para la sesión actual.
      _appState.login(userRole);

    } on ServerException catch (e) {
      _errorMessage = e.message;
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
    // Al cerrar sesión, es crucial limpiar los datos persistentes.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userRole');

    // Actualiza el estado en memoria para redirigir al login.
    _appState.logout();
  }
}