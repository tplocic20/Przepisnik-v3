import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (this.streamSubscription == null) {
      this.streamSubscription = widget.cookModeReset!.listen((value) {
        if (value == true) {
          setState(() {
            ingredientChecked = new Map();
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    this.streamSubscription!.cancel();
    this.streamSubscription = null;
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
          trailing: Text('${widget.recipe!.temperature} \u2103'),
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
            trailing: Icon(isChecked
                    ? Icons.check_circle_outline
                    : Icons.circle_outlined)
                .gestures(onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                this.ingredientChecked[cookingId] = !isChecked;
                this.verifyAllChecked(groupIdx, cookingId);
              });
            }))
        .ripple()
        .opacity(isChecked ? 0.5 : 1, animate: true)
        .gestures(onLongPress: () {
          HapticFeedback.lightImpact();
          setState(() {
            this.ingredientChecked[cookingId] = !isChecked;
            this.verifyAllChecked(groupIdx, cookingId);
          });
        })
        .backgroundColor(isChecked ? Color(0x15000000) : Colors.transparent,
            animate: true)
        .clipRRect(
            bottomLeft: isNotLast ? 0 : 10, bottomRight: isNotLast ? 0 : 10)
        .constrained(height: isChecked ? 55 : 70, animate: true)
        .animate(Duration(milliseconds: 150), Curves.easeOut);
  }

  void verifyAllChecked(groupIdx, cookingId) {
    num checkedLen = this
        .ingredientChecked
        .entries
        .where((MapEntry<String, bool> element) =>
            element.key.split('_')[0] == groupIdx.toString() &&
            element.value == true)
        .length;
    this.groupExpanded[groupIdx] =
        !(checkedLen == widget.recipe!.ingredients[groupIdx].positions.length);
  }

  BoxDecoration? _ingredientDecoration(bool isNotLast) {
    return isNotLast
        ? BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey)))
        : null;
  }
}
