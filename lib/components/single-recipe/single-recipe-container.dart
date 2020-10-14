
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/single-recipe/tabs/recipe-gallery.dart';
import 'package:przepisnik_v3/components/single-recipe/tabs/recipe-info.dart';
import 'package:przepisnik_v3/components/single-recipe/tabs/recipe-text.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class SingleRecipeContainer extends StatefulWidget {
  final Recipe recipe;
  final double portion;
  SingleRecipeContainer({this.recipe, this.portion});

  @override
  _SingleRecipeContainerState createState() => _SingleRecipeContainerState();
}

class _SingleRecipeContainerState extends State<SingleRecipeContainer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Column(
        children: <Widget>[
          new Container(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: new TabBar(
              unselectedLabelColor: Theme.of(context).primaryColorLight,
              labelColor: Theme.of(context).primaryColorDark,
              indicatorColor: Theme.of(context).primaryColorDark,
              tabs: [
                new Tab(text: 'Informacje'),
                new Tab(text: 'Przepis'),
                new Tab(text: 'Galeria'),
              ],
            ),
          ),
          new Expanded(
            child: new TabBarView(
              children: [
                new RecipeInfo(recipe: widget.recipe, portion: widget.portion),
                new RecipeText(widget.recipe),
                new RecipeGallery(widget.recipe),
              ],
            ),
          ),
        ],
      ),
    );
  }

}