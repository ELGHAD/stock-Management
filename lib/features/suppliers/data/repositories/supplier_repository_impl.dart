import 'package:stock_management/features/suppliers/data/datasources/supplier_local_datasource.dart';
import 'package:stock_management/features/suppliers/data/datasources/supplier_remote_datasource.dart';
import 'package:stock_management/features/suppliers/data/models/supplier_model.dart';
import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';
import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource _remoteDataSource;
  final SupplierLocalDataSource _localDataSource;

  SupplierRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<List<Supplier>> getSuppliers() async {
    try {
      final suppliers = await _remoteDataSource.getSuppliers();
      await _localDataSource.cacheSuppliers(suppliers);
      return suppliers;
    } catch (e) {
      return await _localDataSource.getSuppliers();
    }
  }

  @override
  Future<Supplier> createSupplier(Supplier supplier) async {
    final supplierModel = SupplierModel(
      id: supplier.id,
      name: supplier.name,
      email: supplier.email,
      phone: supplier.phone,
      address: supplier.address,
      createdAt: supplier.createdAt,
      updatedAt: supplier.updatedAt,
    );

    try {
      final created = await _remoteDataSource.createSupplier(supplierModel);
      await _localDataSource.addSupplier(created);
      return created;
    } catch (e) {
      await _localDataSource.addSupplier(supplierModel);
      return supplierModel;
    }
  }

  @override
  Future<Supplier> updateSupplier(Supplier supplier) async {
    final supplierModel = SupplierModel(
      id: supplier.id,
      name: supplier.name,
      email: supplier.email,
      phone: supplier.phone,
      address: supplier.address,
      createdAt: supplier.createdAt,
      updatedAt: supplier.updatedAt,
    );

    try {
      final updated = await _remoteDataSource.updateSupplier(supplierModel);
      await _localDataSource.updateSupplier(updated);
      return updated;
    } catch (e) {
      await _localDataSource.updateSupplier(supplierModel);
      return supplierModel;
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      await _remoteDataSource.deleteSupplier(id);
      await _localDataSource.deleteSupplier(id);
    } catch (e) {
      await _localDataSource.deleteSupplier(id);
    }
  }
}

