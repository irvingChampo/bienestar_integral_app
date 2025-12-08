// core/error/exception.dart (ACTUALIZADO)

// Excepción para errores de lógica de negocio o respuestas no exitosas del servidor (ej: 401, 404, 500).
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// --- NUEVA EXCEPCIÓN AÑADIDA ---
// Excepción específica para cuando las credenciales de login son incorrectas.
// Hereda de ServerException para mantener la categorización.
class InvalidCredentialsException extends ServerException {
  InvalidCredentialsException(super.message);
}
// --- FIN DEL CAMBIO ---

// Excepción para errores de conectividad (ej: no hay internet, el DNS falla).
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}