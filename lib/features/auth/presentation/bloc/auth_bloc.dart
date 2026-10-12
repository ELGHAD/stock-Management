import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management/core/storage/local_storage.dart';
import 'package:stock_management/features/auth/domain/entities/user.dart';
import 'package:stock_management/features/auth/domain/repositories/auth_repository.dart';
import 'package:stock_management/features/auth/domain/usecases/login_usecase.dart';
import 'package:stock_management/features/auth/domain/usecases/register_usecase.dart';
import 'package:stock_management/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;
  final LocalStorage _localStorage;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._authRepository,
    this._localStorage,
  ) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(event.username, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _registerUseCase(event.username, event.email, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _logoutUseCase();
      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Vérifier si un token existe
      final token = _localStorage.getToken();
      if (token != null) {
        // Vérifier si un utilisateur est en cache
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthenticatedState(user));
          return;
        }
      }
      emit(UnauthenticatedState());
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }
}

