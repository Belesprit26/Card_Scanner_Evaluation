import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final newText = _getFormattedText(text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _getFormattedText(String text) {
    return text.replaceAllMapped(
        RegExp(r".{4}"), (match) => "${match.group(0)} ");
  }
}
