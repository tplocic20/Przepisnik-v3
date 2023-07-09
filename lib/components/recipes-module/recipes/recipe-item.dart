import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/single-recipe/single-recipe.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipeItem extends StatefulWidget {
  final Recipe? recipe;
  final String? selectedCategory;

  RecipeItem({this.recipe, this.selectedCategory});

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
      groupTag: 'recipes_list',
      startActionPane: ActionPane(
        extentRatio: (4 * 80) / MediaQuery.of(context).size.width,
        motion: const BehindMotion(),
        children: this._buildActions(context),
      ),
      child: this._buildTile(context),
    ))
        .elevation(0)
        .alignment(Alignment.center)
        .borderRadius(all: 25)
        .backgroundColor(Colors.transparent, animate: true)
        .constrained(height: 110)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(20,
            borderRadius: BorderRadius.circular(25),
            shadowColor: Color(0x30000000)) // shadow borderRadius
        .padding(bottom: 12, horizontal: 10, top: 0) // margin
        .animate(Duration(milliseconds: 150), Curves.easeOut);
  }

  Widget _buildTile(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.recipe!.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 20)),
              ListView(
                scrollDirection: Axis.horizontal,
                children: this._buildTags(context),
              ).height(30),
              _buildExtras(context)
            ],
          ).padding(vertical: 0, horizontal: 15),
        ).ripple().backgroundColor(Colors.white);
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return SingleRecipe(widget.recipe!);
      },
    ).borderRadius(all: 25, animate: true);
  }

  Widget _buildExtras(BuildContext context) {
    List<Widget> extras = [];

    if (widget.recipe!.time.isNotEmpty) {
      extras.add(Row(
        children: [
          PrzepisnikIcon(icon: 'time').padding(right: 5),
          Text(widget.recipe!.time)
        ],
      ));
    }

    if (widget.recipe!.temperature.isNotEmpty) {
      if (extras.isNotEmpty) {
        extras.add(VerticalDivider());
      }
      extras.add(Row(
        children: [
          PrzepisnikIcon(icon: 'temperature').padding(right: 5),
          Text('${widget.recipe!.temperature} ')
        ],
      ));
    }

    if (widget.recipe!.favourite) {
      if (extras.isNotEmpty) {
        extras.add(VerticalDivider());
      }
      extras.add(SvgPicture.asset(
        'assets/category_icons/favorite.svg',
        width: 20,
        height: 20,
      ));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: extras,
    ).height(20).padding(bottom: 10, left: 10);
  }

  List<Widget> _buildTags(BuildContext context) {
    return widget.recipe!.categories
        .split(';')
        .map((category) => _buildCategoryTag(
            RecipesService().getCategoryByKey(category), context))
        .toList();
  }

  Widget _buildCategoryTag(Category? category, BuildContext context) {
    if (category == null) {
      return Container();
    }
    bool current = widget.selectedCategory == category.key;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(int.parse("0xFF${category.color!}")),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          SvgPicture.asset('assets/category_icons/${category.icon}.svg',
                  width: 30, height: 30)
              .padding(right: 5, left: 0),
          Text(category.name).textColor(Colors.black)
        ],
      ).padding(left: 5, vertical: 5, right: 10),
    ).backgroundColor(current
            ? Color(int.parse("0xFF${category.color!}")).withAlpha(35)
            : Colors.transparent)
        .clipRRect(all: 20)
        .paddingDirectional(end: 5);
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> buttons = [
      this._getButton(
          action: () {},
          icon: PrzepisnikIcon(icon: 'trash', color: Colors.white,),
          color: PrzepisnikColors.ERROR),
      this._getButton(
          action: () {
            showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => WillPopScope(
                      child: EditRecipe(recipe: widget.recipe!),
                      onWillPop: () => Future.value(true),
                    ));
          },
          color: PrzepisnikColors.INFO,
          icon: PrzepisnikIcon(icon: 'edit')),
      this._getButton(
          action: () {
            this._share(context);
          },
          icon: PrzepisnikIcon(icon: 'share'),
          color: Color(0xFFCBE2B0)),
      this._getButton(
          action: () {
            this._toggleFavourites(context);
          },
          icon: PrzepisnikIcon(icon: 'favorite'),
          color: PrzepisnikColors.WARNING),
    ];
    return buttons;
  }

  Widget _getButton({color: Color, icon: Widget, action: Function}) {
    return ElevatedButton(
        onPressed: action,
        child: Container(child: icon),
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        )).width(60).height(50).padding(vertical: 10, horizontal: 5);
  }

  void _share(BuildContext context) {
    Share.share(RecipesService().prepareRecipeShareText(widget.recipe!),
        subject: widget.recipe!.name);
  }

  void _toggleFavourites(BuildContext context) {
    bool currentFavouriteState = widget.recipe!.favourite;
    RecipesService()
        .setFavourites(widget.recipe!.key, !currentFavouriteState);
  }
}
