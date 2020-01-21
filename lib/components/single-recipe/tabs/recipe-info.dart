import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/recipe.dart';

class RecipeInfo extends StatefulWidget {
  final Recipe recipe;

  RecipeInfo(this.recipe);

  @override
  _RecipeInfoState createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  var groupExpanded = [];

  @override
  Widget build(BuildContext context) {
    Widget _getTemperature() {
      if(widget.recipe.temperature == null || widget.recipe.temperature == '-') {
        return Container();
      } else {
        return Padding(
          padding: EdgeInsets.only(right: 25, left: 25),
          child: ListTile(
            title: Text('Temperatura'),
            trailing: Text('${widget.recipe.temperature} stC'),
            leading: Icon(Icons.wb_incandescent),
          ),
        );      }
    }
    Widget _getTime() {
      if(widget.recipe.time == null || widget.recipe.time == '-') {
        return Container();
      } else {
        return Padding(
          padding: EdgeInsets.only(right: 25, left: 25),
          child: ListTile(
            title: Text('Czas'),
            trailing: Text('${widget.recipe.time}'),
            leading: Icon(Icons.timer),
          ),
        );      }
    }

    print(widget.recipe.temperature);
    return ListView(
      children: <Widget>[
        _getTemperature(),
        _getTime(),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              groupExpanded[index] = !isExpanded;
            });
          },
          children: _buildIngredientsGroupList(),
        ),
      ],
    );
  }

  _buildIngredientsGroupList() {
    List<ExpansionPanel> widgets = [];
    widget.recipe.ingredients.asMap().forEach((index, value) {
      groupExpanded.add(true);
      widgets.add(ExpansionPanel(
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

  _buildIngredientsList(index) {
    List<Padding> widgets = [];
    widget.recipe.ingredients[index].positions.asMap().forEach((index, value) {
      widgets.add(Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
            child: ListTile(
              title: Text(value.name),
              subtitle: Text('${value.qty != null ? value.qty : ''} ${value.unit != null ? value.unit : ''}'),
            ),
          )));
    });
    return widgets;
  }
}
