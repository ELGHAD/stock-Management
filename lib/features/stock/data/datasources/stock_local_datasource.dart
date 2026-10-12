import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_management/core/utils/constants.dart';
import 'package:stock_management/features/stock/data/models/stock_movement_model.dart';

abstract class StockLocalDataSource {
  Future<List<StockMovementModel>> getStockMovements();
  Future<void> cacheStockMovements(List<StockMovementModel> movements);
  Future<void> addStockMovement(StockMovementModel movement);
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  @override
  Future<List<StockMovementModel>> getStockMovements() async {
    final box = await Hive.openBox(AppConstants.stockMovementsBox);
    final movements = <StockMovementModel>[];
    for (var key in box.keys) {
      final data = box.get(key) as Map<dynamic, dynamic>;
      movements.add(StockMovementModel.fromHive(data));
    }
    movements.sort((a, b) => b.date.compareTo(a.date));
    return movements;
  }

  @override
  Future<void> cacheStockMovements(List<StockMovementModel> movements) async {
    final box = await Hive.openBox(AppConstants.stockMovementsBox);
    await box.clear();
    for (var movement in movements) {
      await box.put(movement.id, movement.toHive());
    }
  }

  @override
  Future<void> addStockMovement(StockMovementModel movement) async {
    final box = await Hive.openBox(AppConstants.stockMovementsBox);
    await box.put(movement.id, movement.toHive());
  }
}

