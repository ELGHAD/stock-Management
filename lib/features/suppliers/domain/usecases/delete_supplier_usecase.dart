import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';

class DeleteSupplierUseCase {
  final SupplierRepository _repository;

  DeleteSupplierUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteSupplier(id);
  }
}

