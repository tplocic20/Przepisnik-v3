import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipeText extends StatefulWidget {
  final Recipe? recipe;
  final double? textSize;

  RecipeText({this.recipe, this.textSize});

  @override
  _RecipeTextState createState() => _RecipeTextState();
}

class _RecipeTextState extends State<RecipeText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Text(widget.recipe!.recipe,
                        style: TextStyle(
                            fontSize: widget.textSize,
                            textBaseline: TextBaseline.alphabetic))
                    .padding(bottom: 100),
              ),
            ),
          )
        ],
      ).paddingDirectional(all: 15),
    );
  }
}
