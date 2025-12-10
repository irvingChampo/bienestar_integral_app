import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart';
import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class GetUnits {
  final InventoryRepository repository;
  GetUnits(this.repository);

  Future<List<Unit>> call() async {
    return await repository.getUnits();
  }
}