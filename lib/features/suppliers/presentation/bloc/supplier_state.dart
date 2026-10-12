part of 'supplier_bloc.dart';

abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object> get props => [];
}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SupplierLoaded extends SupplierState {
  final List<Supplier> suppliers;

  const SupplierLoaded(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}

class SupplierSuccess extends SupplierLoaded {
  final String message;

  const SupplierSuccess(List<Supplier> suppliers, this.message) : super(suppliers);

  @override
  List<Object> get props => [suppliers, message];
}

class SupplierError extends SupplierState {
  final String message;

  const SupplierError(this.message);

  @override
  List<Object> get props => [message];
}

