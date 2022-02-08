import 'dart:async';

import 'package:animations/animations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipe-item.dart';
import 'package:przepisnik_v3/components/shared/Loader.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListSate createState() => _RecipesListSate();
}

class _RecipesListSate extends State<RecipesList> {
  final SlidableController slidableController = SlidableController();
  String selectedCategory = '';
  String searchString = '';
  bool searchInteracted = false;
  String? selectedCategoryName;
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
                this.title = 'Wszystkie';
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.ac_unit).padding(all: 0),
                Text('Wszystkie', textAlign: TextAlign.center),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Theme.of(context)
                  .primaryColor
                  .withAlpha(this.selectedCategory.isEmpty ? 255 : 120),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            )).width(120).height(100).padding(horizontal: 10),
        ...RecipesService().categories.map((e) => ElevatedButton(
            onPressed: () {
              setState(() {
                this.selectedCategory = e.key;
                this.title = e.name;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.ac_unit).padding(all: 0),
                Text(e.name, textAlign: TextAlign.center),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Theme.of(context)
                  .primaryColor
                  .withAlpha(this.selectedCategory == e.key ? 255 : 120),
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
            slidableController: slidableController,
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
          icon: Icons.search,
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
            Navigator.pop(context);
            setState(() {
              searchString = searchController!.text;
              this.searchInteracted = false;
              this.focusNode!.unfocus();
            });
          },
        )
                .animate(const Duration(milliseconds: 300), Curves.ease)
                .padding(all: 10)),
        Container(
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInCubic,
          switchOutCurve: Curves.easeOutCubic,
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
                        });
                      },
                      child: Text('Anuluj'),
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).colorScheme.secondary))
                  .padding(right: 15)
              : Container(),
        ))
      ],
    );
  }

  Widget getRecipesList(List<Recipe> recipes) {
    List<Recipe> filteredRecipes = recipes.where((r) {
      final isCategory =
          selectedCategory == '' || r.categories.contains(selectedCategory);
      // final isCategory = true;
      final isSearchResult = searchString.isEmpty ||
          r.name.toLowerCase().contains(searchString.toLowerCase());
      // final isSearchResult = true;
      return isCategory && isSearchResult;
    }).toList();

    Widget emptyText = Center(
      child: Text(
        '¯\\_(ツ)_/¯\n ${searchString.length > 0 ? 'Nic nie znaleziono' : 'Brak przepisów w bazie\nPora jakiś dodać'}',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
    );

    return AnimationLimiter(
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
                height: 100, width: MediaQuery.of(context).size.width);
          } else {
            return getRecipeAnimation(context, index - 2, filteredRecipes);
          }
        },
      ),
    );
  }

  Widget getLoadingState() {
    return Container(
        child: Center(
      child: Loader(),
    ));
  }

  Widget _buildBottomActionButton() {
    return FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => WillPopScope(
                    child: EditRecipe(),
                    onWillPop: () => Future.value(true),
                  ));
        },
        label: Text('Dodaj'),
        icon: const Icon(Icons.delete));
  }

  Widget _buildBottomActionButton2() {
    const double _fabDimension = 50;
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return EditRecipe();
      },
      closedElevation: 6.0,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(_fabDimension / 2),
      )),
      closedColor: Theme.of(context).colorScheme.secondary,
      openColor: Theme.of(context).colorScheme.secondary,
      middleColor: Theme.of(context).colorScheme.secondary,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: _fabDimension,
          width: _fabDimension * 2.5,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
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
    final _recipesEvent = Provider.of<Event?>(context);

    return Backdrop(
        bottomMainBtn: _buildBottomActionButton(),
        actionButtonLocation: FloatingActionButtonLocation.centerFloat,
        title: Text(this.title),
        backLayer: [],
        frontLayer: _recipesEvent != null
            ? getRecipesList(RecipesService().parseRecipes(_recipesEvent))
            : getLoadingState());
  }
}
