import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:sheet/route.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../models/category.dart';
import 'category-form.dart';

class CategoriesSettings extends StatefulWidget {
  const CategoriesSettings();

  @override
  State<CategoriesSettings> createState() => _CategoriesSettingsState();
}

class _CategoriesSettingsState extends State<CategoriesSettings> {

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView(
        children: [...RecipesService().categories.map((Category category) =>
            Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return BottomModalWrapper(
                              child: ConfirmBottomModal(
                                title: 'Na pewno chcesz usunąć kategorię?',
                                msg: 'Operacji nie będzie można cofnąć',
                                type: ConfirmBottomModalType.danger,
                                action: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          });
                    },
                    child: Container(child: PrzepisnikIcon(icon: PrzepisnikIcons.trash).padding(all: 15))
                        .backgroundColor(Color(0xFFF46060))
                        .width(MediaQuery.of(context).size.width/4).height(60),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        SheetRoute(builder: (context) => CategoryForm(category: category), draggable: false,
                            duration: Duration(milliseconds: 250), animationCurve: Curves.fastEaseInToSlowEaseOut),
                      );
                    },
                    child: Container(child: PrzepisnikIcon(icon: PrzepisnikIcons.edit).padding(all: 15))
                        .backgroundColor(Color(0xFFB5DEFF))
                        .width(MediaQuery.of(context).size.width/4).height(60),
                  ),
                ],
              ),
              child: ListTile(
                  title: Text(category.name),
                leading: SvgPicture.asset(
                    'assets/category_icons/${category.icon}.svg',
                    height: 55,
                    width: 55),
              ).backgroundColor(Colors.white).height(60),
            )
        ).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [OutlinedButton(
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
                .height(50)],
          ).padding(all: 10)
        ],
      ),
    );
  }

}
