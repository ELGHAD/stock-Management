import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';
import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';

class CreateSupplierUseCase {
  final SupplierRepository _repository;

  CreateSupplierUseCase(this._repository);

  Future<Supplier> call(Supplier supplier) async {
    return await _repository.createSupplier(supplier);
  }
}

