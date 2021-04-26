import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeText extends StatefulWidget {
  final Recipe recipe;

  RecipeText(this.recipe);

  @override
  _RecipeTextState createState() => _RecipeTextState();
}

class _RecipeTextState extends State<RecipeText> {
  double fontSizeVM = 15;
  double fontSize = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 35),
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Text(widget.recipe.recipe,
              style: TextStyle(
                  fontSize: fontSize, textBaseline: TextBaseline.alphabetic)),
        ),
      ),
    );
  }
}
