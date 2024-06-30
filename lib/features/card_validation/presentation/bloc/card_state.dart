part of 'card_bloc.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

class CardInitial extends CardState {}

class CardLoading extends CardState {}

class CardAdded extends CardState {}

class CardsLoaded extends CardState {
  final List<CreditCard> cards;

  CardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class CardError extends CardState {
  final String message;

  CardError(this.message);

  @override
  List<Object?> get props => [message];
}
