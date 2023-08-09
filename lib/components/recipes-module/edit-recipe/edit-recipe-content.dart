import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/edit-recipe-igredients.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/edit-recipe-info.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/edit-recipe-text.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeContent extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeContent({@required required this.recipe});

  @override
  _EditRecipeContentState createState() => _EditRecipeContentState();
}

class _EditRecipeContentState extends State<EditRecipeContent> {

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
                Tab(text: 'Składniki'),
                Tab(text: 'Przepis'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                EditRecipeInfo(recipe: widget.recipe),
                EditRecipeIngredients(recipe: widget.recipe),
                EditRecipeText(recipe: widget.recipe)
              ],
            ),
          ),
        ],
      ).backgroundColor(Colors.transparent),
    );
  }
}
