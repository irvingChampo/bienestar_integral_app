import 'package:bienestar_integral_app/features/kitchen_schedule/data/datasource/kitchen_schedule_datasource.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/domain/repository/kitchen_schedule_repository.dart';

class KitchenScheduleRepositoryImpl implements KitchenScheduleRepository {
  final KitchenScheduleDatasource datasource;

  KitchenScheduleRepositoryImpl({required this.datasource});

  @override
  Future<void> createSchedules({
    required int kitchenId,
    required String weekStart,
    required String weekEnd,
    required String weekendStart,
    required String weekendEnd,
  }) async {
    try {
      await datasource.createSchedules(
        kitchenId: kitchenId,
        weekStart: weekStart,
        weekEnd: weekEnd,
        weekendStart: weekendStart,
        weekendEnd: weekendEnd,
      );
    } catch (e) {
      rethrow;
    }
  }
}