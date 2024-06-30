part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}

class AddCardEvent extends CardEvent {
  final CreditCard card;

  AddCardEvent(this.card);

  @override
  List<Object?> get props => [card];
}

class GetCardsEvent extends CardEvent {}
