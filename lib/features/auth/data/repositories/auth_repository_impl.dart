import 'package:stock_management/core/storage/local_storage.dart';
import 'package:stock_management/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:stock_management/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stock_management/features/auth/domain/entities/user.dart';
import 'package:stock_management/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final LocalStorage _localStorage;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource, [
    LocalStorage? localStorage,
  ]) : _localStorage = localStorage ?? LocalStorage();

  @override
  Future<User> login(String username, String password) async {
    try {
      final user = await _remoteDataSource.login(username, password);
      await _localDataSource.cacheUser(user);
      await _localStorage.saveToken('demo_token_${user.id}');
      return user;

    } catch (e) {
      // En cas d'erreur réseau, vérifier les identifiants localement
      final user = await _localDataSource.findUser(username, password);
      if (user != null) {
        await _localDataSource.cacheUser(user);
        await _localStorage.saveToken('demo_token_${user.id}');
        return user;
      }
      throw Exception('Identifiants incorrects');
    }
  }

  @override
  Future<User> register(String username, String email, String password) async {
    try {
      final user = await _remoteDataSource.register(username, email, password);
      
      // Sauvegarder dans la liste des utilisateurs inscrits
      await _localDataSource.registerUser(user);
      
      // Auto-login after registration
      await _localDataSource.cacheUser(user);
      await _localStorage.saveToken('demo_token_${user.id}');
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      // Ignorer les erreurs réseau
    } finally {
      await _localDataSource.clearCache();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _localDataSource.getCachedUser();
  }
}

