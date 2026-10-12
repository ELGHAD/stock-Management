import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/domain/repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Product> call(Product product) async {
    return await _repository.updateProduct(product);
  }
}

