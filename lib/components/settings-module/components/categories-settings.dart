import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import 'package:przepisnik_v3/components/shared/przepisnik_icons.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../models/category.dart';
import 'category-form.dart';

class CategoriesSettings extends StatefulWidget {
  const CategoriesSettings();

  @override
  State<CategoriesSettings> createState() => _CategoriesSettingsState();
}

class _CategoriesSettingsState extends State<CategoriesSettings>
    with TickerProviderStateMixin  {
  late AnimationController controller = BottomSheet.createAnimationController(this);

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    // Animation duration for displaying the BottomSheet
    controller.duration = const Duration(milliseconds: 500);
    // Animation duration for retracting the BottomSheet
    controller.reverseDuration = const Duration(milliseconds: 150);
    // Set animation curve duration for the BottomSheet
    controller.drive(CurveTween(curve: Curves.easeOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView(
        children: [
          ...RecipesService()
              .categories
              .map((Category category) => Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.25,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                transitionAnimationController: controller,
                                context: context,
                                builder: (context) {
                                  return BottomModalWrapper(
                                    child: ConfirmBottomModal(
                                      title:
                                          'Na pewno chcesz usunąć kategorię?',
                                      msg: 'Operacji nie będzie można cofnąć',
                                      type: ConfirmBottomModalType.danger,
                                      action: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                });
                          },
                          child: Container(
                                  child: Icon(CarbonIcons.delete, color: Colors.white,)
                                      .padding(all: 15))
                              .backgroundColor(PrzepisnikColors.ERROR)
                              .width(MediaQuery.of(context).size.width / 4)
                              .height(60),
                        )
                      ],
                    ),
                    child: OpenContainer(closedBuilder: (BuildContext _, VoidCallback openContainer) {
                      return ListTile(
                        title: Hero(tag: '${category.key}', child: Text(category.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16, decoration: TextDecoration.none))),
                        leading: SvgPicture.asset(
                            'assets/category_icons/${category.icon}.svg',
                            height: 55,
                            width: 55),
                      ).backgroundColor(Colors.white).height(60);
                    }, openBuilder: (BuildContext context, VoidCallback _) {
                      return CategoryForm(category: category);
                    })
                  ))
              .toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_outlined),
                          Text('Dodaj kategorię'),
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)))))
                  .width(250)
                  .height(50)
            ],
          ).padding(all: 10)
        ],
      ),
    );
  }
}
