import '../../domain/entities/credit_card.dart';

class CreditCardModel extends CreditCard {
  CreditCardModel({
    required String name,
    required String cardNumber,
    required int cvv,
    required int expireMonth,
    required int expireYear,
    required String issuingCountry,
  }) : super(
    name: name,
    cardNumber: cardNumber,
    cvv: cvv,
    expireMonth: expireMonth,
    expireYear: expireYear,
    issuingCountry: issuingCountry,
  );

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      name: json['name'] as String,
      cardNumber: json['cardNumber'] as String,
      cvv: json['cvv'] as int,
      expireMonth: json['expireMonth'] as int,
      expireYear: json['expireYear'] as int,
      issuingCountry: json['issuingCountry'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expireMonth': expireMonth,
      'expireYear': expireYear,
      'issuingCountry': issuingCountry,
    };
  }
}
