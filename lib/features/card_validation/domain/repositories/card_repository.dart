import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/credit_card.dart';

abstract class CardRepository {
  Future<Either<Failure, void>> addCard(CreditCard card);
  Future<Either<Failure, List<CreditCard>>> getCards();
  Future<Either<Failure, bool>> cardExists(String cardNumber); // Add this line
}
