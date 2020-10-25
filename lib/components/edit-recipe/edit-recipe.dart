import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class EditRecipe extends StatefulWidget {

  @override
  _EditRecipeState createState() => _EditRecipeState();

}

class _EditRecipeState extends State<EditRecipe> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Text('xD'),
      )
    );
  }

}