import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe-content.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class EditRecipe extends StatefulWidget {
  Recipe? recipe;

  EditRecipe() {
      this.recipe = Recipe.empty();
  }
  EditRecipe.withRecipe({this.recipe});

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  @override
  Widget build(BuildContext context) {
    return BackdropSimple(
        frontLayer: EditRecipeContent(recipe: widget.recipe),
        title: Text(widget.recipe!.name.isNotEmpty ? widget.recipe!.name : 'Nowy przepis'));
  }
}
