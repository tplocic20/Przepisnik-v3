import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/tabs/recipe-gallery.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/tabs/recipe-info.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/tabs/recipe-text.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class SingleRecipeContainer extends StatefulWidget {
  final Recipe? recipe;
  final double? portion;
  final double? textSize;
  final bool? cookMode;
  final Stream? cookModeReset;

  SingleRecipeContainer(
      {this.recipe, this.portion, this.cookMode, this.textSize, this.cookModeReset});

  @override
  _SingleRecipeContainerState createState() => _SingleRecipeContainerState();
}

class _SingleRecipeContainerState extends State<SingleRecipeContainer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: TabBar(
              unselectedLabelColor: Theme.of(context).primaryColorLight,
              labelColor: Theme.of(context).primaryColorDark,
              indicatorColor: Theme.of(context).primaryColorDark,
              tabs: [
                Tab(text: 'Informacje'),
                Tab(text: 'Przepis'),
                Tab(text: 'Galeria'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                RecipeInfo(
                    recipe: widget.recipe!,
                    portion: widget.portion!,
                    cookMode: widget.cookMode!,
                    cookModeReset: widget.cookModeReset!
                ),
                RecipeText(recipe: widget.recipe!, textSize: widget.textSize),
                RecipeGallery(widget.recipe!),
              ],
            ),
          ),
        ],
      ).backgroundColor(Colors.transparent),
    );
  }
}
