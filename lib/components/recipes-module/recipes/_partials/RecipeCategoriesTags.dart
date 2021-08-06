import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';

class RecipeCategoriesTags extends StatelessWidget {
  final Recipe? recipe;
  final String? selectedCategory;

  RecipeCategoriesTags({this.recipe, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    List<String> categoriesArray = this.recipe!.categories.replaceAll(';', ',').split(',').where((element) => element.length > 0).toList();
    return categoriesArray.isNotEmpty ? Tags(
      runSpacing: 6,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      itemCount: categoriesArray.length,
      itemBuilder: (int index) {
        Category cat =
            RecipesService().getCategoryByKey(categoriesArray[index]);
        return ItemTags(
          index: index,
          key: Key('${this.recipe!.key}_${cat.key ?? ''}'),
          title: cat.name ?? '',
          activeColor: Theme.of(context).accentColor,
          active: false,
          elevation: 0,
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: cat.key == this.selectedCategory ? 1.5 : 0.5
          ),
        );
      },
    ) : Container();
  }
}
