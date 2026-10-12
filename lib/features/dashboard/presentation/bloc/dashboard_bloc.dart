import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stock_management/features/stock/domain/usecases/get_stock_statistics_usecase.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetStockStatisticsUseCase _getStockStatisticsUseCase;

  DashboardBloc(
    this._getProductsUseCase,
    this._getStockStatisticsUseCase,
  ) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final products = await _getProductsUseCase();
      final statistics = await _getStockStatisticsUseCase.call(products);
      emit(DashboardLoaded(products, statistics));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}

