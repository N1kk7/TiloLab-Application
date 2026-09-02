class Validators {
  static final _cyrillicRegex = RegExp(r"^[а-яіїєґёА-ЯІЇЄҐЁ\s'-]+$");
  static final _emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");
  static final _uaPhoneRegex =
      RegExp(r'^\+380(39|67|68|96|97|98|50|66|95|75|99|63|73|93)\d{7}$');

  static String? required(String? value, {String message = "Обов'язкове поле"}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? cyrillicName(String? value, {String? message}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Обов'язкове поле";
    if (!_cyrillicRegex.hasMatch(v)) return message ?? 'Введіть Українською';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Обов'язкове поле";
    if (!_emailRegex.hasMatch(v)) return 'Перевірте правильність email';
    return null;
  }

  static String? uaPhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.length < 13) return 'Перевірте номер телефону';
    if (!_uaPhoneRegex.hasMatch(digits)) return 'Перевірте правильність номеру';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if ((value ?? '').isEmpty) return "Обов'язкове поле";
    if (value!.length < minLength) return 'Пароль занадто короткий';
    return null;
  }

  static String? passwordsMatch(String? password, String? confirm) {
    if (password != confirm) return 'Паролі не співпадають';
    return null;
  }

  static String? firstError(List<String? Function()> checks) {
    for (final check in checks) {
      final result = check();
      if (result != null) return result;
    }
    return null;
  }
}