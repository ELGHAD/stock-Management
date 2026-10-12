import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';
import 'package:stock_management/features/stock/domain/repositories/stock_repository.dart';

class AddStockMovementUseCase {
  final StockRepository _repository;

  AddStockMovementUseCase(this._repository);

  Future<StockMovement> call(StockMovement movement) async {
    return await _repository.addStockMovement(movement);
  }
}

