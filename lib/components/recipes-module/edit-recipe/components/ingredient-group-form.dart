import 'package:flutter/material.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/components/shared/przepisnik_icons.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class IngredientGroupForm extends StatelessWidget {
  final IngredientGroup? group;
  final Function? onSubmit;

  const IngredientGroupForm({this.group, @required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController(text: this.group?.name ?? '');

    return BottomModalInputWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(this.group != null ? 'Edytuj ${this.group!.name}' :'Nowa kategoria')
              .fontSize(18)
              .padding(bottom: 10),
          TextInput(
            controller: inputController,
            autofocus: true,
            icon: CarbonIcons.time,
            onFieldSubmitted: (text) {
              this.onSubmit!(text);
            },
          ).height(50)
        ],
      ).padding(all: 15),
    );
  }
}
