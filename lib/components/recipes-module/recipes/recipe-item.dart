import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';


class RecipeItem extends StatefulWidget {
  final Recipe? recipe;
  final String? openedRecipe;
  final Function? openRecipe;
  final bool? isLast;
  final String? selectedCategory;

  RecipeItem({this.recipe, this.isLast, this.selectedCategory, this.openedRecipe, this.openRecipe});

  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem>
    with SingleTickerProviderStateMixin {
  bool pressed = false;

  void initState() {
    super.initState();
    pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Styled.widget(child: Stack(
      children: [_buildTile(), _buildActions()],
    ))
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Colors.white, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(pressed ? 0 : 20,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Color(0x30000000)) // shadow borderRadius
        .constrained(height: 80)
        .padding(bottom: 12) // margin
        .gestures(
            onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
            onLongPressEnd: (details) => widget.openRecipe!(widget.recipe?.key),
            onTap: () {
              widget.openRecipe!(null);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleRecipe(widget.recipe!)));
            })
        .scale(all: pressed ? 0.95 : 1.0, animate: true)
        .animate(Duration(milliseconds: 150), Curves.easeOut);
  }

  Widget _buildTile() {
    return ListTile(
      title: Hero(
        tag: widget.recipe!.key,
        child: Text(widget.recipe!.name,
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 20)),
      ),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.recipe!.recipe, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (widget.openedRecipe != widget.recipe!.key) {
      return Container();
    }
    const shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)));
    List<Widget> buttons = [
      ElevatedButton(onPressed: (){}, child: const Icon(Icons.delete_rounded).padding(all: 0), style: ElevatedButton.styleFrom(
        primary: Colors.red, shape: shape,
      )).width(60).height(50).padding(vertical: 15, left: 5, right: 15),
      ElevatedButton(onPressed: (){}, child: const Icon(Icons.create_rounded).padding(all: 0), style: ElevatedButton.styleFrom(
        primary: Theme.of(context).accentColor, shape: shape,
      )).width(60).height(50).padding(vertical: 15, horizontal: 5),
      ElevatedButton(onPressed: (){}, child: const Icon(Icons.share_rounded).padding(all: 0), style: ElevatedButton.styleFrom(
        primary: Colors.green, shape: shape,
      )).width(60).height(50).padding(vertical: 15, horizontal: 5),
      ElevatedButton(onPressed: (){}, child: const Icon(Icons.favorite_outline_rounded).padding(all: 0), style: ElevatedButton.styleFrom(
        primary: Colors.amber, shape: shape,
      )).width(60).height(50).padding(vertical: 15, horizontal: 5),
    ];
    return AnimationLimiter(child: ListView.builder(
        itemCount: buttons.length,
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => AnimationConfiguration.staggeredList(
            position: index, duration: const Duration(milliseconds: 0),
            child: ScaleAnimation(child: FadeInAnimation(child: buttons[index]))
        )
    ));
  }
}
