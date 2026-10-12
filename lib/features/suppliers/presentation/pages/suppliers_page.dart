import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/core/di/injection.dart';
import 'package:stock_management/features/suppliers/presentation/bloc/supplier_bloc.dart';
import 'package:stock_management/features/suppliers/presentation/pages/add_edit_supplier_page.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuppliersView();
  }
}

class SuppliersView extends StatelessWidget {
  const SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fournisseurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final supplierBloc = context.read<SupplierBloc>();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: supplierBloc,
                    child: const AddEditSupplierPage(),
                  ),
                ),
              );

              if (!context.mounted) return;

              if (result == true) {
                context
                    .read<SupplierBloc>()
                    .add(const LoadSuppliersEvent());
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SupplierBloc, SupplierState>(
        builder: (context, state) {
          if (state is SupplierLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SupplierError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }

          if (state is SupplierLoaded) {
            if (state.suppliers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_shipping,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun fournisseur',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final supplierBloc = context.read<SupplierBloc>();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: supplierBloc,
                              child: const AddEditSupplierPage(),
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          context
                              .read<SupplierBloc>()
                              .add(const LoadSuppliersEvent());
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un fournisseur'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<SupplierBloc>()
                    .add(const LoadSuppliersEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = state.suppliers[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.local_shipping,
                            color: Colors.white),
                      ),
                      title: Text(
                        supplier.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (supplier.email.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16),
                                const SizedBox(width: 4),
                                Expanded(child: Text(supplier.email)),
                              ],
                            ),
                          ],
                          if (supplier.phone.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 4),
                                Text(supplier.phone),
                              ],
                            ),
                          ],
                          if (supplier.address.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text(supplier.address)),
                              ],
                            ),
                          ],
                        ],
                      ),
                      onTap: () async {
                        final supplierBloc = context.read<SupplierBloc>();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: supplierBloc,
                              child: AddEditSupplierPage(
                                supplier: supplier,
                              ),
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          context
                              .read<SupplierBloc>()
                              .add(const LoadSuppliersEvent());
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text(
                                'Supprimer le fournisseur'),
                            content: Text(
                              'Êtes-vous sûr de vouloir supprimer "${supplier.name}" ?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<SupplierBloc>()
                                      .add(DeleteSupplierEvent(
                                      supplier.id));
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text(
                                  'Supprimer',
                                  style:
                                  TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
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
