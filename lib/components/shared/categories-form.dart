import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/models/recipe.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class CategoriesForm extends StatefulWidget {
  final Recipe recipe;

  const CategoriesForm({@required required this.recipe});

  @override
  _CategoriesFormState createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  List<String> selectedCategories = [];

  @override
  void initState() {
    selectedCategories = widget.recipe.categories.split(';');
    super.initState();
  }


  Widget addCategory() {

    return OutlinedButton(
                onPressed: () {

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_outlined),
                    Text('Dodaj kategorię'),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)))))
            .width(250)
            .height(50);
  }

  Widget buildWrappedTags2() {
    return Column(children: [
      ...RecipesService()
          .categories
          .map((Category category) => ListTile(
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
              .backgroundColor(
                  this.selectedCategories.indexOf(category.key) >= 0
                      ? Theme.of(context).colorScheme.secondary.withAlpha(120)
                      : Colors.transparent,
                  animate: true)
              .padding(all: 5)
              .clipRRect(all: 25)
              .borderRadius(all: 25)
              .animate(const Duration(milliseconds: 150), Curves.easeOut))
          .toList(),
      addCategory()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWrappedTags2(),
    ).paddingDirectional(bottom: 20);
  }
}
