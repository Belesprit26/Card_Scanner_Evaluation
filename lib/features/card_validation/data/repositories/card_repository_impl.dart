import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../datasources/card_local_data_source.dart';
import '../models/credit_card_model.dart';

class CardRepositoryImpl implements CardRepository {
  final CardLocalDataSource localDataSource;

  CardRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addCard(CreditCard card) async {
    try {
      final cardModel = CreditCardModel(
        name: card.name,
        cardNumber: card.cardNumber,
        cvv: card.cvv,
        expireMonth: card.expireMonth,
        expireYear: card.expireYear,
        issuingCountry: card.issuingCountry,
      );
      await localDataSource.addCard(cardModel);
      return Right(null);
    } catch (e) {
      print("Error in addCard: $e");
      return Left(ValidationFailure('Failed to add card'));
    }
  }

  @override
  Future<Either<Failure, List<CreditCard>>> getCards() async {
    try {
      final cardModels = await localDataSource.getCards();
      final cards = cardModels.map((model) => CreditCard(
        name: model.name,
        cardNumber: model.cardNumber,
        cvv: model.cvv,
        expireMonth: model.expireMonth,
        expireYear: model.expireYear,
        issuingCountry: model.issuingCountry,
      )).toList();
      return Right(cards);
    } catch (e) {
      print("Error in getCards: $e");
      return Left(ValidationFailure('Failed to get cards'));
    }
  }

  @override
  Future<Either<Failure, bool>> cardExists(String cardNumber) async {
    try {
      final cardModels = await localDataSource.getCards();
      final exists = cardModels.any((model) => model.cardNumber == cardNumber);
      return Right(exists);
    } catch (e) {
      print("Error in cardExists: $e");
      return Left(ValidationFailure('Failed to check card existence'));
    }
  }
}
