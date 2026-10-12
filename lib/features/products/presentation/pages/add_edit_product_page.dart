import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:stock_management/features/suppliers/presentation/bloc/supplier_bloc.dart';
import 'package:uuid/uuid.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController();

  String? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _quantityController.text = widget.product!.quantity.toString();
      _minQuantityController.text =
          widget.product!.minQuantity.toString();
      _selectedSupplierId = widget.product!.supplierId;
    } else {
      _minQuantityController.text = '10';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final product = Product(
        id: widget.product?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        minQuantity: int.parse(_minQuantityController.text),
        supplierId: _selectedSupplierId,
        supplierName: _getSupplierName(_selectedSupplierId),
        createdAt: widget.product?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.product == null) {
        context.read<ProductBloc>().add(CreateProductEvent(product));
      } else {
        context.read<ProductBloc>().add(UpdateProductEvent(product));
      }

      // Navigator.pop(context, true); // Handled by BlocListener
    }
  }

  String? _getSupplierName(String? supplierId) {
    if (supplierId == null) return null;

    final state = context.read<SupplierBloc>().state;
    if (state is SupplierLoaded) {
      try {
        final supplier = state.suppliers.firstWhere((s) => s.id == supplierId);
        return supplier.name;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null
              ? 'Nouveau produit'
              : 'Modifier le produit',
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, supplierState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du produit *',
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Veuillez entrer un nom'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Prix *',
                              prefixIcon: Icon(Icons.euro),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un prix';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Prix invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantité *',
                              prefixIcon: Icon(Icons.numbers),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer une quantité';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Quantité invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _minQuantityController,
                      decoration: const InputDecoration(
                        labelText:
                        'Quantité minimale (seuil d\'alerte) *',
                        prefixIcon: Icon(Icons.warning),
                        helperText:
                        'Alerte déclenchée si stock ≤ ce seuil',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un seuil';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Seuil invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (supplierState is SupplierLoaded)
                      DropdownButtonFormField<String>(
                        value: supplierState.suppliers
                                .any((s) => s.id == _selectedSupplierId)
                            ? _selectedSupplierId
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Fournisseur',
                          prefixIcon: Icon(Icons.local_shipping),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Aucun fournisseur'),
                          ),
                          ...supplierState.suppliers.map(
                                (supplier) => DropdownMenuItem<String>(
                              value: supplier.id,
                              child: Text(supplier.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplierId = value;
                          });
                        },
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
