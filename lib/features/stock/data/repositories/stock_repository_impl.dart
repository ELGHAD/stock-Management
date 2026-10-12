import 'package:stock_management/features/stock/data/datasources/stock_local_datasource.dart';
import 'package:stock_management/features/stock/data/datasources/stock_remote_datasource.dart';
import 'package:stock_management/features/stock/data/models/stock_movement_model.dart';
import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';
import 'package:stock_management/features/stock/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource _remoteDataSource;
  final StockLocalDataSource _localDataSource;

  StockRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<List<StockMovement>> getStockMovements() async {
    // For demo purposes, use local storage only
    return await _localDataSource.getStockMovements();
    /*
    try {
      final movements = await _remoteDataSource.getStockMovements();
      await _localDataSource.cacheStockMovements(movements);
      return movements;
    } catch (e) {
      return await _localDataSource.getStockMovements();
    }
    */
  }

  @override
  Future<StockMovement> addStockMovement(StockMovement movement) async {
    final movementModel = StockMovementModel(
      id: movement.id,
      productId: movement.productId,
      productName: movement.productName,
      type: movement.type,
      quantity: movement.quantity,
      reason: movement.reason,
      date: movement.date,
    );

    // For demo purposes, use local storage only
    await _localDataSource.addStockMovement(movementModel);
    return movementModel;
    /*
    try {
      final added = await _remoteDataSource.addStockMovement(movementModel);
      await _localDataSource.addStockMovement(added);
      return added;
    } catch (e) {
      await _localDataSource.addStockMovement(movementModel);
      return movementModel;
    }
    */
  }
}

