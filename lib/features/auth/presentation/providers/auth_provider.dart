import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:bienestar_integral_app/features/auth/data/models/auth_response_model.dart';
import 'package:bienestar_integral_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:bienestar_integral_app/features/auth/domain/usecase/login_user.dart';
import 'package:bienestar_integral_app/features/auth/domain/usecase/google_login_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// --- IMPORTANTE: AGREGAR ESTA LIBRERÍA ---
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AppState _appState;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Instancia de Firebase Auth para hacer el intercambio de tokens
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late final LoginUser _loginUser;
  late final GoogleLoginUser _googleLoginUser;

  AuthProvider(this._appState) {
    final datasource = AuthDatasourceImpl(client: http.Client());
    final repository = AuthRepositoryImpl(datasource: datasource);

    _loginUser = LoginUser(repository);
    _googleLoginUser = GoogleLoginUser(repository);
  }

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- LOGIN NORMAL ---
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _loginUser(email, password);
      await _handleSuccessfulLogin(authResponse.accessToken, authResponse.roles);

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

  // --- LOGIN CON GOOGLE (CORREGIDO) ---
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Iniciar flujo de Google (Nativo)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return null; // Usuario canceló
      }

      // 2. Obtener credenciales de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Crear credencial para Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Iniciar sesión en Firebase (EL PASO CLAVE QUE FALTABA)
      // Esto "canjea" el token de Google por uno de Firebase válido para tu proyecto.
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw ServerException('No se pudo autenticar con Firebase.');
      }

      // 5. Obtener el TOKEN DE FIREBASE (Este sí tiene el "aud" correcto)
      final String? firebaseToken = await firebaseUser.getIdToken();

      if (firebaseToken == null) {
        throw ServerException('No se pudo obtener el token de Firebase.');
      }

      // 6. Enviar al Backend (Ahora enviamos el token de Firebase, no el de Google)
      final response = await _googleLoginUser(firebaseToken);

      // 7. Analizar respuesta del Backend
      if (response['success'] == true) {
        final data = response['data'];

        if (data['isNewUser'] == true) {
          return data['prefillData'];
        } else {
          final loginData = data['loginData'];
          final authResponse = AuthResponseModel.fromJson(loginData);
          await _handleSuccessfulLogin(authResponse.accessToken, authResponse.roles);
          return null;
        }
      } else {
        throw ServerException(response['message'] ?? 'Error en autenticación con Google');
      }

    } catch (e) {
      _errorMessage = e.toString();
      // Cerramos sesión en ambos lados por si acaso
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  // --- MÉTODO PRIVADO ---
  Future<void> _handleSuccessfulLogin(String accessToken, List<dynamic> roles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);

    bool isAdmin = false;
    if (roles.isNotEmpty) {
      isAdmin = roles.any((role) =>
          role.toString().toLowerCase().contains('admin')
      );
    }

    final UserRole userRole = isAdmin ? UserRole.admin : UserRole.volunteer;
    await prefs.setString('userRole', isAdmin ? 'admin' : 'volunteer');

    _appState.login(userRole);
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userRole');

    await _googleSignIn.signOut();
    await _firebaseAuth.signOut(); // También cerramos Firebase

    _appState.logout();
  }
}