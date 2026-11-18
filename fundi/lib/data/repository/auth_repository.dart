/// Fake auth for now. No backend.
/// Later, swap the method bodies for real calls. Nothing else changes.
class AuthRepository {
  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Test account for the demo
    if (email.trim() != 'jean@example.com' || password != '123456') {
      throw Exception('Email or password is wrong. Check them and try again.');
    }
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));

    // Demo account is already "taken"
    if (email.trim().toLowerCase() == 'jean@example.com') {
      throw Exception('An account with this email already exists.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> signOut() async {}
}