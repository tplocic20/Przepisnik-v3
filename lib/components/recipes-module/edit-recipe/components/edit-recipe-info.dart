import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/ingredient-group-form.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/categories-form.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
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
  Recipe recipe = Recipe.empty();

  void initState() {
    if (widget.recipe != null) {
      this.recipe = Recipe.from(this.recipe);
    }
    super.initState();
  }

  _buildIngredientsGroupList() {
    List<ExpansionPanel> widgets = [];
    this.recipe.ingredients.asMap().forEach((index, value) {
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
    this
        .recipe
        .ingredients[groupIdx]
        .positions
        .asMap()
        .forEach((index, Ingredient value) {
      widgets.add(ListTile(
        key: ValueKey(value),
        title: Text(value.name),
      ));
    });

    final buttonStyleSuccess = TextButton.styleFrom(
      primary: Theme
          .of(context)
          .primaryColor,
    );
    final buttonStyle = TextButton.styleFrom(
      primary: Theme
          .of(context)
          .colorScheme
          .primary,
    );
    final buttonStyleError = TextButton.styleFrom(
      primary: Theme
          .of(context)
          .colorScheme
          .error,
    );

    return [
      Row(
        children: [
          TextButton.icon(
              onPressed: () {
                IngredientGroup group = this.recipe.ingredients[groupIdx];

                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return IngredientGroupForm(
                              group: group,
                              onSubmit: (txt) {
                                Navigator.pop(context);
                                setState(() {
                                  this.recipe.ingredients[groupIdx].name = txt;
                                });
                              },
                            );
                    });
              },
              icon: Icon(Icons.edit),
              label: Text('Edit'),
              style: buttonStyle)
              .padding(right: 10),
          TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return BottomModalWrapper(
                        child: ConfirmBottomModal(
                          title: 'Na pewno chcesz usunąć kategorię?',
                          msg: 'Operacji nie będzie można cofnąć',
                          type: ConfirmBottomModalType.danger,
                          action: () {
                            setState(() {
                              this.recipe.ingredients.removeAt(groupIdx);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    });
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
              this
                  .recipe
                  .ingredients[groupIdx]
                  .positions
                  .add(Ingredient.empty());
            });
          },
          icon: Icon(Icons.add),
          label: Text('Dodaj pozycję'),
          style: buttonStyleSuccess)
          .padding(top: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      primary: Theme
          .of(context)
          .primaryColor,
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
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return IngredientGroupForm(onSubmit: (txt) {
                      Navigator.pop(context);
                      setState(() {
                        this.recipe.ingredients.add(
                            IngredientGroup.empty(txt));
                      });
                    });
                  });
            },
            icon: Icon(Icons.add),
            label: Text('Dodaj grupę składników'),
            style: buttonStyle)
            .padding(top: 10),
      ],
    );
  }
}
