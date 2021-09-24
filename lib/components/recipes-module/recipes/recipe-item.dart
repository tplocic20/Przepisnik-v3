import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipeItem extends StatefulWidget {
  final Recipe? recipe;
  final bool? isLast;
  final bool? isFirst;
  final String? selectedCategory;
  final SlidableController? slidableController;

  RecipeItem(
      {this.recipe,
      this.isLast,
      this.isFirst,
      this.selectedCategory,
      this.slidableController});

  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> with TickerProviderStateMixin {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Styled.widget(
            child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.22,
      controller: widget.slidableController,
      child: _buildTile(),
      actions: _buildActions(),
    ))
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .backgroundColor(Colors.transparent, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(20,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Color(0x30000000)) // shadow borderRadius
        .constrained(height: 80)
        .padding(bottom: 12, horizontal: 10, top: widget.isFirst! ? 12 : 0) // margin
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
    )
        .ripple()
        .gestures(onTap: () {
          print(widget.slidableController!);
          widget.slidableController!.activeState = null;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SingleRecipe(widget.recipe!)));
        })
        .backgroundColor(Colors.white)
        .clipRRect(all: 25);
  }

  List<Widget> _buildActions() {
    List<Widget> buttons = [
      getButton(action: () {}, icon: Icons.delete_rounded, color: Color(0xFFF46060)),
      getButton(
          action: () {},
          icon: Icons.create_rounded,
          color: Color(0xFFB5DEFF)),
      getButton(action: () {}, icon: Icons.share_rounded, color: Color(0xFFCBE2B0)),
      getButton(
          action: () {},
          icon: Icons.favorite_outline_rounded,
          color: Color(0xFFF3D179)),
    ];
    return buttons;
  }

  Widget getButton({color: Color, icon: Icons, action: Function}) {
    return ElevatedButton(
        onPressed: action,
        child: Icon(icon).padding(all: 0),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        )).width(60).height(50).padding(vertical: 15, horizontal: 10);
  }
}
