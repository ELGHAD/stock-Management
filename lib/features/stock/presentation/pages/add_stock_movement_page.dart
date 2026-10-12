import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';

import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';


import 'package:stock_management/features/stock/presentation/bloc/stock_bloc.dart';
import 'package:uuid/uuid.dart';

class AddStockMovementPage extends StatefulWidget {
  const AddStockMovementPage({super.key});

  @override
  State<AddStockMovementPage> createState() => _AddStockMovementPageState();
}

class _AddStockMovementPageState extends State<AddStockMovementPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();

  Product? _selectedProduct;
  MovementType _selectedType = MovementType.entry;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _saveMovement() {
    if (!_formKey.currentState!.validate() || _selectedProduct == null) {
      return;
    }

    final movement = StockMovement(
      id: const Uuid().v4(),
      productId: _selectedProduct!.id,
      productName: _selectedProduct!.name,
      type: _selectedType,
      quantity: int.parse(_quantityController.text),
      reason: _reasonController.text.trim().isEmpty
          ? null
          : _reasonController.text.trim(),
      date: DateTime.now(),
    );

    context.read<StockBloc>().add(AddStockMovementEvent(movement));

    final updatedProduct = _selectedProduct!.copyWith(
      quantity: _selectedType == MovementType.entry
          ? _selectedProduct!.quantity + movement.quantity
          : _selectedProduct!.quantity - movement.quantity,
      updatedAt: DateTime.now(),
    );

    context.read<ProductBloc>().add(UpdateProductEvent(updatedProduct));

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mouvement enregistré avec succès'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau mouvement de stock'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final products =
              state is ProductLoaded ? state.products : <Product>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    decoration: const InputDecoration(
                      labelText: 'Produit *',
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(
                          '${product.name} (Stock: ${product.quantity})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProduct = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un produit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<MovementType>(
                    segments: const [
                      ButtonSegment(
                        value: MovementType.entry,
                        label: Text('Entrée'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                      ButtonSegment(
                        value: MovementType.exit,
                        label: Text('Sortie'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _selectedType = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantité *',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une quantité';
                      }

                      final quantity = int.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'Quantité invalide';
                      }

                      if (_selectedProduct != null &&
                          _selectedType == MovementType.exit &&
                          quantity > _selectedProduct!.quantity) {
                        return 'Stock insuffisant';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Raison (optionnel)',
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                  if (_selectedProduct != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Stock actuel : ${_selectedProduct!.quantity}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveMovement,
                    child: const Text('Enregistrer'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
