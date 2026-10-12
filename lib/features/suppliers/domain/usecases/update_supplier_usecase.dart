import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';
import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';

class UpdateSupplierUseCase {
  final SupplierRepository _repository;

  UpdateSupplierUseCase(this._repository);

  Future<Supplier> call(Supplier supplier) async {
    return await _repository.updateSupplier(supplier);
  }
}

