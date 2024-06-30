import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountrySearchField extends StatelessWidget {
  final TextEditingController controller;

  const CountrySearchField({super.key, required this.controller, final FormFieldSetter<String>? onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Issuing Country',
          hintText: 'Select the issuing country',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: false,
            onSelect: (Country country) {
              controller.text = country.name;
            },
          );
        },
      ),
    );
  }
}
