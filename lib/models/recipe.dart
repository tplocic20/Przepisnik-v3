import 'package:przepisnik_v3/models/baseElement.dart';

class Recipe extends BaseElement {
  String categories = '';
  List<IngredientGroup> ingredients = [];
  String recipe = '';
  List<RecipeStep> recipeSteps = [];
  bool favourite = false;
  var temperature = '';
  var time = '';

  Recipe(k, v) {
    key = k;
    categories = v['Categories'];
    ingredients = parseIngredients(v['Engredients'] ?? []);
    name = v['Name'];
    recipe = v['Recipe'] ?? '';
    temperature = v['Temperature'] ?? '';
    time = v['Time'] ?? '';
    favourite = v['Favourite'] ?? false;
  }

  Recipe.empty();

  Recipe.from(Recipe r) {
    key = r.key;
    categories = r.categories;
    ingredients = r.ingredients;
    name = r.name;
    recipe = r.recipe;
    temperature = r.temperature;
    time = r.time;
    favourite = r.favourite;

  }

  parseIngredients(items) {
    List<IngredientGroup> parsedList = [];
    for( var i = 0 ; i < items!.length; i++ ) {
      parsedList.add(IngredientGroup(items[i]));
    }
    return parsedList;
  }
}

class RecipeStep {
  String name = '';
  List<String> ingredients = [];
  String content = '';

  RecipeStep.from(v) {
    name = v['name'] ?? '';
    content = v['content'] ?? '';
    ingredients = (v['ingredients'] ?? '').toString().split(';');
  }

  RecipeStep(String n) {
    name = n;
  }
}

class IngredientGroup {
  String color = '';
  String name = '';
  List<Ingredient> positions = [];

  IngredientGroup(v) {
    color = v['Color'] ?? '';
    name = v['Name'] ?? '';
    positions = parsePositions(v['Positions']);
  }

  IngredientGroup.empty(String n) {
    name = n;
  }

  parsePositions(items) {
    List<Ingredient> parsedList = [];
    if (items != null) {
      for( var i = 0 ; i < items!.length; i++ ) {
        parsedList.add(Ingredient(items[i]));
      }
    }
    return parsedList;
  }
}

class Ingredient {
  String name = '';
  double qty = 0;
  String unit = '';

  Ingredient(v) {
    name = v['Name'] ?? '';
    unit = v['Unit'] ?? '';
    if (v['Qty'] != null) {
      if (v['Qty'] is double) {
        qty = v['Qty'];
      } else if (v['Qty'] is int) {
        qty = (v['Qty'] as int).toDouble();
      } else {
        qty = double.tryParse((v['Qty'] as String).replaceAll(',', '.')) ?? 0.0;
      }
    }
  }

  Ingredient.empty(String n, String u, double q) {
    name = n;
    unit = u;
    qty = q;
  }
}