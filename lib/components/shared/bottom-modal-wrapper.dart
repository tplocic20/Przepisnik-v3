import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomModalWrapper extends StatelessWidget {
  final Widget child;

  BottomModalWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: child,
          ),
        ),
      ),
    );
  }
}

class BottomModalSearchWrapper extends StatelessWidget {
  final Widget child;

  BottomModalSearchWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: child,
      ),
    );
  }
}
