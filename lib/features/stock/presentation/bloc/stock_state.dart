part of 'stock_bloc.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockMovementsLoaded extends StockState {
  final List<StockMovement> movements;

  const StockMovementsLoaded(this.movements);

  @override
  List<Object> get props => [movements];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object> get props => [message];
}
