import 'package:stock_management/features/auth/domain/entities/user.dart';

class UserModel extends User {
  final String? password; // Pour le stockage local uniquement

  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

