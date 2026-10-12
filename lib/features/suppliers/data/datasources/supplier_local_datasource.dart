import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_management/core/utils/constants.dart';
import 'package:stock_management/features/suppliers/data/models/supplier_model.dart';

abstract class SupplierLocalDataSource {
  Future<List<SupplierModel>> getSuppliers();
  Future<void> cacheSuppliers(List<SupplierModel> suppliers);
  Future<void> addSupplier(SupplierModel supplier);
  Future<void> updateSupplier(SupplierModel supplier);
  Future<void> deleteSupplier(String id);
}

class SupplierLocalDataSourceImpl implements SupplierLocalDataSource {
  @override
  Future<List<SupplierModel>> getSuppliers() async {
    final box = await Hive.openBox(AppConstants.suppliersBox);
    final suppliers = <SupplierModel>[];
    for (var key in box.keys) {
      final data = box.get(key) as Map<dynamic, dynamic>;
      suppliers.add(SupplierModel.fromHive(data));
    }
    return suppliers;
  }

  @override
  Future<void> cacheSuppliers(List<SupplierModel> suppliers) async {
    final box = await Hive.openBox(AppConstants.suppliersBox);
    await box.clear();
    for (var supplier in suppliers) {
      await box.put(supplier.id, supplier.toHive());
    }
  }

  @override
  Future<void> addSupplier(SupplierModel supplier) async {
    final box = await Hive.openBox(AppConstants.suppliersBox);
    await box.put(supplier.id, supplier.toHive());
  }

  @override
  Future<void> updateSupplier(SupplierModel supplier) async {
    final box = await Hive.openBox(AppConstants.suppliersBox);
    await box.put(supplier.id, supplier.toHive());
  }

  @override
  Future<void> deleteSupplier(String id) async {
    final box = await Hive.openBox(AppConstants.suppliersBox);
    await box.delete(id);
  }
}

