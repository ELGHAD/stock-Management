import 'package:stock_management/core/network/api_service.dart';
import 'package:stock_management/features/suppliers/data/models/supplier_model.dart';

abstract class SupplierRemoteDataSource {
  Future<List<SupplierModel>> getSuppliers();
  Future<SupplierModel> createSupplier(SupplierModel supplier);
  Future<SupplierModel> updateSupplier(SupplierModel supplier);
  Future<void> deleteSupplier(String id);
}

class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  final ApiService _apiService;

  SupplierRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<SupplierModel>> getSuppliers() async {
    try {
      // Force local fallback for demo to prevent overwriting local data with empty/stub remote data
      throw Exception('Demo mode: Force local fallback');
      /*
      final response = await _apiService.get('/suppliers');
      final list = (response.data as List)
          .map((json) => SupplierModel.fromJson(json))
          .toList();
      if (list.isEmpty) {
        throw Exception('List is empty - forcing local fallback');
      }
      return list;
      */
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    try {
      final response = await _apiService.post('/suppliers', data: supplier.toJson());
      return SupplierModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SupplierModel> updateSupplier(SupplierModel supplier) async {
    try {
      final response = await _apiService.put('/suppliers/${supplier.id}', data: supplier.toJson());
      return SupplierModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      await _apiService.delete('/suppliers/$id');
    } catch (e) {
      rethrow;
    }
  }
}

