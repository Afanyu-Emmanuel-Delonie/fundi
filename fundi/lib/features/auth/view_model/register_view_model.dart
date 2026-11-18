import 'package:flutter/foundation.dart';
import 'package:fundi/data/repository/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? error;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authRepository.signUp(name: name, email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
