import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({Recipe? recipe});

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  @override
  Widget build(BuildContext context) {
    return Backdrop(frontLayer: Container(), backLayer: [],);
  }
}
