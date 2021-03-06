import 'package:przepisnik_v3/models/baseElement.dart';

class Recipe extends BaseElement {
  String categories;
  List<IngredientGroup> ingredients;
  String recipe;
  var temperature;
  var time;

  Recipe(k, v) {
    key = k;
    categories = v['Categories'];
    ingredients = parseIngredients(v['Engredients']);
    name = v['Name'];
    recipe = v['Recipe'];
    temperature = v['Temperature'];
    time = v['Time'];
    favourite = v['Favourite'];
  }

  parseIngredients(items) {
    List<IngredientGroup> parsedList = [];
    for( var i = 0 ; i < items.length; i++ ) {
      parsedList.add(IngredientGroup(items[i]));
    }
    return parsedList;
  }
}

class IngredientGroup {
  String color;
  String name;
  List<Ingredient> positions;

  IngredientGroup(v) {
    color = v['Color'];
    name = v['Name'];
    positions = parsePositions(v['Positions']);
  }
  parsePositions(items) {
    List<Ingredient> parsedList = [];
    if (items != null) {
      for( var i = 0 ; i < items.length; i++ ) {
        parsedList.add(Ingredient(items[i]));
      }
    }
    return parsedList;
  }
}

class Ingredient {
  String name;
  var qty;
  String unit;
  Ingredient(v) {
    name = v['Name'];
    qty = v['Qty'];
    unit = v['Unit'];
  }
}