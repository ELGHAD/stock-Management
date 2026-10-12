import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_management/core/di/injection.dart';
import 'package:stock_management/core/theme/app_theme.dart';
import 'package:stock_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management/features/auth/presentation/pages/login_page.dart';
import 'package:stock_management/features/auth/presentation/pages/register_page.dart';
import 'package:stock_management/features/dashboard/presentation/pages/dashboard_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
          getIt<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Gestion de Stock',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: state is AuthenticatedState
                ? const DashboardPage()
                : const LoginPage(),
            routes: {
              '/dashboard': (_) => const DashboardPage(),
              '/register': (_) => const RegisterPage(),
            },
          );
        },
      ),
    );
  }
}
