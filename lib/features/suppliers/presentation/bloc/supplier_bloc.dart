import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/features/suppliers/domain/entities/supplier.dart';
import 'package:stock_management/features/suppliers/domain/usecases/create_supplier_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/delete_supplier_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/get_suppliers_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/update_supplier_usecase.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final GetSuppliersUseCase _getSuppliersUseCase;
  final CreateSupplierUseCase _createSupplierUseCase;
  final UpdateSupplierUseCase _updateSupplierUseCase;
  final DeleteSupplierUseCase _deleteSupplierUseCase;

  SupplierBloc(
    this._getSuppliersUseCase,
    this._createSupplierUseCase,
    this._updateSupplierUseCase,
    this._deleteSupplierUseCase,
  ) : super(SupplierInitial()) {
    on<LoadSuppliersEvent>(_onLoadSuppliers);
    on<CreateSupplierEvent>(_onCreateSupplier);
    on<UpdateSupplierEvent>(_onUpdateSupplier);
    on<DeleteSupplierEvent>(_onDeleteSupplier);
  }

  Future<void> _onLoadSuppliers(
    LoadSuppliersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(SupplierLoading());
    try {
      final suppliers = await _getSuppliersUseCase();
      emit(SupplierLoaded(suppliers));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onCreateSupplier(
    CreateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await _createSupplierUseCase(event.supplier);
      final suppliers = await _getSuppliersUseCase();
      emit(SupplierSuccess(suppliers, 'Fournisseur créé avec succès'));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await _updateSupplierUseCase(event.supplier);
      final suppliers = await _getSuppliersUseCase();
      emit(SupplierSuccess(suppliers, 'Fournisseur mis à jour avec succès'));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onDeleteSupplier(
    DeleteSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await _deleteSupplierUseCase(event.id);
      final suppliers = await _getSuppliersUseCase();
      emit(SupplierLoaded(suppliers));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }
}

