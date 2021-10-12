import 'dart:async';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes-list.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage();

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<RecipesPage> {
  String _selectedCategory = '';
  String _searchString = '';
  String? _selectedCategoryName;
  String _title = 'Wszystkie';
  TextEditingController? _searchController;

  void initState() {
    super.initState();
    this._searchController = TextEditingController(text: this._searchString);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listElements = [];
    Widget _buildCategoriesModal() {
      void _updateCategory(value, name) {
        Navigator.pop(context);
        setState(() {
          _selectedCategory = value;
          _selectedCategoryName = name;
          _title = _selectedCategoryName ?? 'Wszystkie';
        });
      }

      listElements.add(RadioListTile(
        value: '',
        groupValue: _selectedCategory,
        onChanged: (value) {
          _updateCategory('', '');
          _title = 'Wszystkie';
        },
        title: Text('Wszystkie'),
      ));

      RecipesService().categories.forEach((category) {
        listElements.add(RadioListTile(
          value: category.key,
          groupValue: _selectedCategory,
          onChanged: (value) {
            _updateCategory(value, category.name);
          },
          title: Text(category.name),
        ));
      });

      return BottomModalWrapper(
          child: ListView(
        children: listElements,
      ));
    }

    Widget _buildSearchModal() {
      Timer? _debounce;
      return Center(
        child: TextFormField(
          controller: _searchController,
          autofocus: true,
          onChanged: (txt) {
            if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 350), () {
              setState(() {
                _searchString = txt;
              });
            });
          },
          onFieldSubmitted: (txt) {
            Navigator.pop(context);
            setState(() {
              _searchString = _searchController!.text;
            });
          },
          decoration: InputDecoration(
              filled: true,
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).primaryColor),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    style: BorderStyle.solid,
                    width: 1),
              )),
          keyboardType: TextInputType.text,
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
        ).padding(all: 10),
      );
    }

    Widget _buildBottomBar() {
      return BottomAppBar(
        elevation: 0,
        notchMargin: 5,
        color: Theme.of(context).primaryColorLight,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            StadiumBorder()),
        clipBehavior: Clip.antiAlias,
        child: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return _buildCategoriesModal();
                  });
            },
          ).paddingDirectional(all: 15),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return _buildSearchModal();
                  });
            },
          ).paddingDirectional(all: 15),
        ].toRow(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween),
      );
    }

    Widget _buildBottomActionButton() {
      const double _fabDimension = 50;
      return OpenContainer(
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const EditRecipe();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
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
                  Text('Dodaj', style: TextStyle(letterSpacing: 2.0, fontWeight: FontWeight.bold),).padding(left: 5)
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _buildSearchText() {
      return ListTile(
        title: RichText(
          text: TextSpan(
            text: 'Wyniki dla ',
            style: Theme.of(context).textTheme.bodyText2,
            children: <TextSpan>[
              TextSpan(
                  text: this._searchString,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary)),
            ],
          ),
        ),
        trailing: ElevatedButton(
          child: Text('Wyczyść'),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary, shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              )),
          onPressed: () {
            setState(() {
              this._searchController!.clear();
              this._searchString = '';
            });
          },
        ).borderRadius(all: 15),
      );
    }

    return StreamProvider<Event?>.value(
        initialData: null,
        value: RecipesService().recipeList,
        child: Backdrop(
          bottomNavigation: _buildBottomBar(),
          bottomMainBtn: _buildBottomActionButton(),
          title: Text(this._title),
          backLayer: [],
          frontLayer: Column(
            children: [
              this._searchString.isEmpty ? Container() : _buildSearchText(),
              Expanded(child: RecipesList(_selectedCategory, _searchString))
            ],
          ),
        ));
  }
}
