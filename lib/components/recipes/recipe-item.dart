import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;

  RecipeItem({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleRecipe(recipe)),
                  );
                },
                title: Hero(
                  tag: recipe.key,
                  child: Text(recipe.name, style: Theme.of(context).textTheme.bodyText2),
                ),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 1.0,
              color: Theme.of(context).primaryColor,
            )
          ],
        ));
  }
}
