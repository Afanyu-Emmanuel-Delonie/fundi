import 'package:flutter/foundation.dart';
import 'package:fundi/data/repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  bool isLoading = false;
  bool obscurePassword = true;
  String? error;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authRepository.signIn(email, password);
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
