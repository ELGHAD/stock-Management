import 'dart:convert';
import 'package:stock_management/core/storage/local_storage.dart';
import 'package:stock_management/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> registerUser(UserModel user);
  Future<UserModel?> findUser(String email, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _localStorage;

  AuthLocalDataSourceImpl(this._localStorage);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _localStorage.saveUser(jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = _localStorage.getUser();
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _localStorage.clearUser();
    await _localStorage.clearToken();
  }

  @override
  Future<void> registerUser(UserModel user) async {
    await _localStorage.saveRegisteredUser(user.id, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> findUser(String identifier, String password) async {
    final usersJson = await _localStorage.getRegisteredUsers();
    for (var userJson in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if ((user.email == identifier || user.username == identifier) && user.password == password) {
        return user;
      }
    }
    return null;
  }
}

