import 'package:flutter/material.dart';

import 'package:stock_management/features/stock/domain/entities/stock_movement.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management/core/di/injection.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';

import 'package:stock_management/features/stock/presentation/bloc/stock_bloc.dart';
import 'package:stock_management/features/stock/presentation/pages/add_stock_movement_page.dart';
import 'package:stock_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:intl/intl.dart';

class StockHistoryPage extends StatelessWidget {
  const StockHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          getIt<StockBloc>()..add(const LoadStockMovementsEvent()),
        ),
      ],
      child: const StockHistoryView(),
    );
  }
}

class StockHistoryView extends StatelessWidget {
  const StockHistoryView({super.key});

  void _showMovementDetail(BuildContext context, StockMovement movement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détail du mouvement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produit: ${movement.productName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Type: ${movement.type == MovementType.entry ? 'Entrée' : 'Sortie'}'),
            const SizedBox(height: 8),
            Text('Quantité: ${movement.quantity}'),
            const SizedBox(height: 8),
            if (movement.reason != null && movement.reason!.isNotEmpty)
              Text('Raison: ${movement.reason}'),
            const SizedBox(height: 8),
            Text(
                'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(movement.date)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique du stock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<StockBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<ProductBloc>(),
                      ),
                    ],
                    child: const AddStockMovementPage(),
                  ),
                ),
              );

              if (!context.mounted) return;

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mouvement enregistré avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Add a small delay to ensure local DB writes are complete
                await Future.delayed(const Duration(milliseconds: 300));

                if (!context.mounted) return;

                context.read<StockBloc>().add(const LoadStockMovementsEvent());
                context.read<ProductBloc>().add(const LoadProductsEvent());
                context.read<DashboardBloc>().add(const LoadDashboardEvent());
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<StockBloc, StockState>(
        builder: (context, state) {
          if (state is StockLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StockError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }

          if (state is StockMovementsLoaded) {
            if (state.movements.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun mouvement',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<StockBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<ProductBloc>(),
                                ),
                              ],
                              child: const AddStockMovementPage(),
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mouvement enregistré avec succès'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Add a small delay to ensure local DB writes are complete
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          if (!context.mounted) return;

                          context
                              .read<StockBloc>()
                              .add(const LoadStockMovementsEvent());
                          context
                              .read<ProductBloc>()
                              .add(const LoadProductsEvent());
                          context
                              .read<DashboardBloc>()
                              .add(const LoadDashboardEvent());
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un mouvement'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StockBloc>().add(const LoadStockMovementsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.movements.length,
                itemBuilder: (context, index) {
                  final movement = state.movements[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => _showMovementDetail(context, movement),
                      leading: CircleAvatar(
                        backgroundColor: movement.type == MovementType.entry
                            ? Colors.green
                            : Colors.red,
                        child: Icon(
                          movement.type == MovementType.entry
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        movement.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movement.type == MovementType.entry
                                ? 'Entrée de stock'
                                : 'Sortie de stock',
                          ),
                          if (movement.reason != null &&
                              movement.reason!.isNotEmpty)
                            Text('Raison: ${movement.reason}'),
                          Row(
                            children: [
                              Text('Quantité: ${movement.quantity}'),
                              const SizedBox(width: 16),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(movement.date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${movement.type == MovementType.entry ? '+' : '-'}${movement.quantity}',
                        style: TextStyle(
                          color: movement.type == MovementType.entry
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
