import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/add_card.dart';
import '../../domain/usecases/get_cards.dart';
import '../../domain/repositories/card_repository.dart'; // Ensure this import

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final AddCard addCard;
  final GetCards getCards;
  final CardRepository cardRepository;

  CardBloc({required this.addCard, required this.getCards, required this.cardRepository}) : super(CardInitial()) {
    on<AddCardEvent>(_onAddCard);
    on<GetCardsEvent>(_onGetCards);

    // Trigger GetCardsEvent on bloc initialization
    add(GetCardsEvent());
  }

  Future<void> _onAddCard(AddCardEvent event, Emitter<CardState> emit) async {
    emit(CardLoading());
    final existsResult = await cardRepository.cardExists(event.card.cardNumber); // Await the result
    await existsResult.fold(
          (failure) async => emit(CardError(failure.message)),
          (exists) async {
        if (exists) {
          emit(CardError('This card is already stored on the system'));
        } else {
          final result = await addCard(event.card); // Await the result
          await result.fold(
                (failure) async => emit(CardError(failure.message)),
                (_) async {
              emit(CardAdded());
              add(GetCardsEvent());
            },
          );
        }
      },
    );
  }

  Future<void> _onGetCards(GetCardsEvent event, Emitter<CardState> emit) async {
    emit(CardLoading());
    final result = await getCards(NoParams());
    result.fold(
          (failure) => emit(CardError(failure.message)),
          (cards) => emit(CardsLoaded(cards)),
    );
  }

  void reloadCards() {
    add(GetCardsEvent()); // Dispatch GetCardsEvent to reload cards
  }
}
