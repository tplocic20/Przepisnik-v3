import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? icon;
  final bool? autofocus;
  final bool? isDense;
  final Widget? label;
  final Widget? prefix;
  final String? hint;
  final FocusNode? focusNode;

  const TextInput(
      {this.controller,
      this.prefix,
      this.onChanged,
      this.onFieldSubmitted,
      this.icon,
      this.autofocus,
      this.label,
      this.hint,
      this.isDense,
      this.focusNode,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon = this.icon != null
        ? Icon(this.icon, color: Theme.of(context).primaryColor)
        : null;
    return Center(
      child: TextFormField(
        controller: this.controller,
        autofocus: autofocus ?? false,
        onChanged: onChanged,
        onTap: onTap,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: Theme.of(context).primaryColor,
        cursorHeight: 15,
        decoration: InputDecoration(
            filled: true,
            prefixIcon: prefixIcon,
            prefix: this.prefix,
            label: this.label,
            hintText: this.hint,
            contentPadding: this.isDense != null && this.isDense!
                ? EdgeInsets.all(2)
                : null,
            fillColor: Color(0xFFDBDBDB),
            border: OutlineInputBorder(
              gapPadding: 2,
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                  width: 1),
            )),
        keyboardType: TextInputType.text,
        style: new TextStyle(
            fontFamily: "Poppins",
            fontSize: this.isDense != null && this.isDense! ? 16 : null,
            height: 1,
            letterSpacing: 1),
      ).height(this.isDense != null && this.isDense! ? 35 : 55),
    );
  }
}
