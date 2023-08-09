import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class IngredientPositionForm extends StatefulWidget {
  final Ingredient? position;
  final Function? onSubmit;

  const IngredientPositionForm({this.position, @required this.onSubmit});

  _IngredientPositionFormState createState() => _IngredientPositionFormState();
}

class _IngredientPositionFormState extends State<IngredientPositionForm> {
  late TextEditingController nameInputController;
  late TextEditingController quantityInputController;
  late TextEditingController unitInputController;
  late FocusNode nameInputNode;
  late FocusNode quantityInputNode;
  late FocusNode unitInputNode;
  String searchString = '';
  bool showUnitPropositions = false;

  @override
  void initState() {
    nameInputController =
        TextEditingController(text: widget.position?.name ?? '');
    quantityInputController =
        TextEditingController(text: widget.position?.qty.toString() ?? '');
    unitInputController =
        TextEditingController(text: widget.position?.unit ?? '');
    nameInputNode = FocusNode();
    quantityInputNode = FocusNode();
    unitInputNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void submit() {
      if (nameInputController.text.isEmpty) {
        setState(() {
          nameInputNode.requestFocus();
          showUnitPropositions = false;
        });
      } else if (quantityInputController.text.isEmpty) {
        setState(() {
          quantityInputNode.requestFocus();
          showUnitPropositions = false;
        });
      } else if (unitInputController.text.isEmpty) {
        setState(() {
          unitInputNode.requestFocus();
          this.searchString = '';
          this.showUnitPropositions = true;
        });
      } else {
        widget.onSubmit!(nameInputController.text, unitInputController.text, double.parse(quantityInputController.text));
      }
    }

    return BottomModalInputWrapper(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.position != null
                ? 'Edytuj ${widget.position!.name}'
                : 'Nowy składnik')
            .fontSize(18)
            .padding(bottom: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: nameInputNode.hasFocus ? 2 : 1,
                child: TextInput(
                  controller: nameInputController,
                  focusNode: nameInputNode,
                  onTap: () {
                    setState(() {
                      this.searchString = '';
                      this.showUnitPropositions = false;
                      this.nameInputNode.requestFocus();
                    });
                  },
                  radius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      topRight: Radius.circular(1),
                      bottomRight: Radius.circular(1)),
                  autofocus: true,
                  label: Text('Składnik'),
                  onFieldSubmitted: (text) {
                    setState(() {
                      quantityInputNode.requestFocus();
                    });
                  },
                ).height(50)),
            Flexible(
                child: TextInput(
              controller: quantityInputController,
              onTap: () {
                setState(() {
                  this.searchString = '';
                  this.showUnitPropositions = false;
                  this.quantityInputNode.requestFocus();
                });
              },
              focusNode: quantityInputNode,
              radius: BorderRadius.circular(1),
              isNumeric: true,
              label: Text('Ilość'),
              onFieldSubmitted: (text) {
                setState(() {
                  unitInputNode.requestFocus();
                });
              },
            ).height(50)),
            Flexible(
              child: TextInput(
                label: Text('Jednostka'),
                onTap: () {
                  if (unitInputNode.hasFocus == false) {
                    setState(() {
                      this.searchString = '';
                      this.showUnitPropositions = true;
                    });
                  }
                },
                onChanged: (text) {
                  setState(() {
                    this.searchString = text;
                  });
                },
                onFieldSubmitted: (text) {
                  setState(() {
                    this.unitInputNode.unfocus();
                  });
                },
                radius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1)),
                controller: unitInputController,
                focusNode: unitInputNode,
              ).height(50),
            )
          ],
        ).padding(top: 10),
        ListView(
                scrollDirection: Axis.horizontal,
                children: RecipesService()
                    .units
                    .where((element) =>
                        element.toLowerCase().indexOf(searchString) >= 0)
                    .map((unit) => TextButton(
                        onPressed: () {
                          unitInputController.text = unit;
                        },
                        child: Text(unit,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary))))
                    .toList()).height(showUnitPropositions ? 60 : 0, animate: true).animate(Duration(milliseconds: 250), Curves.linearToEaseOut),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 50)),
                child: Text('Anuluj',
                    style: TextStyle(color: PrzepisnikColors.ERROR))),
            TextButton(
                onPressed: () {
                  submit();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 50)),
                child: Text('Zapisz',
                    style: TextStyle(color: Theme.of(context).primaryColor)))
          ],
        )
      ],
    ).padding(all: 15));
  }
}
