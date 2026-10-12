import 'package:stock_management/core/network/api_service.dart';
import 'package:stock_management/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _apiService;

  ProductRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Force local fallback for demo to prevent overwriting local data with empty/stub remote data
      throw Exception('Demo mode: Force local fallback');
      /*
      final response = await _apiService.get('/products');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
      */
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      // Force local fallback for demo
      throw Exception('Demo mode: Force local fallback');
      /*
      final response = await _apiService.post('/products', data: product.toJson());
      return ProductModel.fromJson(response.data);
      */
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await _apiService.put('/products/${product.id}', data: product.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _apiService.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }
}

