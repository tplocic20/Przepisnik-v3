import 'dart:async';
import 'package:animations/animations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipe-item.dart';
import 'package:przepisnik_v3/components/shared/Loader.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/components/shared/przepisnik_icons.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import '../../shared/bottom-modal-wrapper.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListSate createState() => _RecipesListSate();
}

class _RecipesListSate extends State<RecipesList> with AutomaticKeepAliveClientMixin<RecipesList> {
  bool showOnlyFavourites = false;
  bool searchInteracted = false;
  String? selectedCategoryName;
  String selectedCategory = '';
  String searchString = '';
  String title = 'Wszystkie';
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 50.0);
  late TextEditingController? searchController;
  late FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    this.searchController = TextEditingController(text: this.searchString);
    this.focusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    this.focusNode!.dispose();
    this.searchController!.dispose();
  }

  getCategoriesPicker() {
    return Container(
        child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                this.selectedCategory = '';
                this.showOnlyFavourites = false;
                this.title = 'Wszystkie';
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/category_icons/dining-room.svg', width: 40, height: 40,).padding(all: 0),
                Text('Wszystkie', textAlign: TextAlign.center),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor.withAlpha(
                  this.selectedCategory.isEmpty && !this.showOnlyFavourites
                      ? 255
                      : 120),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            )).width(120).height(100).padding(horizontal: 10),
        ElevatedButton(
            onPressed: () {
              setState(() {
                this.selectedCategory = '';
                this.showOnlyFavourites = true;
                this.title = 'Ulubione';
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/category_icons/favorite.svg', width: 40, height: 40,).padding(all: 0),
                Text('Ulubione', textAlign: TextAlign.center),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withAlpha(this.showOnlyFavourites ? 255 : 120),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            )).width(120).height(100).padding(horizontal: 10),
        ...RecipesService().categories.map((category) => ElevatedButton(
            onPressed: () {
              setState(() {
                this.selectedCategory = category.key;
                this.showOnlyFavourites = false;
                this.title = category.name;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/category_icons/${category.icon}.svg', width: 40, height: 40,).padding(all: 0),
                Text(category.name, textAlign: TextAlign.center),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: (category.color == null ? Theme.of(context).primaryColor : Color(int.parse("0xFF${category.color!}")))
                  .withAlpha(this.selectedCategory == category.key ? 255 : 120),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            )).width(120).height(100).padding(horizontal: 10))
      ],
    )).height(100).padding(bottom: 20, top: 5);
  }

  Widget getRecipeAnimation(
      BuildContext context, int index, List<Recipe> filteredRecipes) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 250),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: SlideAnimation(
          horizontalOffset: 200,
          verticalOffset: 10,
          child: FadeInAnimation(
              child: RecipeItem(
            recipe: filteredRecipes[index],
            selectedCategory: selectedCategory,
          )),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    Timer? _debounce;
    return Row(
      children: [
        Expanded(
            child: TextInput(
          controller: searchController,
          hint: 'Szukaj',
          icon: CarbonIcons.time,
          focusNode: focusNode,
          isDense: true,
          onChanged: (txt) {
            if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 350), () {
              setState(() {
                searchString = txt;
              });
            });
          },
          onTap: () {
            setState(() {
              this.searchInteracted = true;
            });
          },
          onFieldSubmitted: (txt) {
            setState(() {
              searchString = searchController!.text;
              this.searchInteracted = false;
              this.focusNode!.unfocus();
            });
          },
        )
                .animate(const Duration(milliseconds: 300), Curves.easeOut)
                .padding(all: 10)),
        Container(
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: animation,
              child: child,
            );
          },
          child: this.searchInteracted || this.searchString.isNotEmpty
              ? TextButton(
                      onPressed: () {
                        setState(() {
                          this.searchInteracted = false;
                          this.searchController!.clear();
                          this.searchString = '';
                          this.focusNode!.unfocus();
                          this.scrollController.animateTo(50, duration: const Duration(microseconds: 550), curve: Curves.ease);
                        });
                      },
                      child: Text('Anuluj'),
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.secondary))
                  .padding(right: 15)
              : Container(),
        ))
      ],
    );
  }

  Widget getRecipesList(List<Recipe> recipes) {
    List<Recipe> filteredRecipes = recipes.where((r) {
      final isFav = !this.showOnlyFavourites || r.favourite;
      final isCategory =
          selectedCategory == '' || r.categories.contains(selectedCategory);
      // final isCategory = true;
      final isSearchResult = searchString.isEmpty ||
          r.name.toLowerCase().contains(searchString.toLowerCase());
      // final isSearchResult = true;
      return isCategory && isSearchResult && isFav;
    }).toList();

    Widget emptyText = Center(
      child: Text(
        '¯\\_(ツ)_/¯\n ${searchString.length > 0 ? 'Nic nie znaleziono' : 'Brak przepisów w bazie\nPora jakiś dodać'}',
        style: TextStyle(fontSize: 19),
        textAlign: TextAlign.center,
      ),
    );

    return AnimationLimiter(
      child: SlidableAutoCloseBehavior(
          child: ListView.builder(
        controller: scrollController,
        itemCount: filteredRecipes.length + 3,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildSearchInput();
          } else if (index == 1) {
            return getCategoriesPicker();
          } else if (index == filteredRecipes.length + 2) {
            return SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Container());
          } else {
            return filteredRecipes.isEmpty ? emptyText : getRecipeAnimation(context, index - 2, filteredRecipes);
          }
        },
      )),
    );
  }

  Widget getLoadingState() {
    return Container(
        child: Center(
      child: Loader(),
    ));
  }

  Widget _buildBottomActionButton2() {
    const double _fabDimension = 50;
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback openContainer) {
        return WillPopScope(
          child: EditRecipe(),
          onWillPop: () {
            bool returnValue = false;
            print('WillPopScope EditRecipe');
            return showModalBottomSheet<bool>(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return BottomModalWrapper(
                    child: ConfirmBottomModal(
                      title: 'Na pewno chcesz zamknąć edytor?',
                      msg: 'Utrcisz wszystkie niezapisane zmiany',
                      type: ConfirmBottomModalType.danger,
                      action: () {
                        returnValue = true;
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).then((value) => returnValue);
          },
        );
      },
      closedElevation: 6.0,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(_fabDimension / 2),
      )),
      closedColor: Theme.of(context).colorScheme.secondary,
      openColor: Theme.of(context).colorScheme.secondary,
      middleColor: Theme.of(context).colorScheme.secondary,
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (BuildContext context, VoidCallback callback) {
        return SizedBox(
          height: _fabDimension,
          width: _fabDimension * 2.5,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CarbonIcons.add),
                Text(
                  'Dodaj',
                  style: TextStyle(
                      letterSpacing: 2.0, fontWeight: FontWeight.bold),
                ).padding(left: 5)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _recipesEvent = Provider.of<DatabaseEvent?>(context);

    return Scaffold(
        floatingActionButton: _buildBottomActionButton2(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        body: _recipesEvent != null
            ? getRecipesList(RecipesService().parseRecipes(_recipesEvent))
            : getLoadingState());
  }

  @override
  bool get wantKeepAlive => true;
}
