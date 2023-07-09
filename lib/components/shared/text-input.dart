import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:styled_widget/styled_widget.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final String? icon;
  final bool? autofocus;
  final bool? isDense;
  final bool? isNumeric;
  final bool? isFilled;
  final Widget? label;
  final BorderRadius? radius;
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final List<String>? autoComplete;
  final FocusNode? focusNode;

  const TextInput(
      {this.controller,
      this.prefix,
      this.suffix,
      this.onChanged,
      this.onFieldSubmitted,
      this.icon,
      this.autofocus,
      this.isNumeric,
      this.isFilled,
      this.label,
      this.radius,
      this.hint,
      this.autoComplete,
      this.isDense,
      this.focusNode,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon = this.icon != null
        ? PrzepisnikIcon(
                icon: this.icon!, color: Theme.of(context).primaryColor)
            .padding(horizontal: 5, vertical: 10)
        : null;
    return TextFormField(
      controller: this.controller,
      autofocus: autofocus ?? false,
      onChanged: onChanged,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      keyboardType:
          this.isNumeric == true ? TextInputType.number : TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        this.isNumeric == true
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      onTap: onTap,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: Theme.of(context).primaryColor,
      cursorHeight: 15,
      decoration: InputDecoration(
          filled: this.isFilled,
          prefixIcon: prefixIcon,
          prefix: this.prefix,
          suffix: this.suffix,
          label: this.label,
          hintText: this.hint,
          contentPadding:
              this.isDense != null && this.isDense! ? EdgeInsets.all(2) : null,
          fillColor: Color(0xFFDBDBDB),
          focusedBorder: OutlineInputBorder(
            borderRadius: this.radius ?? BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.PRIMARY),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: this.radius ?? BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: this.radius ?? BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.ERROR),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: this.radius ?? BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.ERROR),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          )),
      style: new TextStyle(
          fontFamily: "Montserrat",
          fontSize: this.isDense != null && this.isDense! ? 16 : null,
          height: 1,
          letterSpacing: 1),
    ).animate(Duration(milliseconds: 150), Curves.easeOut).height(this.isDense != null && this.isDense! ? 35 : 55);
  }
}
