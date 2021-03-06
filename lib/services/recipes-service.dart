import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipesService {
  final _db = FirebaseDatabase.instance.reference();

  init() async {
    if (globals.categories != null && globals.categories.length > 0) {
      return;
    }
    await _db
        .child('Categories')
        .child(globals.userState)
        .once()
        .then((element) {
      globals.categories = parseCategories(element.value);
      return;
    });
  }

  Stream<Event> get recipeList {
    return _db
        .child('Recipes')
        .child(globals.userState)
        .onValue;
  }

  parseRecipes(element) {
    List<Recipe> parsedList = [];
    DataSnapshot dataValues = element.snapshot;
    Map<dynamic, dynamic> values = dataValues.value;
    values.forEach((key, values) {
      parsedList.add(Recipe(key, values));
    });
    return parsedList;
  }

  parseCategories(element) {
    List<Category> parsedList = [];
    if (element != null) {
      element.forEach((k, v) => parsedList.add(Category(k, v)));
    }
    return parsedList;
  }

  getCategoryByKey(key) {
    return globals.categories?.singleWhere((element) => element.key == key);
  }
}
