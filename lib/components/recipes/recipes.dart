import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes/recipes-list.dart';
import 'package:przepisnik_v3/components/shared/BottomModalWrapper.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/models/routes.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class RecipesPage extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<RecipesPage> {
  String _selectedCategory;
  String _searchString;
  String _selectedCategoryName;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    final _searchController = TextEditingController();

    Widget _buildCategoriesModal() {
      void _updateCategory(value, name) {
        Navigator.pop(context);
        setState(() {
          _selectedCategory = value;
          _selectedCategoryName = name;
        });
      }

      List<Widget> listElements = [
        RadioListTile(
          value: null,
          groupValue: _selectedCategory,
          onChanged: (value) {
            _updateCategory(null, null);
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
      return BottomModalWrapper(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 10,
              right: 10,
              top: 10),
          child: TextFormField(
            controller: _searchController,
            autofocus: true,
            onChanged: (txt) {
              if (_debounce?.isActive ?? false) _debounce.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
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
                  borderRadius: BorderRadius.circular(5),
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

    return StreamProvider.value(
        value: RecipesService().recipeList,
        child: Backdrop(
          scope: Routes.recipes,
          title: _selectedCategoryName != null
              ? _selectedCategoryName
              : 'Wszystkie',
          frontLayer: RecipesList(_selectedCategory, _searchString),
          bottomNavigation: BottomAppBar(
            elevation: 10,
            notchMargin: 3,
            shape: CircularNotchedRectangle(),
            clipBehavior: Clip.antiAlias,
            child: Container(
                height: 50.0,
                color: Theme.of(context).primaryColorLight,
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
          ),
          bottomMainBtn: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            elevation: 1,
            backgroundColor: Theme.of(context).accentColor,
          ),
        ));
  }
}
