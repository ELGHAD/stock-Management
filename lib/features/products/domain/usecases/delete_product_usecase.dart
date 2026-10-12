import 'package:stock_management/features/products/domain/repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteProduct(id);
  }
}

