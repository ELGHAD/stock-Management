import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';
import 'package:stock_management/features/stock/domain/repositories/stock_repository.dart';

class GetStockMovementsUseCase {
  final StockRepository _repository;

  GetStockMovementsUseCase(this._repository);

  Future<List<StockMovement>> call() async {
    return await _repository.getStockMovements();
  }
}

