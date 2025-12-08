import 'package:bienestar_integral_app/features/kitchen_schedule/domain/repository/kitchen_schedule_repository.dart';

class CreateKitchenSchedules {
  final KitchenScheduleRepository repository;

  CreateKitchenSchedules(this.repository);

  Future<void> call({
    required int kitchenId,
    required String weekStart,
    required String weekEnd,
    required String weekendStart,
    required String weekendEnd,
  }) async {
    await repository.createSchedules(
      kitchenId: kitchenId,
      weekStart: weekStart,
      weekEnd: weekEnd,
      weekendStart: weekendStart,
      weekendEnd: weekendEnd,
    );
  }
}