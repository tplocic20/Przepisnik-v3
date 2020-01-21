import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/components/single-recipe/single-recipe-container.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/models/routes.dart';

class SingleRecipe extends StatefulWidget {
  final Recipe recipe;

  SingleRecipe(this.recipe);

  @override
  _SingleRecipeState createState() => _SingleRecipeState();
}

class _SingleRecipeState extends State<SingleRecipe> {
  @override
  Widget build(BuildContext context) {
    return Backdrop(
      scope: Routes.recipes,
      title: widget.recipe.name,
      actionButtonLocation: FloatingActionButtonLocation.endFloat,
      backButtonOverride: true,
      bottomMainBtn: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.menu),
        elevation: 1,
        backgroundColor: Theme.of(context).accentColor,
      ),
      frontLayer: SingleRecipeContainer(widget.recipe),
      customActions: <Widget>[
        IconButton(
          icon: Icon(Icons.room_service),
          onPressed: () {
            print('szef');
          },
        ),
        IconButton(
          icon: Icon(Icons.pie_chart),
          onPressed: () {
            print('dzielenie');
          },
        )
      ],
    );
  }
}
