import 'package:flutter/services.dart';

class UaPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (!digits.startsWith('38')) {
      digits = '38$digits';
    }
    digits = digits.substring(0, digits.length > 12 ? 12 : digits.length);

    final buffer = StringBuffer('+38');

    if (digits.length > 2) {
      buffer.write(' (');
      buffer.write(digits.substring(2, digits.length >= 5 ? 5 : digits.length));
    }
    if (digits.length >= 5) {
      buffer.write(') ');
      buffer.write(digits.substring(5, digits.length >= 8 ? 8 : digits.length));
    }
    if (digits.length >= 8) {
      buffer.write('-');
      buffer.write(digits.substring(8, digits.length >= 10 ? 10 : digits.length));
    }
    if (digits.length >= 10) {
      buffer.write('-');
      buffer.write(digits.substring(10, digits.length >= 12 ? 12 : digits.length));
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}