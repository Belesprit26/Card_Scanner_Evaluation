import 'package:first_app/features/card_validation/presentation/utils/card_type.dart';
import 'package:first_app/features/card_validation/presentation/utils/payment_card.dart';
import 'package:first_app/features/card_validation/presentation/pages/card_list_page.dart';
import 'package:first_app/features/card_validation/presentation/pages/widgets/card_month_input_formatter.dart';
import 'package:first_app/features/card_validation/presentation/pages/widgets/card_utils.dart';
import 'package:first_app/features/card_validation/presentation/pages/widgets/country_search_field.dart';
import 'package:first_app/features/card_validation/presentation/pages/widgets/custom_text_field.dart';
import 'package:first_app/features/card_validation/presentation/utils/banned_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_bloc.dart';
import 'card_scanner_page.dart';


class CardFormPage extends StatefulWidget {
  @override
  _CardFormPageState createState() => _CardFormPageState();
}

class _CardFormPageState extends State<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _issuingCountryController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard(); // Create an instance of PaymentCard

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _cvvController.dispose();
    _expiryDateController.dispose();
    _issuingCountryController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();  // Save the form state

      //Prevent invalid card from saving
      void _getCardTypeFromNumber() {
        String input = CardUtils.getCleanedNumber(_numberController.text);
        CardType cardType = CardUtils.getCardTypeFromNumber(input);
        setState(() {
          _paymentCard.type = cardType;
        });
      }
      //Prevent Banned country issued cards from being saved
      if (BannedCountries.isCountryBanned(_issuingCountryController.text)) {
        _showSnackbar("This country is banned");
      } else {
        final card = CreditCard(
          name: _nameController.text,
          cardNumber: _numberController.text,
          cvv: int.parse(_cvvController.text),
          expireMonth: int.parse(_expiryDateController.text.split('/')[0]),
          expireYear: int.parse(_expiryDateController.text.split('/')[1]),
          issuingCountry: _issuingCountryController.text,
        );
        BlocProvider.of<CardBloc>(context).add(AddCardEvent(card));
      }
    } else {
      _showSnackbar("Please fill all the fields correctly.");
    }
  }

  Future<void> scanCard() async {
    // Clear text fields before scanning
    setState(() {
      _numberController.clear();
      _expiryDateController.clear();
    });

    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardScannerPage()),
    );

    if (scannedData != null) {
      setState(() {
        _numberController.text = scannedData['cardNumber'];
        _expiryDateController.text = scannedData['expiryDate'];
        _getCardTypeFromNumber();
      });

      // Print the scanned information
      print("Scanned Card Number: ${scannedData['cardNumber']}");
      print("Scanned Expiry Date: ${scannedData['expiryDate']}");
    }
  }


  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _getCardTypeFromNumber() {
    String input = CardUtils.getCleanedNumber(_numberController.text);
    CardType cardType = CardUtils.getCardTypeFromNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Validator'),
        actions: [
          BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is CardsLoaded) {
                return IconButton(
                  icon: Stack(
                    children: [
                      Icon(Icons.credit_card,size: 27,),
                      if (state.cards.isNotEmpty)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              state.cards.length.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardListPage(),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Card Holder Name',
                hintText: 'Enter the name on the card',
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                onSaved: (value) => _nameController.text = value ?? '',
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _numberController,
                      labelText: 'Card Number',
                      hintText: 'Enter the card number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19), // Adjust the max length if necessary
                        CardNumberInputFormatter(), // Add this input formatter
                      ],
                      validator: (value) => CardUtils.validateCardNum(value),
                      onChanged: (value) {
                        _getCardTypeFromNumber();
                      },
                      onSaved: (value) => _numberController.text = value?.replaceAll(' ', '') ?? '',
                    ),
                  ),
                  SizedBox(width: 10),
                  if (_paymentCard.type != CardType.Others)
                    CardUtils.getCardIcon(_paymentCard.type) ?? Container(),
                ],
              ),
              CustomTextField(
                controller: _cvvController,
                labelText: 'CVV',
                hintText: 'Enter the CVV',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => CardUtils.validateCVV(value),
                onSaved: (value) => _cvvController.text = value ?? '',
              ),
              CustomTextField(
                controller: _expiryDateController,
                labelText: 'Expiry Date (MM/YY)',
                hintText: 'Enter the expiry date',
                keyboardType: TextInputType.number,
                inputFormatters: [CardMonthInputFormatter()],
                validator: (value) => CardUtils.validateDate(value),
                onSaved: (value) => _expiryDateController.text = value ?? '',
              ),
              CountrySearchField(
                controller: _issuingCountryController,
                onSaved: (value) => _issuingCountryController.text = value ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: scanCard,
                child: Text('Scan Card'),
              ),
              BlocListener<CardBloc, CardState>(
                listener: (context, state) {
                  if (state is CardAdded) {
                    _showSnackbar('Card added successfully');
                  } else if (state is CardError) {

                    _showSnackbar(state.message);
                    BlocProvider.of<CardBloc>(context).reloadCards();
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
