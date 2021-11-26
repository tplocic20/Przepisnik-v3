import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/categories-form.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeCategories extends StatefulWidget {
  final Recipe? recipe;
  final FormGroup? form;

  const EditRecipeCategories({this.recipe, this.form});

  @override
  _EditRecipeCategoriesState createState() => _EditRecipeCategoriesState();
}

class _EditRecipeCategoriesState extends State<EditRecipeCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CategoriesForm(),
    );
  }
}
