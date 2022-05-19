import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes-list.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage();

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<RecipesPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<DatabaseEvent?>.value(
        initialData: null,
        value: RecipesService().recipeList,
        child:  RecipesList());
  }
}
