import 'package:stock_management/features/products/domain/entities/product.dart';

class StockStatistics {
  final int totalProducts;
  final int availableProducts;
  final int lowStockProducts;
  final int totalStockValue;
  final List<Product> lowStockItems;

  StockStatistics({
    required this.totalProducts,
    required this.availableProducts,
    required this.lowStockProducts,
    required this.totalStockValue,
    required this.lowStockItems,
  });
}

abstract class GetStockStatisticsUseCase {
  Future<StockStatistics> call(List<Product> products);
}

class GetStockStatisticsUseCaseImpl implements GetStockStatisticsUseCase {
  @override
  Future<StockStatistics> call(List<Product> products) async {
    final availableProducts = products.where((p) => p.quantity > 0).length;
    final lowStockProducts = products.where((p) => p.isLowStock).length;
    final totalStockValue = products.fold<double>(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
    final lowStockItems = products.where((p) => p.isLowStock).toList();

    return StockStatistics(
      totalProducts: products.length,
      availableProducts: availableProducts,
      lowStockProducts: lowStockProducts,
      totalStockValue: totalStockValue.toInt(),
      lowStockItems: lowStockItems,
    );
  }
}

