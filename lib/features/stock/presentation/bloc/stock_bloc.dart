import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';
import 'package:stock_management/features/stock/domain/usecases/add_stock_movement_usecase.dart';
import 'package:stock_management/features/stock/domain/usecases/get_stock_movements_usecase.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final GetStockMovementsUseCase _getStockMovementsUseCase;
  final AddStockMovementUseCase _addStockMovementUseCase;

  StockBloc(
    this._getStockMovementsUseCase,
    this._addStockMovementUseCase,
  ) : super(StockInitial()) {
    on<LoadStockMovementsEvent>(_onLoadStockMovements);
    on<AddStockMovementEvent>(_onAddStockMovement);
  }

  Future<void> _onLoadStockMovements(
    LoadStockMovementsEvent event,
    Emitter<StockState> emit,
  ) async {
    emit(StockLoading());
    try {
      final movements = await _getStockMovementsUseCase();
      emit(StockMovementsLoaded(movements));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onAddStockMovement(
    AddStockMovementEvent event,
    Emitter<StockState> emit,
  ) async {
    try {
      await _addStockMovementUseCase(event.movement);
      final movements = await _getStockMovementsUseCase();
      emit(StockMovementsLoaded(movements));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }
}
