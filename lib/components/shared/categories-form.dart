import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class CategoriesForm extends StatefulWidget {
  final VoidCallback? onValueChanged;

  const CategoriesForm({this.onValueChanged});

  @override
  _CategoriesFormState createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  List<String> selectedCategories = [];
  bool isAddCategory = false;

  @override
  void initState() {
    selectedCategories = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ...RecipesService()
              .categories
              .map((Category category) => CheckboxListTile(
                    value: this.selectedCategories.indexOf(category.key) >= 0,
                    title: Text(category.name),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value! == true) {
                          this.selectedCategories.add(category.key);
                        } else {
                          this.selectedCategories.remove(category.key);
                        }
                      });
                    },
                  ))
              .toList(),
          addCategory(context)
        ],
      ),
    ).paddingDirectional(vertical: 25, horizontal: 10);
  }

  Widget addCategory(BuildContext context) {
    Duration duration = Duration(milliseconds: 250);
    Text addTitle = Text(this.isAddCategory ? 'Zapisz' : 'Dodaj kategorię',
        key: ValueKey(this.isAddCategory),
        softWrap: false,
        overflow: TextOverflow.fade);
    Widget? addTitleIcon =
        this.isAddCategory ? Container().width(0) : Icon(Icons.add_outlined);

    Widget formWidget = (this.isAddCategory ? Row(
      children: [
        TextButton(
          child: Text('Anuluj'),
          style: TextButton.styleFrom(primary: Theme.of(context).errorColor),
          onPressed: () {
            setState(() {
              this.isAddCategory = false;
            });
          },
        ),
        Flexible(
            child: TextInput().padding(right: 5)
        )
      ],
    ) : Container());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: formWidget),
        OutlinedButton(
          onPressed: () {
            setState(() {
              this.isAddCategory = !this.isAddCategory;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: duration,
                child: addTitleIcon,
              ),
              Flexible(
                  child: AnimatedSwitcher(
                    duration: duration,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: addTitle,
                  ),
                  fit: FlexFit.loose)
            ],
          ),
          style: OutlinedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
        )
            .width(this.isAddCategory ? 80 : 250, animate: true)
            .height(50)
            .animate(duration, Curves.elasticInOut)
      ],
    );
  }
}
