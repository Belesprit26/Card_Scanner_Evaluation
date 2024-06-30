import 'package:equatable/equatable.dart';

class CreditCard extends Equatable {
  final String name;
  final String cardNumber;
  final int cvv;
  final int expireMonth;
  final int expireYear;
  final String issuingCountry;

  CreditCard({
    required this.name,
    required this.cardNumber,
    required this.cvv,
    required this.expireMonth,
    required this.expireYear,
    required this.issuingCountry,
  });

  @override
  List<Object?> get props => [name, cardNumber, cvv, expireMonth, expireYear, issuingCountry];
}
