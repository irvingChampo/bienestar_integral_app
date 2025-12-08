import 'package:http/http.dart' as http;

// Implementación del patrón Singleton para el cliente HTTP.
// Esto asegura que solo una instancia de http.Client sea creada y reutilizada
// a través de toda la aplicación, lo cual es más eficiente.
class HttpClient {
  // 1. Instancia privada y estática.
  static final HttpClient _instance = HttpClient._internal();

  // 2. Cliente HTTP que será compartido.
  late final http.Client client;

  // 3. Factory constructor que siempre retorna la misma instancia `_instance`.
  factory HttpClient() {
    return _instance;
  }

  // 4. Constructor privado para inicializar el cliente.
  HttpClient._internal() {
    client = http.Client();
  }

  // (Opcional) Método para cerrar el cliente cuando la app se destruye.
  void dispose() {
    client.close();
  }
}