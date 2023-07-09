import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Widget buildWrappedTags() {
    return Wrap(
      children: RecipesService()
          .categories
          .map((Category category) =>
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                    'assets/category_icons/${category.icon}.svg',
                    height: 30,
                    width: 30),
                Text(category.name).padding(left: 5)
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: this.selectedCategories.indexOf(category.key) >= 0
                  ? 2
                  : 0,
              foregroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              backgroundColor:
              this.selectedCategories.indexOf(category.key) >= 0
                  ? Theme
                  .of(context)
                  .primaryColorLight
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            onPressed: () {
              setState(() {
                bool value =
                    this.selectedCategories.indexOf(category.key) >= 0;
                if (!value) {
                  this.selectedCategories.add(category.key);
                } else {
                  this.selectedCategories.remove(category.key);
                }
              });
            },
          )
              .padding(right: 5)
              .animate(Duration(milliseconds: 150), Curves.easeOut))
          .toList(),
    );
  }

  Widget buildWrappedTags2() {
    return Column(
      children: RecipesService()
          .categories
          .map((Category category) =>
          ListTile(
              leading: SvgPicture.asset(
                  'assets/category_icons/${category.icon}.svg',
                  height: 30,
                  width: 30),
              title: Text(category.name),
              onTap: () {
                setState(() {
                  bool value =
                      this.selectedCategories.indexOf(category.key) >= 0;
                  if (!value) {
                    this.selectedCategories.add(category.key);
                  } else {
                    this.selectedCategories.remove(category.key);
                  }
                });
              })
              .backgroundColor(this.selectedCategories.indexOf(category.key) >= 0 ? Theme.of(context).colorScheme.secondary.withAlpha(120) : Colors.transparent, animate: true)
              .padding(all: 5)
              .clipRRect(all: 25)
              .borderRadius(all: 25)
              .animate(Duration(milliseconds: 150), Curves.easeOut)
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWrappedTags2(),
    ).paddingDirectional(bottom: 20);
  }

  Widget addCategory(BuildContext context) {
    Duration duration = Duration(milliseconds: 250);
    Text addTitle = Text(this.isAddCategory ? 'Zapisz' : 'Dodaj kategorię',
        key: ValueKey(this.isAddCategory),
        softWrap: false,
        overflow: TextOverflow.fade);
    Widget? addTitleIcon =
    this.isAddCategory ? Container().width(0) : Icon(Icons.add_outlined);

    Widget formWidget = (this.isAddCategory
        ? Row(
      children: [
        TextButton(
          child: Text('Anuluj'),
          style: TextButton.styleFrom(
              foregroundColor: Theme
                  .of(context)
                  .errorColor),
          onPressed: () {
            setState(() {
              this.isAddCategory = false;
            });
          },
        ),
        Flexible(child: TextInput().padding(right: 5))
      ],
    )
        : Container());

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
                foregroundColor: Theme
                    .of(context)
                    .primaryColor,
                side: BorderSide(color: Theme
                    .of(context)
                    .primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)))))
            .width(this.isAddCategory ? 80 : 250, animate: true)
            .height(50)
            .animate(duration, Curves.elasticInOut)
      ],
    );
  }
}
