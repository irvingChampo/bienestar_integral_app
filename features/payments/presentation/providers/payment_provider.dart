import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/payments/data/datasource/payment_datasource.dart';
import 'package:bienestar_integral_app/features/payments/data/repository/payment_repository_impl.dart';
import 'package:bienestar_integral_app/features/payments/domain/usecase/create_donation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum PaymentStatus { initial, loading, success, error }

class PaymentProvider extends ChangeNotifier {
  late final CreateDonation _createDonation;

  PaymentStatus _status = PaymentStatus.initial;
  String? _errorMessage;

  PaymentProvider() {
    // Inicialización de dependencias (Datasource -> Repository -> UseCase)
    final datasource = PaymentDatasourceImpl(client: http.Client());
    final repository = PaymentRepositoryImpl(datasource: datasource);
    _createDonation = CreateDonation(repository);
  }

  PaymentStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == PaymentStatus.loading;

  /// Realiza la donación:
  /// 1. Contacta al backend para crear la intención de pago.
  /// 2. Recibe la URL de Stripe.
  /// 3. Abre el navegador externo para que el usuario pague.
  Future<bool> makeDonation({
    required int kitchenId,
    required double amount,
    String? description,
  }) async {
    _status = PaymentStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Obtener la URL de pago
      final paymentIntent = await _createDonation(
        kitchenId: kitchenId,
        amount: amount,
        description: description,
      );

      // 2. Abrir la URL
      await _launchPaymentUrl(paymentIntent.paymentUrl);

      _status = PaymentStatus.success;
      notifyListeners();
      return true;

    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = PaymentStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = PaymentStatus.error;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al iniciar la donación.';
      _status = PaymentStatus.error;
    } finally {
      // Aseguramos notificar para detener spinners si hubo error
      if (_status != PaymentStatus.success) {
        notifyListeners();
      }
    }
    return false;
  }

  Future<void> _launchPaymentUrl(String urlString) async {
    if (urlString.isEmpty) {
      throw ServerException("La URL de pago recibida no es válida.");
    }

    final uri = Uri.parse(urlString);

    // Usamos mode: LaunchMode.externalApplication para asegurar que abra el navegador del sistema
    // o la app de Stripe si estuviera instalada (aunque es checkout web).
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw ServerException("No se pudo abrir el navegador para completar el pago.");
    }
  }
}