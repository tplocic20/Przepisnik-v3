import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/edit-recipe/components/partials/edit-recipe-text-step.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/przepisnik_icons.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeText extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeText({@required required this.recipe});

  @override
  _EditRecipeTextState createState() => _EditRecipeTextState();
}

class _EditRecipeTextState extends State<EditRecipeText> {
  late TextEditingController _controller;
  List<bool> groupExpanded = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addRecipeStep() {
    setState(() {
      int count = widget.recipe.recipeSteps.length + 1;
      widget.recipe.recipeSteps.add(RecipeStep('Step $count'));
    });
  }

  List<ExpansionPanel> _buildRecipeSteps() {
    List<ExpansionPanel> widgets = [];
    widget.recipe.recipeSteps.asMap().forEach((index, value) {
      groupExpanded.add(true);
      widgets.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(widget.recipe.recipeSteps[index].name),
          );
        },
        isExpanded: groupExpanded[index],
        body: EditRecipeTextStep(recipe: widget.recipe, stepId: index),
      ));
    });

    return widgets;
  }

  Widget _addStepButton() {
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).primaryColor,
    );

    return TextButton.icon(
            onPressed: () {
              this.addRecipeStep();
            },
            icon: Icon(Icons.add),
            label: Text('Dodaj krok przepisu'),
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
          children: this._buildRecipeSteps(),
        ).padding(all: 5),
        _addStepButton()
      ],
    );
  }
}
