// Excepción para errores que ocurren en el servidor (ej: 404, 500, o errores de lógica de negocio).
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// Excepción para errores de conectividad (ej: no hay internet, el DNS falla).
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}