import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeItem extends StatefulWidget {
  final Recipe recipe;

  RecipeItem({this.recipe});

  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem>
    with SingleTickerProviderStateMixin {
  bool _actionsOpened = false;
  Animation<double> _actionsAnimation;
  AnimationController _actionsAnimationController;

  void initState() {
    super.initState();
    _actionsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _actionsAnimation = CurvedAnimation(
        curve: Curves.linear, parent: _actionsAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleRecipe(widget.recipe)),
                  );
                },
                title: Hero(
                  tag: widget.recipe.key,
                  child: Text(widget.recipe.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 20)),
                ),
                trailing: IconButton(
                    icon: AnimatedIcon(
                      progress: _actionsAnimation,
                      icon: AnimatedIcons.menu_close,
                    ),
                    onPressed: _toggleActions),
              ),
            ),
          ],
        ));
  }

  void _toggleActions() {
    if (_actionsOpened = !_actionsOpened) {
      _actionsAnimationController.reverse();
    } else {
      _actionsAnimationController.forward();
    }
  }
}
