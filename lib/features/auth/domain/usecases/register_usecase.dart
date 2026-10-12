import 'package:stock_management/features/auth/domain/entities/user.dart';
import 'package:stock_management/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<User> call(String username, String email, String password) async {
    return await _repository.register(username, email, password);
  }
}
