import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

// Caso de uso para establecer (crear) la disponibilidad de un día.
class CreateAvailabilitySlot {
  final ProfileRepository repository;

  CreateAvailabilitySlot(this.repository);

  Future<void> call(Map<String, dynamic> slotData) async {
    await repository.createAvailabilitySlot(slotData);
  }
}

// Caso de uso para actualizar la disponibilidad de un día existente.
class UpdateAvailabilitySlot {
  final ProfileRepository repository;

  UpdateAvailabilitySlot(this.repository);

  Future<void> call(String dayOfWeek, Map<String, dynamic> slotData) async {
    await repository.updateAvailabilitySlot(dayOfWeek, slotData);
  }
}

// Caso de uso para eliminar la disponibilidad de un solo día.
class RemoveAvailabilitySlot {
  final ProfileRepository repository;

  RemoveAvailabilitySlot(this.repository);

  Future<void> call(String dayOfWeek) async {
    await repository.removeAvailabilitySlot(dayOfWeek);
  }
}