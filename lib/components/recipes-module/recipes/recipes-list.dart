import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipe-item.dart';
import 'package:przepisnik_v3/components/shared/Loader.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipesList extends StatefulWidget {
  final String _currentCategory;
  final String _searchString;

  RecipesList(this._currentCategory, this._searchString);

  @override
  _RecipesListSate createState() => _RecipesListSate();
}

class _RecipesListSate extends State<RecipesList> {

  String? openedRecipe;

  void initState() {
    super.initState();
    openedRecipe = null;
  }

  void openRecipe(String? recipeKey) {
    print(recipeKey);
    this.setState(() {
      openedRecipe = recipeKey ?? null;
    });
  }

  Widget getRecipesList(List<Recipe> recipes) {
    List<Recipe> filteredRecipes = recipes.where((r) {
      final isCategory = widget._currentCategory == null ||
          r.categories.contains(widget._currentCategory);
      final isSearchResult = widget._searchString == null ||
          r.name.toLowerCase().contains(widget._searchString.toLowerCase());
      return isCategory && isSearchResult;
    }).toList();
    return filteredRecipes.length > 0
        ? AnimationLimiter(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 250),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: SlideAnimation(
                        horizontalOffset: 200,
                        verticalOffset: 10,
                        child: FadeInAnimation(
                          child: RecipeItem(
                        recipe: filteredRecipes[index],
                        isLast: filteredRecipes.length > index + 1,
                        selectedCategory: widget._currentCategory,
                        openedRecipe: openedRecipe,
                        openRecipe: openRecipe,
                      )),
                    ),
                    ),
                  );
                },
              ),
            ).padding(bottom: 50)
        : Center(
            child: Text(
              '¯\\_(ツ)_/¯\n ${widget._searchString.length > 0 ? 'Nic nie znaleziono' : 'Brak przepisów w bazie\nPora jakiś dodać'}',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getLoadingState() {
    return Container(
        child: Center(
      child: Loader(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _recipesEvent = Provider.of<Event?>(context);
    if (_recipesEvent != null) {
      return getRecipesList(RecipesService().parseRecipes(_recipesEvent));
    } else {
      return getLoadingState();
    }
  }
}
