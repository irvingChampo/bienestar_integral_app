import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_kitchen_details.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_kitchen_schedules.dart'; // Asegúrate de tener este import
import 'package:bienestar_integral_app/features/home/domain/usecase/get_my_kitchen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AdminHomeStatus { initial, loading, success, error }

class AdminHomeProvider extends ChangeNotifier {
  late final GetMyKitchen _getMyKitchen;
  late final GetKitchenDetails _getKitchenDetails;
  late final GetKitchenSchedules _getKitchenSchedules; // Declarada

  AdminHomeStatus _status = AdminHomeStatus.initial;
  String? _errorMessage;
  KitchenDetail? _kitchen;

  bool _needsScheduleSetup = false;

  AdminHomeProvider() {
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);

    _getMyKitchen = GetMyKitchen(repository);
    _getKitchenDetails = GetKitchenDetails(repository);

    // --- 🔴 ESTA ES LA LÍNEA QUE FALTABA ---
    _getKitchenSchedules = GetKitchenSchedules(repository);
    // ---------------------------------------
  }

  AdminHomeStatus get status => _status;
  String? get errorMessage => _errorMessage;
  KitchenDetail? get kitchen => _kitchen;
  bool get needsScheduleSetup => _needsScheduleSetup;

  Future<void> loadAdminKitchen() async {
    _status = AdminHomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('🏁 [PROVIDER] Iniciando carga de cocina...');

      // 1. OBTENER ID (/me)
      final basicInfo = await _getMyKitchen();
      final realKitchenId = basicInfo.id;
      debugPrint('✅ [PROVIDER] ID: $realKitchenId');

      // 2. OBTENER DETALLES (/kitchens/:id)
      // Trae nombre, dirección, dueño, etc. (pero suele venir sin schedules)
      final detailsWithoutSchedules = await _getKitchenDetails(realKitchenId);

      // 3. OBTENER HORARIOS (/kitchens/:id/schedules)
      // Este endpoint específico trae la lista real
      final schedules = await _getKitchenSchedules(realKitchenId);
      debugPrint('✅ [PROVIDER] Horarios descargados: ${schedules.length}');

      // 4. UNIR DATOS
      // Combinamos la info detallada con la lista de horarios
      _kitchen = KitchenDetail(
        id: detailsWithoutSchedules.id,
        name: detailsWithoutSchedules.name,
        description: detailsWithoutSchedules.description,
        isActive: detailsWithoutSchedules.isActive,
        contactPhone: detailsWithoutSchedules.contactPhone,
        contactEmail: detailsWithoutSchedules.contactEmail,
        location: detailsWithoutSchedules.location,
        isSubscribed: detailsWithoutSchedules.isSubscribed,
        ownerName: detailsWithoutSchedules.ownerName,
        schedules: schedules, // <-- Insertamos la lista obtenida en el paso 3
      );

      // 5. VERIFICAR
      if (_kitchen!.schedules.isEmpty) {
        debugPrint('⚠️ [PROVIDER] Lista vacía. Setup requerido.');
        _needsScheduleSetup = true;
      } else {
        debugPrint('✅ [PROVIDER] Todo listo. Mostrando Home.');
        _needsScheduleSetup = false;
      }

      _status = AdminHomeStatus.success;
    } catch (e) {
      debugPrint('❌ [PROVIDER] Error: $e');
      _errorMessage = e.toString();
      _status = AdminHomeStatus.error;
    }
    notifyListeners();
  }
}