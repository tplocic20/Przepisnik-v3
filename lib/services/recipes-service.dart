import 'package:firebase_database/firebase_database.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipesService {
  static final RecipesService _singleton = RecipesService._internal();
  final _db = FirebaseDatabase.instance.ref();
  String _selectedCategory = '';
  List<Category> _categories = [];
  List<String> _units = [];

  factory RecipesService() {
    return _singleton;
  }

  RecipesService._internal();

  Future<void> init() {
    return _db
        .child('Users')
        .child(globals.userState)
        .once()
        .then((element) {
      this._categories = parseCategories(element.snapshot.value);
      this._units = parseUnits(element.snapshot.value);
      return;
    });
  }

  Stream<DatabaseEvent> get recipeList {
    return _db
        .child('Recipes')
        .child(globals.userState)
        .onValue;
  }

  List<Category> get categories {
    return this._categories;
  }

  List<String> get units {
    return this._units;
  }

  String get selectedCategory {
    return this._selectedCategory;
  }

  set selectedCategory(String value) {
    this._selectedCategory = value;
  }

  Future updateCategory(String key, Category category) {
    print(category.saveObject());
    return _db.child('Categories')
        .child(globals.userState).child(key).set(category.saveObject());
  }

  parseRecipes(DatabaseEvent element) {
    List<Recipe> parsedList = [];
    DataSnapshot dataValues = element.snapshot;
    Map<dynamic, dynamic> values = dataValues.value as Map<dynamic, dynamic>;
    values.forEach((key, values) {
      parsedList.add(Recipe(key, values));
    });
    return parsedList;
  }

  List<Category> parseCategories(element) {
    List<Category> parsedList = [];
    print(element);
    if (element != null) {
      element['Categories'].forEach((k, v) => parsedList.add(Category(k, v)));
    }
    return parsedList;
  }

  parseUnits(element) {
    List<String> parsedList = [];
    if (element != null) {
      element['Units'].forEach((k, v) => parsedList.add(v['Name']));
    }
    return parsedList;
  }

  getCategoryByKey(key) {
    try {
      return this._categories.singleWhere((element) => element.key == key);
    } catch (e) {
      return null;
    }
  }

  String prepareRecipeShareText(Recipe recipe) {
    List<String> textPartials = [];
    textPartials.add(recipe.name);

    if (recipe.temperature.isNotEmpty) {
      textPartials.add('Temperatura: ${recipe.temperature}');
    }

    if (recipe.time.isNotEmpty) {
      textPartials.add('Czas: ${recipe.time}');
    }

    recipe.ingredients.forEach((category) {
      textPartials.add('\n - ${category.name}');
      category.positions.forEach((position) {
        textPartials.add(
            '\t - ${position.name}, ${position.unit.isNotEmpty ? '${position
                .qty}, ${position.unit}' : ''}');
      });
    });

    textPartials.add('\n${recipe.recipe}');

    return textPartials.join('\n');
  }

  Future<dynamic> setFavourites(String key, bool newValue) {
    return this._db
        .child('Recipes')
        .child(globals.userState)
        .child(key)
        .child('Favourite')
        .set(newValue);
  }
}
