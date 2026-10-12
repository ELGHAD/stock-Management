import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_management/core/network/api_client.dart';
import 'package:stock_management/core/network/api_service.dart';
import 'package:stock_management/core/storage/local_storage.dart';
import 'package:stock_management/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:stock_management/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stock_management/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stock_management/features/auth/domain/repositories/auth_repository.dart';
import 'package:stock_management/features/auth/domain/usecases/login_usecase.dart';
import 'package:stock_management/features/auth/domain/usecases/register_usecase.dart';
import 'package:stock_management/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stock_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management/features/products/data/datasources/product_local_datasource.dart';
import 'package:stock_management/features/products/data/datasources/product_remote_datasource.dart';
import 'package:stock_management/features/products/data/repositories/product_repository_impl.dart';
import 'package:stock_management/features/products/domain/repositories/product_repository.dart';
import 'package:stock_management/features/products/domain/usecases/create_product_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stock_management/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stock_management/features/products/presentation/bloc/product_bloc.dart';
import 'package:stock_management/features/suppliers/data/datasources/supplier_local_datasource.dart';
import 'package:stock_management/features/suppliers/data/datasources/supplier_remote_datasource.dart';
import 'package:stock_management/features/suppliers/data/repositories/supplier_repository_impl.dart';
import 'package:stock_management/features/suppliers/domain/repositories/supplier_repository.dart';
import 'package:stock_management/features/suppliers/domain/usecases/create_supplier_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/delete_supplier_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/get_suppliers_usecase.dart';
import 'package:stock_management/features/suppliers/domain/usecases/update_supplier_usecase.dart';
import 'package:stock_management/features/suppliers/presentation/bloc/supplier_bloc.dart';
import 'package:stock_management/features/stock/data/datasources/stock_local_datasource.dart';
import 'package:stock_management/features/stock/data/datasources/stock_remote_datasource.dart';
import 'package:stock_management/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:stock_management/features/stock/domain/repositories/stock_repository.dart';
import 'package:stock_management/features/stock/domain/usecases/add_stock_movement_usecase.dart';
import 'package:stock_management/features/stock/domain/usecases/get_stock_movements_usecase.dart';
import 'package:stock_management/features/stock/domain/usecases/get_stock_statistics_usecase.dart';
import 'package:stock_management/features/stock/presentation/bloc/stock_bloc.dart';
import 'package:stock_management/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<LocalStorage>(() => LocalStorage());

  getIt.registerLazySingleton<ApiClient>(
        () => ApiClient(
      getIt<Dio>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  getIt.registerLazySingleton<ApiService>(
        () => ApiService(getIt<ApiClient>()),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(getIt<LocalStorage>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
        () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
        () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerFactory(
    () => AuthBloc(
      getIt<LoginUseCase>(),
      getIt<RegisterUseCase>(),
      getIt<LogoutUseCase>(),
      getIt<AuthRepository>(),
      getIt<LocalStorage>(),
    ),
  );

  // Products
  getIt.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(),
  );


  getIt.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      getIt<ProductRemoteDataSource>(),
      getIt<ProductLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
        () => GetProductsUseCase(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton(
        () => CreateProductUseCase(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton(
        () => UpdateProductUseCase(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton(
        () => DeleteProductUseCase(getIt<ProductRepository>()),
  );

  getIt.registerFactory(
        () => ProductBloc(
      getIt<GetProductsUseCase>(),
      getIt<CreateProductUseCase>(),
      getIt<UpdateProductUseCase>(),
      getIt<DeleteProductUseCase>(),
    ),
  );

  // Suppliers
  getIt.registerLazySingleton<SupplierRemoteDataSource>(
        () => SupplierRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<SupplierLocalDataSource>(
        () => SupplierLocalDataSourceImpl(),
  );


  getIt.registerLazySingleton<SupplierRepository>(
        () => SupplierRepositoryImpl(
      getIt<SupplierRemoteDataSource>(),
      getIt<SupplierLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
        () => GetSuppliersUseCase(getIt<SupplierRepository>()),
  );

  getIt.registerLazySingleton(
        () => CreateSupplierUseCase(getIt<SupplierRepository>()),
  );

  getIt.registerLazySingleton(
        () => UpdateSupplierUseCase(getIt<SupplierRepository>()),
  );

  getIt.registerLazySingleton(
        () => DeleteSupplierUseCase(getIt<SupplierRepository>()),
  );

  getIt.registerFactory(
        () => SupplierBloc(
      getIt<GetSuppliersUseCase>(),
      getIt<CreateSupplierUseCase>(),
      getIt<UpdateSupplierUseCase>(),
      getIt<DeleteSupplierUseCase>(),
    ),
  );

  // Stock
  getIt.registerLazySingleton<StockRemoteDataSource>(
        () => StockRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<StockLocalDataSource>(
        () => StockLocalDataSourceImpl(),
  );


  getIt.registerLazySingleton<StockRepository>(
        () => StockRepositoryImpl(
      getIt<StockRemoteDataSource>(),
      getIt<StockLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
        () => GetStockMovementsUseCase(getIt<StockRepository>()),
  );

  getIt.registerLazySingleton(
        () => AddStockMovementUseCase(getIt<StockRepository>()),
  );

  // Aucun paramètre ici (classe pure)
  getIt.registerLazySingleton<GetStockStatisticsUseCase>(
        () => GetStockStatisticsUseCaseImpl(),
  );

  getIt.registerFactory(
        () => StockBloc(
      getIt<GetStockMovementsUseCase>(),
      getIt<AddStockMovementUseCase>(),
    ),
  );

  // Dashboard
  getIt.registerFactory(
        () => DashboardBloc(
      getIt<GetProductsUseCase>(),
      getIt<GetStockStatisticsUseCase>(),
    ),
  );
}
