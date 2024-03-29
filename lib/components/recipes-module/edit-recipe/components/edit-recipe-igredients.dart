import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/ingredient-group-form.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/ingredient-position-form.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeIngredients extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeIngredients({@required required this.recipe});

  @override
  _EditRecipeIngredientsState createState() => _EditRecipeIngredientsState();
}

class _EditRecipeIngredientsState extends State<EditRecipeIngredients>
    with AutomaticKeepAliveClientMixin<EditRecipeIngredients> {
  var groupExpanded = [];

  void initState() {
    super.initState();
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
            children: this._buildIngredientsList(index),
          )));
    });

    return widgets;
  }

  void showIngredientAddEditForm({Ingredient? position, Function? callback, Function? onDelete}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return IngredientPositionForm(position: position, onSubmit: callback, onDelete: onDelete);
        });
  }

  Widget _buildIngredientGroupActions(groupIdx) {
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
    );
    final buttonStyleError = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.error,
    );

    return Row(
      children: [
        TextButton.icon(
                onPressed: () {
                  IngredientGroup group = widget.recipe.ingredients[groupIdx];

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
                              widget.recipe.ingredients[groupIdx].name = txt;
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
              setState(() {
                IngredientGroup removed = widget.recipe.ingredients.removeAt(groupIdx);
                Get.snackbar(
                    '${removed.name}',
                    'Usunięto kategorię',
                    showProgressIndicator: true,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: PrzepisnikColors.PRIMARY,
                    colorText: PrzepisnikColors.ACCENT,
                    duration: const Duration(seconds: 4),
                    mainButton: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: PrzepisnikColors.ACCENT,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.recipe.ingredients.insert(groupIdx, removed);
                        });
                        Get.back();
                      },
                      child: Text('Cofnij'),
                    )
                );
              });
            },
            icon: Icon(Icons.delete),
            label: Text('Remove'),
            style: buttonStyleError),
      ],
    ).border(bottom: 1, color: Colors.grey);
  }

  List<Widget> _buildIngredientsList(groupIdx) {
    List<Widget> widgets = [];
    widget.recipe.ingredients[groupIdx].positions
        .asMap()
        .forEach((index, Ingredient value) {
      widgets.add(ListTile(
        key: ValueKey(value),
        leading: Icon(Icons.reorder_outlined),
        title: Text(value.name),
        onTap: () {
          this.showIngredientAddEditForm(
              position: value,
              callback: (name, unit, quantity) {
                Navigator.pop(context);
                setState(() {
                  widget.recipe.ingredients[groupIdx].positions[index].name = name;
                  widget.recipe.ingredients[groupIdx].positions[index].unit = unit;
                  widget.recipe.ingredients[groupIdx].positions[index].qty = quantity;
                });
              }, onDelete: () {
                Navigator.pop(context);
                setState(() {
                  Ingredient removed = widget.recipe.ingredients[groupIdx].positions.removeAt(index);
                  Get.snackbar(
                      '${removed.name}',
                      'Usunięto składnik',
                      showProgressIndicator: true,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: PrzepisnikColors.PRIMARY,
                      colorText: PrzepisnikColors.ACCENT,
                      duration: const Duration(seconds: 4),
                      mainButton: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: PrzepisnikColors.ACCENT,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.recipe.ingredients[groupIdx].positions.insert(index, removed);
                          });
                          Get.back();
                        },
                        child: Text('Cofnij'),
                      )
                  );
                });
          });
        },
        subtitle: value.unit.isNotEmpty && value.qty > 0
            ? Text('${value.qty.toString()} ${value.unit}')
            : Container(),
      ));
    });

    final buttonStyleSuccess = TextButton.styleFrom(
      foregroundColor: Theme.of(context).primaryColor,
    );

    return [
      this._buildIngredientGroupActions(groupIdx),
      ReorderableListView(
        onReorder: (from, to) {
          print(from);
          print(to);

          setState(() {
            if (from < to) {
              to -= 1;
            }

            final Ingredient ingredient =
                widget.recipe.ingredients[groupIdx].positions.removeAt(from);
            widget.recipe.ingredients[groupIdx].positions
                .insert(to, ingredient);
          });
        },
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: widgets,
      ),
      TextButton.icon(
              onPressed: () {
                this.showIngredientAddEditForm(
                    position: null,
                    callback: (name, unit, quantity) {
                      print('IngredientPositionForm submit');
                      Navigator.pop(context);
                      setState(() {
                        widget.recipe.ingredients[groupIdx].positions
                            .add(Ingredient.empty(name, unit, quantity));
                      });
                    });
              },
              icon: Icon(Icons.add),
              label: Text('Dodaj pozycję'),
              style: buttonStyleSuccess)
          .padding(top: 10),
    ];
  }

  Widget _addIngredientGroupButton() {
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).primaryColor,
    );

    return TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return IngredientGroupForm(onSubmit: (txt) {
                      Navigator.pop(context);
                      setState(() {
                        widget.recipe.ingredients
                            .add(IngredientGroup.empty(txt));
                      });
                    });
                  });
            },
            icon: Icon(Icons.add),
            label: Text('Dodaj grupę składników'),
            style: buttonStyle)
        .padding(top: 10);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RoundedExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              groupExpanded[index] = !isExpanded;
            });
          },
          children: this._buildIngredientsGroupList(),
        ).padding(all: 5),
        this._addIngredientGroupButton(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
