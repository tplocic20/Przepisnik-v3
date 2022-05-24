import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class IngredientPositionForm extends StatelessWidget {
  final Ingredient? position;
  final Function? onSubmit;

  const IngredientPositionForm({this.position, @required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameInputController = TextEditingController(text: this.position?.name ?? '');
    TextEditingController quantityInputController = TextEditingController(text: this.position?.qty.toString() ?? '1');

    return BottomModalInputWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(this.position != null ? 'Edytuj ${this.position!.name}' :'Nowa pozycja')
              .fontSize(18)
              .padding(bottom: 10),
          TextInput(
            controller: nameInputController,
            autofocus: true,
            onFieldSubmitted: (text) {
              this.onSubmit!(text);
            },
          ).height(50),
          Row(
            children: [
              TextInput(
                controller: quantityInputController,
                isNumeric: true,
                onFieldSubmitted: (text) {
                  this.onSubmit!(text);
                },
              ).height(50),
            ],
          )
        ],
      ).padding(all: 15),
    );
  }
}
