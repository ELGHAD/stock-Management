import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:stock_management/core/di/injection.dart';
import 'package:stock_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:stock_management/features/products/domain/entities/product.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:stock_management/features/products/presentation/pages/products_page.dart';
import 'package:stock_management/features/suppliers/presentation/pages/suppliers_page.dart';
import 'package:stock_management/features/stock/domain/usecases/get_stock_statistics_usecase.dart';
import 'package:stock_management/features/stock/presentation/pages/stock_history_page.dart';
import 'package:stock_management/features/suppliers/presentation/bloc/supplier_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<DashboardBloc>()..add(const LoadDashboardEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<ProductBloc>()..add(const LoadProductsEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<SupplierBloc>()..add(const LoadSuppliersEvent()),
        ),
      ],
      child: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    ProductsPage(),
    SuppliersPage(),
    StockHistoryPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      context.read<DashboardBloc>().add(const LoadDashboardEvent());
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnauthenticatedState) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              }
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductSuccess) {
                // Refresh dashboard stats whenever a product action succeeds
                context.read<DashboardBloc>().add(const LoadDashboardEvent());
              }
            },
          ),
        ],
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Fournisseurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(child: Text('Erreur : ${state.message}'));
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(const LoadDashboardEvent());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Builder(
                  builder: (context) {
                    try {
                      return Column(
                        children: [
                          _buildStatisticsCards(context, state.statistics),
                          const SizedBox(height: 24),
                          _buildLowStockAlerts(
                            context,
                            state.statistics.lowStockItems,
                          ),
                          const SizedBox(height: 24),
                          _buildStockChart(context, state.statistics),
                        ],
                      );
                    } catch (e) {
                      return Center(
                        child: Text('Erreur d\'affichage du dashboard: $e', style: const TextStyle(color: Colors.red)),
                      );
                    }
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context, StockStatistics stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _statCard(context, 'Produits', stats.totalProducts.toString(), Icons.inventory_2),
        _statCard(context, 'En stock', stats.availableProducts.toString(), Icons.check_circle),
        _statCard(context, 'Rupture', stats.lowStockProducts.toString(), Icons.warning),
        _statCard(
          context,
          'Valeur',
          NumberFormat.currency(symbol: '€', decimalDigits: 0).format(stats.totalStockValue),
          Icons.euro,
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildLowStockAlerts(BuildContext context, List<Product> products) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Column(
        children: products.take(5).map((Product product) {
          return ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: Text(product.name),
            subtitle: Text('Stock : ${product.quantity} (min : ${product.minQuantity})'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStockChart(BuildContext context, StockStatistics stats) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: stats.availableProducts.toDouble(),
              title: 'Disponible',
              color: Colors.green,
            ),
            PieChartSectionData(
              value: stats.lowStockProducts.toDouble(),
              title: 'Rupture',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
