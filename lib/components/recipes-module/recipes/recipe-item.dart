import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:share_plus/share_plus.dart';
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
      child: this._buildTile(context),
      actions: this._buildActions(context),
    ))
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .backgroundColor(Colors.transparent, animate: true)
        .constrained(height: 100)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(20,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Color(0x30000000)) // shadow borderRadius
        .padding(
            bottom: 12, horizontal: 10, top: widget.isFirst! ? 12 : 0) // margin
        .animate(Duration(milliseconds: 150), Curves.easeOut);
  }

  Widget _buildTile(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Container(
          child: Row(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.recipe!.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 20)
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    children: this._buildTags(context),
                  ).height(30)
                ],
              )),
              widget.recipe!.favourite ? Icon(Icons.favorite_rounded,
                  color: Colors.amber, size: 24) : Container()
            ],
          ).padding(vertical: 0, horizontal: 15),
        ).ripple().backgroundColor(Colors.white).clipRRect(all: 25);
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        widget.slidableController!.activeState = null;
        return SingleRecipe(widget.recipe!);
      },
    ).clipRRect(all: 25).borderRadius(all: 25, animate: true);
  }

  List<Widget> _buildTags(BuildContext context) {
    return widget.recipe!.categories
        .replaceAll(';', ',')
        .split(',')
        .map((category) => _buildCategoryTag(
            RecipesService().getCategoryByKey(category), context))
        .toList();
  }

  Widget _buildCategoryTag(Category? category, BuildContext context) {
    if (category == null) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(category.name).padding(all: 3),
    ).paddingDirectional(end: 5);
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> buttons = [
      this._getButton(
          action: () {}, icon: Icons.delete_rounded, color: Color(0xFFF46060)),
      // getButton(
      //     action: () {}, icon: Icons.create_rounded, color: Color(0xFFB5DEFF)),
      this._getEditButton(context),
      this._getButton(
          action: () {
            this._share(context);
          },
          icon: Icons.share_rounded,
          color: Color(0xFFCBE2B0)),
      this._getButton(
          action: () {
            this._toggleFavourites(context);
          },
          icon: widget.recipe!.favourite
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          color: Color(0xFFF3D179)),
    ];
    return buttons;
  }

  Widget _getEditButton(BuildContext context) {
    return OpenContainer(
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return SizedBox(
            height: 50,
            width: 60,
            child: Center(
              child: Icon(
                Icons.create_rounded,
                color: Colors.white,
              ),
            ),
          ).backgroundColor(Color(0xFFB5DEFF));
        },
        middleColor: Color(0xFFB5DEFF),
        openColor: Color(0xFFB5DEFF),
        closedColor: Color(0xFFB5DEFF),
        closedElevation: 2,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        openBuilder: (BuildContext context, VoidCallback _) {
          return EditRecipe();
        }).padding(vertical: 15, horizontal: 10);
  }

  Widget _getButton({color: Color, icon: Icons, action: Function}) {
    return ElevatedButton(
        onPressed: action,
        child: Icon(icon).padding(all: 0),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        )).width(60).height(50).padding(vertical: 15, horizontal: 10);
  }

  void _share(BuildContext context) {
    print(RecipesService().prepareRecipeShareText(widget.recipe!));
    Share.share(RecipesService().prepareRecipeShareText(widget.recipe!),
        subject: widget.recipe!.name);
  }

  void _toggleFavourites(BuildContext context) {
    bool currentFavouriteState = widget.recipe!.favourite;
    String message =
        currentFavouriteState ? 'usunio z ulubionych' : 'dodano do ulubionych';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.recipe!.name} - $message'),
    ));
  }
}
