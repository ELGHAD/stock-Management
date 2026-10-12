import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _tokenBox = 'auth_box';
  static const String _tokenKey = 'token';
  static const String _userBox = 'user_box';
  static const String _userKey = 'user';

  Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_tokenBox);
    await box.put(_tokenKey, token);
  }

  String? getToken() {
    final box = Hive.box(_tokenBox);
    return box.get(_tokenKey);
  }

  Future<void> clearToken() async {
    final box = await Hive.openBox(_tokenBox);
    await box.delete(_tokenKey);
  }

  Future<void> saveUser(String user) async {
    final box = await Hive.openBox(_userBox);
    await box.put(_userKey, user);
  }

  String? getUser() {
    final box = Hive.box(_userBox);
    return box.get(_userKey);
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox(_userBox);
    await box.delete(_userKey);
  }

  // Gestion des utilisateurs inscrits (liste)
  static const String _usersListKey = 'registered_users';

  Future<void> saveRegisteredUser(String userId, String userData) async {
    final box = await Hive.openBox(_userBox);
    await box.put('${_usersListKey}_$userId', userData);
  }

  Future<List<String>> getRegisteredUsers() async {
    final box = await Hive.openBox(_userBox);
    final users = <String>[];
    for (var key in box.keys) {
      if (key.toString().startsWith(_usersListKey)) {
        users.add(box.get(key));
      }
    }
    return users;
  }
}

