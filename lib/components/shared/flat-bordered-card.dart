import 'package:flutter/material.dart';

class FlatBorderedCard extends StatelessWidget {
  final String _title;
  final Widget _content;

  const FlatBorderedCard(this._title, this._content);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle,
          ),
          child: this._content,
        ),
        Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              color: Colors.white,
              child: Text(
                this._title,
                style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 12),
              ),
            )),
      ],
    );
  }
}
