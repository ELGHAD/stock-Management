import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/core/di/injection.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:stock_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:stock_management/features/products/presentation/pages/add_edit_product_page.dart';
import 'package:stock_management/features/suppliers/presentation/bloc/supplier_bloc.dart';
import 'package:intl/intl.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductsView();
  }
}

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final productBloc = context.read<ProductBloc>();
              final supplierBloc = context.read<SupplierBloc>();
              
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: productBloc),
                      BlocProvider.value(value: supplierBloc),
                    ],
                    child: const AddEditProductPage(),
                  ),
                ),
              );

              if (!context.mounted) return;

              if (result == true) {
                context
                    .read<ProductBloc>()
                    .add(const LoadProductsEvent());
                context
                    .read<DashboardBloc>()
                    .add(const LoadDashboardEvent());
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }

          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun produit',
                      style:
                      Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final productBloc = context.read<ProductBloc>();
                        final supplierBloc = context.read<SupplierBloc>();

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: productBloc),
                                BlocProvider.value(value: supplierBloc),
                              ],
                              child: const AddEditProductPage(),
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          context
                              .read<ProductBloc>()
                              .add(const LoadProductsEvent());
                          context
                              .read<DashboardBloc>()
                              .add(const LoadDashboardEvent());
                        }
                      },
                      icon: const Icon(Icons.add),
                      label:
                      const Text('Ajouter un produit'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProductBloc>()
                    .add(const LoadProductsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  try {
                    final product = state.products[index];

                  return Card(
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: product.isLowStock
                            ? Colors.orange
                            : Colors.green,
                        child: const Icon(
                          Icons.inventory_2,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                  'Stock: ${product.quantity}'),
                              const SizedBox(width: 16),
                              Text(
                                NumberFormat.currency(
                                  symbol: '€',
                                  decimalDigits: 2,
                                ).format(product.price),
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (product.supplierName != null)
                            Text(
                                'Fournisseur: ${product.supplierName}'),
                        ],
                      ),
                      trailing: product.isLowStock
                          ? const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      )
                          : null,
                      onTap: () async {
                        final productBloc = context.read<ProductBloc>();
                        final supplierBloc = context.read<SupplierBloc>();

                        final result =
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: productBloc),
                                BlocProvider.value(value: supplierBloc),
                              ],
                              child: AddEditProductPage(
                                  product: product),
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          context
                              .read<ProductBloc>()
                              .add(
                              const LoadProductsEvent());
                          context
                              .read<DashboardBloc>()
                              .add(const LoadDashboardEvent());
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(
                                'Supprimer le produit'),
                            content: Text(
                              'Êtes-vous sûr de vouloir supprimer "${product.name}" ?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context),
                                child:
                                const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(
                                    DeleteProductEvent(
                                        product.id),
                                  );
                                  // Give a small delay for the DB delete to propagate if needed, 
                                  // or rely on the bloc to handle it. 
                                  // Ideally we'd listen to the state change, but for now:
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    if(context.mounted) {
                                       context.read<DashboardBloc>().add(const LoadDashboardEvent());
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Supprimer',
                                  style: TextStyle(
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                  } catch (e) {
                    return Card(
                      color: Colors.red.shade100,
                      child: ListTile(
                        title: Text('Erreur: $e'),
                      ),
                    );
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
