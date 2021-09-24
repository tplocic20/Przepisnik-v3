import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:rxdart/rxdart.dart';

class RecipesService {
  static final RecipesService _singleton = RecipesService._internal();
  final _db = FirebaseDatabase.instance.reference();
  String _selectedCategory = '';
  List<Category> _categories = [];

  factory RecipesService() {
    return _singleton;
  }
  RecipesService._internal();


  init() async {
    await _db
        .child('Categories')
        .child(globals.userState)
        .once()
        .then((element) {
      this._categories = parseCategories(element.value);
      return;
    });
  }

  Stream<Event> get recipeList {
    return _db
        .child('Recipes')
        .child(globals.userState)
        .onValue;
  }

  List<Category> get categories {
    return this._categories;
  }
  String get selectedCategory {
    return this._selectedCategory;
  }

  set selectedCategory(String value) {
    this._selectedCategory = value;
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
    return this._categories.singleWhere((element) => element.key == key);
  }
}
