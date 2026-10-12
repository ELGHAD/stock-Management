import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getSuppliers();
  Future<Supplier> createSupplier(Supplier supplier);
  Future<Supplier> updateSupplier(Supplier supplier);
  Future<void> deleteSupplier(String id);
}

