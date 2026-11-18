import 'package:flutter/foundation.dart';
import 'package:fundi/data/repository/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ForgotPasswordViewModel(this._authRepository);

  bool isLoading = false;
  bool sent = false;
  String? error;
  String? sentTo;

  Future<bool> sendReset(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authRepository.sendPasswordReset(email);
      isLoading = false;
      sent = true;
      sentTo = email.trim();
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Lets the user go back and try a different email.
  void reset() {
    sent = false;
    error = null;
    notifyListeners();
  }
}
