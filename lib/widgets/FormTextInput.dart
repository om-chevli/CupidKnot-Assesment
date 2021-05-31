import 'package:flutter/material.dart';

class FormTextInput extends StatelessWidget {
  final bool value;
  final String label;
  final TextInputType? kType;
  final TextEditingController textController;
  final String? Function(String?)? validate;
  final FocusNode? focus;
  final Function(String?)? save;

  FormTextInput({
    this.value = false,
    required this.label,
    this.kType,
    required this.textController,
    this.validate,
    this.focus,
    this.save,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      obscureText: value,
      controller: textController,
      keyboardType: kType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 17),
      ),
      style: TextStyle(fontSize: 17),
      validator: validate,
      focusNode: focus,
      onSaved: save,
    );
  }
}
