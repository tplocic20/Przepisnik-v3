import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeItem extends StatefulWidget {
  final Recipe? recipe;
  final bool? isLast;
  final SlidableController? slidableController;
  final String? selectedCategory;

  RecipeItem(
      {this.recipe,
      this.slidableController,
      this.isLast,
      this.selectedCategory});

  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Slidable(
          key: Key(widget.recipe!.key),
          controller: widget.slidableController,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: widget.isLast!
                                ? Colors.transparent
                                : Colors.grey))),
                child: ListTile(
                  onTap: () {
                    widget.slidableController!.activeState = null;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleRecipe(widget.recipe!)));
                  },
                  title: Hero(
                    tag: widget.recipe!.key,
                    child: Text(widget.recipe!.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 20)),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.recipe!.recipe, overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
              ),
            ),
          ),
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          actions: [
            IconSlideAction(
              caption: 'Edytuj',
              color: Colors.blue,
              icon: Icons.edit_rounded,
              onTap: () => {},
            ),
            IconSlideAction(
              caption: 'Usuń',
              color: Colors.red,
              icon: Icons.delete_forever_rounded,
              onTap: () => {},
            )
          ],
          secondaryActions: [
            IconSlideAction(
              caption: 'Ulubione',
              color: Colors.amber,
              icon: widget.recipe!.favourite == true
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              onTap: () => {},
            ),
            IconSlideAction(
              caption: 'Udostępnij',
              color: Colors.green,
              icon: Icons.share_rounded,
              onTap: () => {},
            ),
          ],
        ));
  }
}
