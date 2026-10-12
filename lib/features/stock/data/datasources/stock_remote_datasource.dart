import 'package:stock_management/core/network/api_service.dart';
import 'package:stock_management/features/stock/data/models/stock_movement_model.dart';

abstract class StockRemoteDataSource {
  Future<List<StockMovementModel>> getStockMovements();
  Future<StockMovementModel> addStockMovement(StockMovementModel movement);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final ApiService _apiService;

  StockRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<StockMovementModel>> getStockMovements() async {
    try {
      final response = await _apiService.get('/stock/movements');
      return (response.data as List)
          .map((json) => StockMovementModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<StockMovementModel> addStockMovement(StockMovementModel movement) async {
    try {
      final response = await _apiService.post('/stock/movements', data: movement.toJson());
      return StockMovementModel.fromJson(response.data);
    } catch (e) {
      return movement;
    }
  }
}

