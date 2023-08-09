import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeGallery extends StatelessWidget {
  final Recipe recipe;
  RecipeGallery(this.recipe);

  @override
  Widget build(BuildContext context) {

    return Icon(Icons.directions_transit);
  }

}