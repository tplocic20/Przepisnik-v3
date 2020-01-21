class Recipe {
  String key;
  String categories;
  List<IngredientGroup> ingredients;
  String name;
  String recipe;
  var temperature;
  var time;
  bool favourite;

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
    items.forEach((v) => parsedList.add(IngredientGroup(v)));
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
    items.forEach((v) => parsedList.add(Ingredient(v)));
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