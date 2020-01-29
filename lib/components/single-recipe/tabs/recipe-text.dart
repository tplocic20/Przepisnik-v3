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
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: SliderTheme(
              data: SliderThemeData(
                thumbColor: Theme.of(context).primaryColor,
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).accentColor,
                overlayColor: Theme.of(context).primaryColorLight,
              ),
              child: Slider(
                value: fontSizeVM,
                min: 10,
                max: 25,
                divisions: 15,
                onChanged: (newSize) {
                  setState(() {
                    fontSizeVM = newSize;
                  });
                },
                onChangeEnd: (newSize) {
                  setState(() {
                    fontSize = newSize;
                  });
                },
              )),
        ),
        Center(
          child: Text('Rozmiar czcionki: ${fontSizeVM.toInt()}', style: TextStyle(fontSize: 10),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text(widget.recipe.recipe,
              style: TextStyle(
                  fontSize: fontSize, textBaseline: TextBaseline.alphabetic)),
        )
      ],
    );
  }
}
