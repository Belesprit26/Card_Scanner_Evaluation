import 'package:first_app/features/card_validation/presentation/pages/widgets/card_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/card_bloc.dart';

class CardListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Cards'),
      ),
      body: BlocBuilder<CardBloc, CardState>(
        builder: (context, state) {
          if (state is CardsLoaded) {
            if (state.cards.isEmpty) {
              return Center(child: Text('No cards available.'));
            } else {
              return ListView.builder(
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  final cardType = CardUtils.getCardTypeFromNumber(card.cardNumber);

                  return ListTile(
                    leading: CardUtils.getCardIcon(cardType),
                    title: Text(card.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card Number: ${card.cardNumber}'),
                        Text('Card Type: $cardType'),
                        Text('Expiry Date: ${card.expireMonth}/${card.expireYear}'),
                        Text('Issuing Country: ${card.issuingCountry}'),
                      ],
                    ),
                  );
                },
              );
            }
          } else if (state is CardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CardError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
