class Validators {
  Validators._();

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
      return 'Enter a valid email, like jean@example.com.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    if (value.length < 6) return 'Password needs at least 6 characters.';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Repeat the password above.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  // validators for phone number
  /// Full name: at least 2 letters
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your name.';
    if (v.length < 2) return 'Name needs at least 2 letters.';
    if (v.length > 50) return 'Name is too long.';
    if (!RegExp(r"^[a-zA-ZÀ-ÿ' -]+$").hasMatch(v)) {
      return 'Use letters only.';
    }
    return null;
  }

  /// Rwandan mobile number: 078 123 4567, 0781234567 or +250 781 234 567.
  static String? phone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 'Enter your phone number.';

    // Strip the country code or leading 0
    final local = digits.startsWith('250')
        ? digits.substring(3)
        : digits.startsWith('0')
        ? digits.substring(1)
        : digits;

    // MTN 078/079, Airtel 072/073
    if (!RegExp(r'^7[2389]\d{7}$').hasMatch(local)) {
      return 'Enter a valid Rwandan number, like 078 123 4567.';
    }
    return null;
  }

  /// Turns any accepted format into +250 before saving
  static String formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final local = digits.startsWith('250')
        ? digits.substring(3)
        : digits.startsWith('0')
        ? digits.substring(1)
        : digits;
    return '+250$local';
  }
}