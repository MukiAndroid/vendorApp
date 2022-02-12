import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundedInputForm extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Function(String) callback;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType textInputType;
  final int max;
  final List<TextInputFormatter> list;
  const RoundedInputForm({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
    this.callback,
    this.textInputType,
    this.max,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        inputFormatters: list,
        validator: callback,
        onChanged: onChanged,
        maxLength: max,
        keyboardType: textInputType,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          counterText: '',
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
