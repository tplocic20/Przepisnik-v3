import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class RecipeInfo extends StatefulWidget {
  final Recipe? recipe;
  final double? portion;

  RecipeInfo({this.recipe, this.portion});

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  var groupExpanded = [];

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
      num parsedValue =
            num.parse((value.qty * widget.portion!.toInt()).toStringAsFixed(2));

      widgets.add(Container(
            decoration: widget.recipe!.ingredients[groupIdx].positions.length >
                    index + 1
                ? BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey)))
                : null,
            child: ListTile(
              title: Text(value.name),
              subtitle: Text(
                  '${value.qty != null ? parsedValue : ''} ${value.unit != null ? value.unit : ''}'),
            ),
          ).paddingDirectional(horizontal: 10));
    });
    return widgets;
  }
}
