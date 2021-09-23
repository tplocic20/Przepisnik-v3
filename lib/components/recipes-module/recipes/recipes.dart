import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes-list.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
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
      Timer? _debounce;
      return BottomModalSearchWrapper(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
          child: TextFormField(
            controller: _searchController,
            autofocus: true,
            onChanged: (txt) {
              if (_debounce!.isActive) _debounce!.cancel();
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
      return FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push();
        },
        icon: Icon(Icons.add),
        label: Text('Dodaj'),
        elevation: 1,
        backgroundColor: Theme.of(context).accentColor,
      );
    }

    Widget _buildSearchText() {
      return ListTile(
        title: RichText(
          text: TextSpan(
            text: 'Wyniki dla ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: this._searchString,
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: Colors.white,
                      backgroundColor: Theme.of(context).accentColor)),
            ],
          ),
        ),
        trailing: ElevatedButton(
          child: Text('Wyczyść'),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () {
            setState(() {
              this._searchController!.clear();
              this._searchString = '';
            });
          },
        ),
      );
    }

    return StreamProvider<Event?>.value(
        initialData: null,
        value: RecipesService().recipeList,
        child: Backdrop(
          bottomNavigation: _buildBottomBar(),
          bottomMainBtn: _buildBottomActionButton(),
          title: Text(this._title),
          backLayer: Container(),
          frontLayer: Column(
            children: [
              this._searchString.isEmpty ? Container() : _buildSearchText(),
              Expanded(child: RecipesList(_selectedCategory, _searchString))
            ],
          ),
        ));
  }
}
