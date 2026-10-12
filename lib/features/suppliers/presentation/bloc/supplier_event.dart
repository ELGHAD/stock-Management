part of 'supplier_bloc.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliersEvent extends SupplierEvent {
  const LoadSuppliersEvent();
}

class CreateSupplierEvent extends SupplierEvent {
  final Supplier supplier;

  const CreateSupplierEvent(this.supplier);

  @override
  List<Object> get props => [supplier];
}

class UpdateSupplierEvent extends SupplierEvent {
  final Supplier supplier;

  const UpdateSupplierEvent(this.supplier);

  @override
  List<Object> get props => [supplier];
}

class DeleteSupplierEvent extends SupplierEvent {
  final String id;

  const DeleteSupplierEvent(this.id);

  @override
  List<Object> get props => [id];
}

