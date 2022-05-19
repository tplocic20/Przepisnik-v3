import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:przepisnik_v3/components/shared/bottom-modal-wrapper.dart';
import 'package:przepisnik_v3/components/shared/confirm-bottom-modal.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
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
        children: RecipesService().categories.map((Category category) =>
            Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
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
                    backgroundColor: Color(0xFFF46060),
                    foregroundColor: Colors.white,
                    icon: Icons.delete_rounded,
                    label: 'Usuń',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      showCupertinoModalBottomSheet(
                          context: context, builder: (context) => CategoryForm(category: category));
                    },
                    backgroundColor: Color(0xFFB5DEFF),
                    foregroundColor: Colors.white,
                    icon: Icons.create_rounded,
                    label: 'Edytuj',
                  ),
                ],
              ),
              child: ListTile(title: Text(category.name)).backgroundColor(Colors.white).height(60),
            ).padding(vertical: 10)
        ).toList(),
      ),
    );
  }

}
