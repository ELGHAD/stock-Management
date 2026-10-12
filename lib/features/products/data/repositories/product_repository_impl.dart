import 'package:stock_management/features/products/data/datasources/product_local_datasource.dart';
import 'package:stock_management/features/products/data/datasources/product_remote_datasource.dart';
import 'package:stock_management/features/products/data/models/product_model.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(products);
      return products;
    } catch (e) {
      // En cas d'erreur réseau, utiliser les données locales
      return await _localDataSource.getProducts();
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      minQuantity: product.minQuantity,
      supplierId: product.supplierId,
      supplierName: product.supplierName,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );

    try {
      final created = await _remoteDataSource.createProduct(productModel);
      await _localDataSource.addProduct(created);
      return created;
    } catch (e) {
      // En cas d'erreur réseau, sauvegarder localement
      await _localDataSource.addProduct(productModel);
      return productModel;
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      minQuantity: product.minQuantity,
      supplierId: product.supplierId,
      supplierName: product.supplierName,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );

    try {
      final updated = await _remoteDataSource.updateProduct(productModel);
      await _localDataSource.updateProduct(updated);
      return updated;
    } catch (e) {
      // En cas d'erreur réseau, mettre à jour localement
      await _localDataSource.updateProduct(productModel);
      return productModel;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _remoteDataSource.deleteProduct(id);
      await _localDataSource.deleteProduct(id);
    } catch (e) {
      // En cas d'erreur réseau, supprimer localement
      await _localDataSource.deleteProduct(id);
    }
  }
}

