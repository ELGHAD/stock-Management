import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';
import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';

class GetSuppliersUseCase {
  final SupplierRepository _repository;

  GetSuppliersUseCase(this._repository);

  Future<List<Supplier>> call() async {
    return await _repository.getSuppliers();
  }
}

