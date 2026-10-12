import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';

abstract class StockRepository {
  Future<List<StockMovement>> getStockMovements();
  Future<StockMovement> addStockMovement(StockMovement movement);
}

