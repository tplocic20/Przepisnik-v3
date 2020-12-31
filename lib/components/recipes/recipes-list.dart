import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes/recipe-item.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipesList extends StatefulWidget {
  final String _currentCategory;
  final String _searchString;

  RecipesList(this._currentCategory, this._searchString);

  @override
  _RecipesListSate createState() => _RecipesListSate();
}

class _RecipesListSate extends State<RecipesList> {
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    final _recipes = Provider.of<List<Recipe>>(context);
    return (_recipes != null && _recipes.isNotEmpty)
        ? ListView(
            children: _recipes
                .where((r) {
                  final isCategory = widget._currentCategory == null ||
                      r.categories.contains(widget._currentCategory);
                  final isSearchResult = widget._searchString == null ||
                      r.name
                          .toLowerCase()
                          .contains(widget._searchString.toLowerCase());
                  return isCategory && isSearchResult;
                })
                .map((r) => RecipeItem(recipe: r, slidableController: slidableController,))
                .toList(),
          )
        : Container(
            child: Center(
            child: PlatformCircularProgressIndicator(),
          ));
  }
}
