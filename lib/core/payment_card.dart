
import 'constants/card_type.dart';

class PaymentCard {
  CardType type;
  String number;

  PaymentCard({this.type = CardType.Others, this.number = ''});
}
