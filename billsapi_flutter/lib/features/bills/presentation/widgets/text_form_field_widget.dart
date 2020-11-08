import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) validator;
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  const TextFormFieldWidget({
    Key key,
    @required this.controller,
    @required this.validator,
    @required this.label,
    @required this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: label,
        ),
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLengthEnforced: true,
      ),
    );
  }
}
