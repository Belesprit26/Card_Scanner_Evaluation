import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/credit_card.dart';
import '../repositories/card_repository.dart';

class AddCard implements UseCase<void, CreditCard> {
  final CardRepository repository;

  AddCard(this.repository);

  @override
  Future<Either<Failure, void>> call(CreditCard card) async {
    return repository.addCard(card);
  }
}
