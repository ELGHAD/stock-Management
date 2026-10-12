import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/domain/repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<Product> call(Product product) async {
    return await _repository.createProduct(product);
  }
}

