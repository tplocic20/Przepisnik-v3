import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomModalWrapper extends StatelessWidget {
  final Widget child;

  BottomModalWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: child,
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
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: child,
    );
  }
}
