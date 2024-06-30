import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved; // Add this line
  final ValueChanged<String>? onChanged; // Add this line

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onSaved, // Add this line
    this.onChanged, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onSaved: onSaved, // Add this line
        onChanged: onChanged, // Add this line
      ),
    );
  }
}
