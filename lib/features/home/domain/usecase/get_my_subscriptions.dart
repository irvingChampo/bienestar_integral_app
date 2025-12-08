import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetMySubscriptions {
  final KitchenRepository repository;

  GetMySubscriptions(this.repository);

  Future<List<int>> call() async {
    return await repository.getSubscribedKitchenIds();
  }
}