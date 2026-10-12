import 'package:stock_management/features/auth/domain/entities/user.dart';
import 'package:stock_management/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> call(String username, String password) async {
    return await _repository.login(username, password);
  }
}

