abstract class KitchenScheduleRepository {
  Future<void> createSchedules({
    required int kitchenId,
    required String weekStart,
    required String weekEnd,
    required String weekendStart,
    required String weekendEnd,
  });
}