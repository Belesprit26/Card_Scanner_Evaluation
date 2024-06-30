import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/credit_card.dart';
import '../repositories/card_repository.dart';

class GetCards implements UseCase<List<CreditCard>, NoParams> {
  final CardRepository repository;

  GetCards(this.repository);

  @override
  Future<Either<Failure, List<CreditCard>>> call(NoParams params) async {
    return repository.getCards();
  }
}
