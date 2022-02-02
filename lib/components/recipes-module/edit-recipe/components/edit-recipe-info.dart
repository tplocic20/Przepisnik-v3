import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/categories-form.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeInfo extends StatefulWidget {
  final Recipe? recipe;
  final FormGroup? form;

  const EditRecipeInfo({this.recipe, this.form});

  @override
  _EditRecipeInfoState createState() => _EditRecipeInfoState();
}

class _EditRecipeInfoState extends State<EditRecipeInfo> {
  bool categoriesExpanded = true;
  var groupExpanded = [];

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
      widgets.add(ListTile(
        key: ValueKey(value),
        title: Text(value.name),
      ));
    });

    final buttonStyleSuccess = TextButton.styleFrom(
      primary: Theme.of(context).primaryColor,
    );
    final buttonStyle = TextButton.styleFrom(
      primary: Theme.of(context).colorScheme.primary,
    );
    final buttonStyleError = TextButton.styleFrom(
      primary: Theme.of(context).colorScheme.error,
    );

    return [
      Row(
        children: [
          TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: buttonStyle)
              .padding(right: 10),
          TextButton.icon(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                          title: Text(
                              'Usuwanie ${widget.recipe!.ingredients[groupIdx].name}'),
                          content: Text('Czy na pewno usunąć kategorię?'),
                          actions: [
                            CupertinoDialogAction(
                                child: Text('Nie'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            CupertinoDialogAction(
                                child: Text('Tak'),
                                isDestructiveAction: true,
                                onPressed: () {
                                  setState(() {
                                    widget.recipe!.ingredients.removeAt(groupIdx);
                                  });
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ));
              },
              icon: Icon(Icons.delete),
              label: Text('Remove'),
              style: buttonStyleError),
        ],
      ).border(bottom: 1, color: Colors.grey),
      ReorderableListView(
        onReorder: (from, to) {},
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: widgets,
      ),
      TextButton.icon(
              onPressed: () {
                setState(() {
                  widget.recipe!.ingredients[groupIdx].positions.add(Ingredient.empty());
                });
              },
              icon: Icon(Icons.add),
              label: Text('Dodaj składnik'),
              style: buttonStyleSuccess)
          .padding(top: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      primary: Theme.of(context).primaryColor,
    );
    return ListView(
      children: [
        RoundedExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              categoriesExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
                isExpanded: categoriesExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('Kategorie'),
                  );
                },
                body: CategoriesForm())
          ],
        ).padding(all: 5),
        RoundedExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              groupExpanded[index] = !isExpanded;
            });
          },
          children: _buildIngredientsGroupList(),
        ).padding(all: 5),
        TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.recipe!.ingredients.add(IngredientGroup.empty());
                  });
                },
                icon: Icon(Icons.add),
                label: Text('Dodaj grupę'),
                style: buttonStyle)
            .padding(top: 10),
      ],
    );
  }
}