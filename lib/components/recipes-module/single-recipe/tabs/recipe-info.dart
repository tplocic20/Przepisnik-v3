import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipeInfo extends StatefulWidget {
  final Recipe? recipe;
  final double? portion;
  final bool? cookMode;
  final Stream? cookModeReset;

  RecipeInfo({this.recipe, this.portion, this.cookMode, this.cookModeReset});

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  var groupExpanded = [];
  Map<String, bool> ingredientChecked = new Map();
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    this.streamSubscription = widget.cookModeReset!.listen((value) {
      if (value == true) {
        setState(() {
          ingredientChecked = new Map();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this.streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _getTemperature() {
      if (widget.recipe!.temperature == null ||
          widget.recipe!.temperature == '-') {
        return Container();
      } else {
        return ListTile(
          title: const Text('Temperatura'),
          trailing: Text('${widget.recipe!.temperature} stC'),
          leading: Icon(Icons.wb_incandescent),
        ).padding(horizontal: 25);
      }
    }

    Widget _getTime() {
      if (widget.recipe!.time == null || widget.recipe!.time == '-') {
        return Container();
      } else {
        return ListTile(
          title: const Text('Czas'),
          trailing: Text('${widget.recipe!.time}'),
          leading: Icon(Icons.timer),
        ).padding(horizontal: 25);
      }
    }

    return ListView(
      children: <Widget>[
        _getTemperature(),
        _getTime(),
        RoundedExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              groupExpanded[index] = !isExpanded;
            });
          },
          children: _buildIngredientsGroupList(),
        ).padding(bottom: 100.0, left: 10, right: 10, top: 10),
      ],
    );
  }

  _buildIngredientsGroupList() {
    List<ExpansionPanel> widgets = [];
    widget.recipe!.ingredients.asMap().forEach((index, value) {
      groupExpanded.add(true);
      widgets.add(ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(value.name),
            );
          },
          isExpanded: groupExpanded[index],
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildIngredientsList(index),
          )));
    });
    return widgets;
  }

  _buildIngredientsList(groupIdx) {
    List<Widget> widgets = [];
    widget.recipe!.ingredients[groupIdx].positions
        .asMap()
        .forEach((index, Ingredient value) {
      widgets.add(this._singleIngredientBox(
          groupIdx,
          index,
          value,
          num.parse(
              (value.qty * widget.portion!.toDouble()).toStringAsFixed(2))));
    });

    return widgets;
  }

  Widget _singleIngredientBox(groupIdx, index, Ingredient value, parsedValue) {
    String title = value.name;
    String subtitle =
        '${value.qty != null ? parsedValue : ''} ${value.unit != null ? value.unit : ''}';
    bool isNotLast =
        widget.recipe!.ingredients[groupIdx].positions.length > index + 1;

    return Container(
      decoration: this._ingredientDecoration(isNotLast),
      child: widget.cookMode!
          ? this._buildCookModeBox(title, subtitle, groupIdx, index, isNotLast)
          : this._buildIngredientBox(title, subtitle),
    ).paddingDirectional(horizontal: 10);
  }

  Widget _buildIngredientBox(String title, String subtitle) {
    return ListTile(title: Text(title), subtitle: Text(subtitle));
  }

  Widget _buildCookModeBox(String title, String subtitle, int groupIdx,
      int portionIndex, bool isNotLast) {
    String cookingId = '${groupIdx}_${portionIndex}';
    bool isChecked = this.ingredientChecked[cookingId] != null &&
        this.ingredientChecked[cookingId] == true;
    return ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            dense: isChecked,
            trailing: Icon(isChecked ? Icons.check_circle_outline : Icons.circle_outlined).gestures(
              onTap: () {
                setState(() {
                  this.ingredientChecked[cookingId] = !isChecked;
                });
              }
            ))
        .ripple()
        .gestures(onLongPress: () {
          setState(() {
            this.ingredientChecked[cookingId] = !isChecked;
          });
        })
        .backgroundColor(isChecked ? Color(0xFFCCCCCC) : Colors.transparent,
            animate: true)
        .clipRRect(
            bottomLeft: isNotLast ? 0 : 10, bottomRight: isNotLast ? 0 : 10)
        .constrained(height: isChecked ? 55 : 70, animate: true)
        .animate(Duration(milliseconds: 150), Curves.easeOut);
  }

  BoxDecoration? _ingredientDecoration(bool isNotLast) {
    return isNotLast
        ? BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey)))
        : null;
  }
}
