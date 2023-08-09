import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeTextStep extends StatefulWidget {
  final Recipe recipe;
  final int stepId;

  const EditRecipeTextStep({required this.recipe, required this.stepId});

  @override
  _EditRecipeTextStepState createState() => _EditRecipeTextStepState();
}

class _EditRecipeTextStepState extends State<EditRecipeTextStep> with AutomaticKeepAliveClientMixin<EditRecipeTextStep> {
  late TextEditingController _controller;

  @override
  void initState() {
    this._controller = TextEditingController(text: widget.recipe.recipeSteps[widget.stepId].name);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Nazwa')
                .textAlignment(TextAlign.end)
                .textColor(Theme.of(context).primaryColor)
                .width(75)
                .padding(right: 10),
            Expanded(
                child: TextInput(controller: this._controller)
                    .padding(all: 10))
          ],
        ),
        TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                showDragHandle: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomModalWrapper(
                    child: Container()),
              );
            },
            icon: PrzepisnikIcon(icon: PrzepisnikIcons.cook),
            label: Text('Wybierz składniki'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ))
            .padding(top: 10)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

