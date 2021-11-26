import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? icon;

  const TextInput({this.controller, this.onChanged, this.onFieldSubmitted, this.icon});

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon = this.icon != null ? Icon(this.icon, color: Theme.of(context).primaryColor) : null;
    return Center(
      child: TextFormField(
        controller: this.controller,
        autofocus: true,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            filled: true,
            prefixIcon: prefixIcon,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                  width: 1),
            )),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
