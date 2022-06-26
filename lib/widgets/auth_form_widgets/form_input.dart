import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    Key? key,
    required FocusNode fieldFocusNode,
    FocusNode? nextFieldFocusNode,
    this.label = "",
    required this.validation,
    this.onFieldSubmit,
    this.inputDecoration,
    this.obscureText = false,
    this.onSaved,
    required this.onChanged,
  })  : _fieldFocusNode = fieldFocusNode,
        _nextFieldFocusNode = nextFieldFocusNode,
        super(key: key);
  final String label;
  final FocusNode _fieldFocusNode;
  final FocusNode? _nextFieldFocusNode;
  final Function validation;
  final InputDecoration? inputDecoration;
  final Function(String)? onFieldSubmit;
  final bool obscureText;
  final Function? onSaved;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: inputDecoration ?? InputDecoration(labelText: label),
      focusNode: _fieldFocusNode,
      validator: (value) {
        //Can add validation as suitable
        // if (regEx.hasMatch(input))
        return validation(value);
      },
      onFieldSubmitted: onFieldSubmit ??
          (value) {
            FocusScope.of(context).requestFocus(_nextFieldFocusNode);
          },
      onSaved: (value) {
        onSaved!(value);
      },
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
