import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe-content.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class EditRecipe extends StatefulWidget {
  final Recipe? recipe;

  EditRecipe({this.recipe});

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {

  Recipe recipe = Recipe.empty();

  @override
  void initState() {
    if (widget.recipe != null) {
      this.recipe = Recipe.from(widget.recipe!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropSimple(
        frontLayer: EditRecipeContent(recipe: this.recipe),
        action: () {},
        title: Text(this.recipe.name.isNotEmpty ? this.recipe.name : 'Nowy przepis'));
  }
}
