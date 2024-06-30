import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/card_type.dart';
import '../../../../../core/constants/constants.dart';

class CardUtils {
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.reqfield;
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.reqfield;
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
      return 'Expiry date is invalid';
    }

    int month;
    int year;

    try {
      final parts = value.split('/');
      month = int.parse(parts[0]);
      year = int.parse(parts[1]);

      if (month < 1 || month > 12) {
        return 'Expiry month is invalid';
      }

      year = convertYearTo4Digits(year);
      if (year < 1 || year > 2099) {
        return 'Expiry year is invalid';
      }

      if (hasDateExpired(month, year)) {
        return 'Card has expired';
      }
    } catch (e) {
      return 'Expiry date is invalid';
    }

    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      final now = DateTime.now();
      final currentYear = now.year.toString();
      final prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return !isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    final now = DateTime.now();
    return hasYearPassed(year) || (convertYearTo4Digits(year) == now.year && month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    final fourDigitsYear = convertYearTo4Digits(year);
    final now = DateTime.now();
    return fourDigitsYear < now.year;
  }

  static String getCleanedNumber(String text) {
    final regExp = RegExp(r'[^0-9]');
    return text.replaceAll(regExp, '');
  }

  static Widget? getCardIcon(CardType? cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case CardType.Master:
        img = 'mastercard.png';
        break;
      case CardType.Visa:
        img = 'visa.png';
        break;
      case CardType.Verve:
        img = 'verve.png';
        break;
      case CardType.AmericanExpress:
        img = 'american_express.png';
        break;
      case CardType.Discover:
        img = 'discover.png';
        break;
      case CardType.DinersClub:
        img = 'diners_club.png';
        break;
      case CardType.Jcb:
        img = 'jcb.png';
        break;
      case CardType.Others:
        icon = Icon(
          Icons.credit_card,
          size: 40.0,
          color: Colors.grey[600],
        );
        break;
      default:
        icon = Icon(
          Icons.warning,
          size: 40.0,
          color: Colors.grey[600],
        );
        break;
    }
    Widget? widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  static String? validateCardNum(String? input) {
    if (input == null || input.isEmpty) {
      return Strings.fieldReq;
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      return Strings.numberIsInvalid;
    }

    int sum = 0;
    final length = input.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(input[length - i - 1]);

      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return Strings.numberIsInvalid;
  }

  static CardType getCardTypeFromNumber(String input) {
    CardType cardType;
    if (input.startsWith(RegExp(r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.Master;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = CardType.Visa;
    } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = CardType.Verve;
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardType.AmericanExpress;
    } else if (input.startsWith(RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.Discover;
    } else if (input.startsWith(RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.DinersClub;
    } else if (input.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardType.Jcb;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = CardUtils.getCleanedNumber(newValue.text);
    final newText = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      ),
    );
  }
}
