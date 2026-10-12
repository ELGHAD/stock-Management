import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/domain/usecases/create_product_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/update_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductBloc(
    this._getProductsUseCase,
    this._createProductUseCase,
    this._updateProductUseCase,
    this._deleteProductUseCase,
  ) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _createProductUseCase(event.product);
      final products = await _getProductsUseCase();
      emit(ProductSuccess(products, 'Produit créé avec succès'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _updateProductUseCase(event.product);
      final products = await _getProductsUseCase();
      emit(ProductSuccess(products, 'Produit mis à jour avec succès'));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _deleteProductUseCase(event.id);
      final products = await _getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

