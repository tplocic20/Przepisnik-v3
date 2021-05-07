import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/edit-recipe.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes-list.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/models/routes.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/services/recipes-service.dart';

class RecipesPage extends StatefulWidget {
  final Function setTitle;
  final Function setBottomBar;
  final Function setFloatingBtn;

  const RecipesPage(this.setTitle, this.setBottomBar, this.setFloatingBtn);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<RecipesPage> {
  String _selectedCategory;
  String _searchString;
  String _selectedCategoryName;
  bool _backdropInitialised = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController(
        text: this._searchString != null ? this._searchString : '');

    Widget _buildCategoriesModal() {
      void _updateCategory(value, name) {
        Navigator.pop(context);
        setState(() {
          _selectedCategory = value;
          _selectedCategoryName = name;
          widget.setTitle(_selectedCategoryName);
        });
      }

      List<Widget> listElements = [
        RadioListTile(
          value: null,
          groupValue: _selectedCategory,
          onChanged: (value) {
            _updateCategory(null, null);
            widget.setTitle('Wszystkie');
          },
          title: Text('Wszystkie'),
        )
      ];

      globals.categories.forEach((category) {
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
      Timer _debounce;
      return BottomModalSearchWrapper(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
          child: TextFormField(
            controller: _searchController,
            autofocus: true,
            onChanged: (txt) {
              if (_debounce?.isActive ?? false) _debounce.cancel();
              _debounce = Timer(const Duration(milliseconds: 350), () {
                setState(() {
                  _searchString = txt;
                });
              });
            },
            onFieldSubmitted: (txt) {
              Navigator.pop(context);
              setState(() {
                _searchString = _searchController.text;
              });
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                      width: 1),
                )),
            keyboardType: TextInputType.text,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        ),
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
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            StadiumBorder()),
        clipBehavior: Clip.antiAlias,
        child: Container(
            height: 50.0,
            // color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _buildCategoriesModal();
                        });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _buildSearchModal();
                        });
                  },
                )
              ],
            )),
      );
    }

    Widget _buildBottomActionButton() {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditRecipe()));
        },
        icon: Icon(Icons.add),
        label: Text('Dodaj'),
        elevation: 1,
        backgroundColor: Theme.of(context).accentColor,
      );
    }

    void initBackdropControls() {
      if (this._backdropInitialised == true) {
        return;
      }
      this._backdropInitialised = true;
      widget.setBottomBar(_buildBottomBar());
      widget.setFloatingBtn(_buildBottomActionButton());
      widget.setTitle('Wszystkie');
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initBackdropControls());

    return StreamProvider.value(
        value: RecipesService().recipeList,
        child: RecipesList(_selectedCategory, _searchString));
  }
}
