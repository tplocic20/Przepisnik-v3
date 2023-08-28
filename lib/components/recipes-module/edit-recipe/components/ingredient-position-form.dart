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
  final Function? onDelete;

  const IngredientPositionForm({this.position, @required this.onSubmit, this.onDelete});

  _IngredientPositionFormState createState() => _IngredientPositionFormState();
}

class _IngredientPositionFormState extends State<IngredientPositionForm>
    with TickerProviderStateMixin {
  late TextEditingController nameInputController;
  late TextEditingController quantityInputController;
  late FocusNode nameInputNode;
  late FocusNode quantityInputNode;
  String selectedUnit = '';

  @override
  void initState() {
    super.initState();

    this.nameInputController =
        TextEditingController(text: widget.position?.name ?? '');
    this.quantityInputController =
        TextEditingController(text: widget.position?.qty.toString() ?? '');
    this.selectedUnit = widget.position?.unit ?? '';

    this.nameInputNode = FocusNode();
    this.quantityInputNode = FocusNode();
    this.nameInputNode.requestFocus();
  }

  @override
  void dispose() {
    nameInputController.dispose();
    quantityInputController.dispose();
    nameInputNode.dispose();
    quantityInputNode.dispose();
    super.dispose();
  }

  void _showUnitModal() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.3,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) => ListView(
                  controller: scrollController,
                  children: [
                    ...RecipesService().units.map((unit) => ListTile(
                          title: Text(unit),
                          onTap: () {
                            setState(() {
                              this.selectedUnit = unit;
                            });
                            Navigator.of(context).pop();
                          },
                        ))
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    void submit() {
      if (this.nameInputController.text.isEmpty) {
        setState(() {
          this.nameInputNode.requestFocus();
        });
      } else if (this.quantityInputController.text.isEmpty) {
        setState(() {
          this.quantityInputNode.requestFocus();
        });
      } else if (this.selectedUnit.isEmpty) {
        setState(() {
          this.nameInputNode.unfocus();
          this.quantityInputNode.unfocus();
          this._showUnitModal();
        });
      } else {
        widget.onSubmit!(this.nameInputController.text, this.selectedUnit,
            double.parse(this.quantityInputController.text));
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
        LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                      child: TextInput(
                controller: nameInputController,
                focusNode: nameInputNode,
                onTap: () {
                  setState(() {
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
              ).height(50))
                  .width(maxWidth / (nameInputNode.hasFocus ? 2 : 3),
                      animate: true)
                  .animate(const Duration(milliseconds: 250), Curves.linearToEaseOut),
              Container(
                      child: TextInput(
                controller: quantityInputController,
                onTap: () {
                  setState(() {
                    this.quantityInputNode.requestFocus();
                  });
                },
                focusNode: quantityInputNode,
                radius: BorderRadius.circular(1),
                isNumeric: true,
                label: Text('Ilość'),
                onFieldSubmitted: (text) {
                  setState(() {
                    // unitInputNode.requestFocus();
                  });
                },
              ).height(50))
                  .width(maxWidth / (nameInputNode.hasFocus ? 4 : 3),
                      animate: true)
                  .animate(const Duration(milliseconds: 250), Curves.linearToEaseOut),
              GestureDetector(
                onTap: () {
                  setState(() {
                    this.nameInputNode.unfocus();
                    this.quantityInputNode.unfocus();
                    this._showUnitModal();
                  });
                },
                child: Container(
                  color: PrzepisnikColors.INPUTFILL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                              this.selectedUnit.isNotEmpty
                                  ? this.selectedUnit
                                  : 'Jednostka',
                              style: TextStyle(
                                  color: this.selectedUnit.isEmpty ? Theme.of(context)
                                      .primaryColor
                                      .withAlpha(220) : Colors.black,
                                  fontSize: 16,
                                  height: 1,
                                  letterSpacing: 1))
                          .padding(left: 5)
                    ],
                  ),
                )
                    .height(48)
                    .clipRRect(topRight: 25, bottomRight: 25)
                    .borderRadius(topRight: 25, bottomRight: 25)
                    .width(maxWidth / (nameInputNode.hasFocus ? 4 : 3),
                        animate: true)
                    .animate(
                        const Duration(milliseconds: 250), Curves.linearToEaseOut),
              )
            ],
          ).width(maxWidth);
        }).padding(top: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.onDelete != null ? TextButton(
                onPressed: () {
                  widget.onDelete!();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 50)),
                child: Text('Usuń',
                    style: TextStyle(color: PrzepisnikColors.ERROR))) : Container(),
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
