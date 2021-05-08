import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeInfo extends StatefulWidget {
  final Recipe recipe;
  final double portion;

  RecipeInfo({this.recipe, this.portion});

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  var groupExpanded = [];

  @override
  Widget build(BuildContext context) {
    Widget _getTemperature() {
      if (widget.recipe.temperature == null ||
          widget.recipe.temperature == '-') {
        return Container();
      } else {
        return Padding(
          padding: EdgeInsets.only(right: 25, left: 25),
          child: ListTile(
            title: Text('Temperatura'),
            trailing: Text('${widget.recipe.temperature} stC'),
            leading: Icon(Icons.wb_incandescent),
          ),
        );
      }
    }

    Widget _getTime() {
      if (widget.recipe.time == null || widget.recipe.time == '-') {
        return Container();
      } else {
        return Padding(
          padding: EdgeInsets.only(right: 25, left: 25),
          child: ListTile(
            title: Text('Czas'),
            trailing: Text('${widget.recipe.time}'),
            leading: Icon(Icons.timer),
          ),
        );
      }
    }

    return ListView(
      children: <Widget>[
        Villain(
          villainAnimation: VillainAnimation.fromLeft(),
          child: _getTemperature(),
        ),
        Villain(
          villainAnimation: VillainAnimation.fromRight(),
          child: _getTime(),
        ),
        Villain(
            villainAnimation: VillainAnimation.fromBottom(),
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 100.0, left: 10, right: 10, top: 10),
              child: RoundedExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    groupExpanded[index] = !isExpanded;
                  });
                },
                children: _buildIngredientsGroupList(),
              ),
            )),
      ],
    );
  }

  _buildIngredientsGroupList() {
    List<ExpansionPanel> widgets = [];
    widget.recipe.ingredients.asMap().forEach((index, value) {
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
    List<Padding> widgets = [];
    widget.recipe.ingredients[groupIdx].positions
        .asMap()
        .forEach((index, Ingredient value) {
      num parsedValue = 0;
      if (value.qty != null) {
        if (value.qty is String) {
          double number =
              double.tryParse(value.qty.replaceAll(new RegExp(r','), '.'));
          parsedValue = num.parse((number != null ? number : 0 * widget.portion)
              .toStringAsFixed(2));
        } else if (value.qty is int) {
          parsedValue =
              num.parse((value.qty * widget.portion).toStringAsFixed(2));
        }
      }
      widgets.add(Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration:
                widget.recipe.ingredients[groupIdx].positions.length > index + 1
                    ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey)))
                    : null,
            child: ListTile(
              title: Text(value.name),
              subtitle: Text(
                  '${value.qty != null ? parsedValue : ''} ${value.unit != null ? value.unit : ''}'),
            ),
          )));
    });
    return widgets;
  }
}
