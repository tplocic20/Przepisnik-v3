import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:zefyrka/zefyrka.dart';

class EditRecipeText extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeText({@required required this.recipe});

  @override
  _EditRecipeTextState createState() => _EditRecipeTextState();
}

class _EditRecipeTextState extends State<EditRecipeText> {
  late ZefyrController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ZefyrController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: ZefyrToolbar.basic(controller: _controller, hideCodeBlock: true),
          ).borderRadius(all: 0).backgroundColor(Colors.grey.shade300),
          Expanded(
            child: Container(
                    child: ZefyrEditor(
              controller: _controller,
            ).paddingDirectional(all: 10))
                .backgroundColor(Colors.white)
          ),
        ],
      ),
    );
  }
}
