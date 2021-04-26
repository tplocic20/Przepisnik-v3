import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipe-item.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';

class RecipesList extends StatefulWidget {
  final String _currentCategory;
  final String _searchString;

  RecipesList(this._currentCategory, this._searchString);

  @override
  _RecipesListSate createState() => _RecipesListSate();
}

class _RecipesListSate extends State<RecipesList> {
  final SlidableController slidableController = SlidableController();

  Widget getRecipesList(List<Recipe> recipes) {
    List<Recipe> filteredRecipes = recipes.where((r) {
      final isCategory = widget._currentCategory == null ||
          r.categories.contains(widget._currentCategory);
      final isSearchResult = widget._searchString == null ||
          r.name.toLowerCase().contains(widget._searchString.toLowerCase());
      return isCategory && isSearchResult;
    }).toList();
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: filteredRecipes.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: SlideAnimation(
                horizontalOffset: 200,
                verticalOffset: 10,
                child: FadeInAnimation(
                    child: RecipeItem(
                  recipe: filteredRecipes[index],
                  slidableController: slidableController,
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  // RecipeItem(
  // recipe: r,
  // slidableController: slidableController,
  // )

  Widget getLoadingState() {
    return Container(
        child: Center(
      child: PlatformCircularProgressIndicator(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _recipesEvent = Provider.of<Event>(context);
    if (_recipesEvent != null) {
      return getRecipesList(RecipesService().parseRecipes(_recipesEvent));
    } else {
      return getLoadingState();
    }
  }
}
