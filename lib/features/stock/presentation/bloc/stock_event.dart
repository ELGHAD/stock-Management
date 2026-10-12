part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class LoadStockMovementsEvent extends StockEvent {
  const LoadStockMovementsEvent();
}

class AddStockMovementEvent extends StockEvent {
  final StockMovement movement;

  const AddStockMovementEvent(this.movement);

  @override
  List<Object> get props => [movement];
}
