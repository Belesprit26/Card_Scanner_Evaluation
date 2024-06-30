import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/card_validation/presentation/bloc/card_bloc.dart';
import 'features/card_validation/presentation/pages/card_form_page.dart';
import 'features/card_validation/data/datasources/card_local_data_source.dart';
import 'features/card_validation/data/repositories/card_repository_impl.dart';
import 'features/card_validation/domain/usecases/add_card.dart';
import 'features/card_validation/domain/usecases/get_cards.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final cardLocalDataSource = CardLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final cardRepository = CardRepositoryImpl(localDataSource: cardLocalDataSource);
  runApp(MyApp(cardRepository: cardRepository));
}

class MyApp extends StatelessWidget {
  final CardRepositoryImpl cardRepository;

  MyApp({required this.cardRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => CardBloc(
            addCard: AddCard(cardRepository),
            getCards: GetCards(cardRepository),
            cardRepository: cardRepository, // Add this line
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Card Validator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CardFormPage(),
      ),
    );
  }
}
