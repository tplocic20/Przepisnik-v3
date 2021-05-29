import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeText extends StatefulWidget {
  final Recipe recipe;

  RecipeText(this.recipe);

  @override
  _RecipeTextState createState() => _RecipeTextState();
}

class _RecipeTextState extends State<RecipeText> {
  double fontSizeVM = 17;
  double fontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Villain(
        villainAnimation: VillainAnimation.scale(),
        child: Container(
          // elevation: 0.5,
          // shadowColor: Theme.of(context).primaryColorLight,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
          // borderOnForeground: false,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(25))
          // ),
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(widget.recipe.recipe,
                style: TextStyle(
                    fontSize: fontSize, textBaseline: TextBaseline.alphabetic)),
          ),
        ),
      ),
    );
  }
}
