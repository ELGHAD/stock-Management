import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_management/core/utils/constants.dart';
import 'package:stock_management/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    final box = await Hive.openBox(AppConstants.productsBox);
    final products = <ProductModel>[];
    for (var key in box.keys) {
      final data = box.get(key) as Map<dynamic, dynamic>;
      products.add(ProductModel.fromHive(data));
    }
    return products;
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = await Hive.openBox(AppConstants.productsBox);
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product.toHive());
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final box = await Hive.openBox(AppConstants.productsBox);
    await box.put(product.id, product.toHive());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final box = await Hive.openBox(AppConstants.productsBox);
    await box.put(product.id, product.toHive());
  }

  @override
  Future<void> deleteProduct(String id) async {
    final box = await Hive.openBox(AppConstants.productsBox);
    await box.delete(id);
  }
}

