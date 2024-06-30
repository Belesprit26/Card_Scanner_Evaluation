import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credit_card_model.dart';

abstract class CardLocalDataSource {
  Future<void> addCard(CreditCardModel card);
  Future<List<CreditCardModel>> getCards();
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final SharedPreferences sharedPreferences;

  CardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addCard(CreditCardModel card) async {
    try {
      final List<String> cardJsonList = sharedPreferences.getStringList('credit_cards') ?? [];
      final List<CreditCardModel> cardList = cardJsonList.map((cardJson) => CreditCardModel.fromJson(json.decode(cardJson) as Map<String, dynamic>)).toList();

      // Check for duplicate cards
      if (!cardList.any((existingCard) => existingCard.cardNumber == card.cardNumber)) {
        cardList.add(card);
        final List<String> updatedJsonList = cardList.map((cardModel) => json.encode(cardModel.toJson())).toList();
        await sharedPreferences.setStringList('credit_cards', updatedJsonList);
      } else {
        print("Card already exists");
      }
    } catch (e) {
      print("Error in addCard: $e");
      throw Exception("Failed to add card to local data source");
    }
  }

  @override
  Future<List<CreditCardModel>> getCards() async {
    try {
      final List<String> cardJsonList = sharedPreferences.getStringList('credit_cards') ?? [];
      return cardJsonList.map((cardJson) => CreditCardModel.fromJson(json.decode(cardJson) as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error in getCards: $e");
      throw Exception("Failed to retrieve cards from local data source");
    }
  }
}
