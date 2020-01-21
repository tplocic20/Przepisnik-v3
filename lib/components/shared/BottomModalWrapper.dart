import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomModalWrapper extends StatelessWidget {
  final Widget child;
  BottomModalWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: child,
      ),
    );
  }

}
