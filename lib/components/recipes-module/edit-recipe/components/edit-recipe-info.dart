import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/categories-form.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/components/shared/roundedExpansionPanelList.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:styled_widget/styled_widget.dart';

class EditRecipeInfo extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeInfo({@required required this.recipe});

  @override
  _EditRecipeInfoState createState() => _EditRecipeInfoState();
}

class _EditRecipeInfoState extends State<EditRecipeInfo>
    with AutomaticKeepAliveClientMixin<EditRecipeInfo> {
  List<bool> expanded = [true, false];

  late TextEditingController nameInputController;
  late TextEditingController temperatureInputController;
  late TextEditingController timeInputController;

  void initState() {
    nameInputController = TextEditingController(text: widget.recipe.name ?? '');
    temperatureInputController =
        TextEditingController(text: widget.recipe.temperature ?? '');
    timeInputController = TextEditingController(text: widget.recipe.time ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RoundedExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            expanded[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
              isExpanded: expanded[0],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Detale'),
                );
              },
              body: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Nazwa')
                          .textAlignment(TextAlign.end)
                          .textColor(Theme.of(context).primaryColor)
                          .width(100)
                          .padding(right: 10),
                      Expanded(
                          child: TextInput(
                        controller: nameInputController,
                        onChanged: (String name) {
                          widget.recipe.name = name;
                        },
                      ))
                    ],
                  ).padding(top: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Temperatura')
                          .textAlignment(TextAlign.end)
                          .textColor(Theme.of(context).primaryColor)
                          .width(100)
                          .padding(right: 10),
                      Expanded(
                          child: TextInput(
                              icon: PrzepisnikIcons.temperature,
                              controller: temperatureInputController,
                              onChanged: (String temperature) {
                                widget.recipe.temperature = temperature;
                              }))
                    ],
                  ).padding(top: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Czas')
                          .textAlignment(TextAlign.end)
                          .textColor(Theme.of(context).primaryColor)
                          .width(100)
                          .padding(right: 10),
                      Expanded(
                          child: TextInput(
                              icon: PrzepisnikIcons.time,
                              controller: timeInputController,
                              onChanged: (String time) {
                                widget.recipe.time = time;
                              }))
                    ],
                  ).padding(top: 5),
                ],
              ).padding(horizontal: 5)),
          ExpansionPanel(
              isExpanded: expanded[1],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Kategorie'),
                );
              },
              body: CategoriesForm(recipe: widget.recipe))
        ],
      ).padding(all: 5).padding(bottom: 100),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
