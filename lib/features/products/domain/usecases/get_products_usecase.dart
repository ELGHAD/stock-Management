import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getProducts();
  }
}

