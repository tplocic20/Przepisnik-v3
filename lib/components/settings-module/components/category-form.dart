import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:przepisnik_v3/components/settings-module/components/category-color-picker.dart';
import 'package:przepisnik_v3/components/settings-module/components/category-icon-picker.dart';
import 'package:przepisnik_v3/components/settings-module/components/category-tile-preview.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/components/shared/text-input.dart';
import 'package:przepisnik_v3/main.dart';
import 'package:przepisnik_v3/models/category.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;

  const CategoryForm({this.category});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController? nameController;
  late String? nameString;
  late String selectedIcon = 'dining-room';
  late Color? selectedColor;

  @override
  void initState() {
    this.nameController =
        TextEditingController(text: widget.category?.name ?? '');

    this.nameString = widget.category?.name ?? '';

    this.selectedIcon = widget.category?.icon ?? 'dining-room';

    this.selectedColor =
        widget.category?.color != null && widget.category!.color!.isNotEmpty
            ? Color(int.parse("0xFF${widget.category!.color!}"))
            : PrzepisnikColors.PRIMARY;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropSimple(
      frontLayer: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryTilePreview(
                selectedIcon: this.selectedIcon,
                name: this.nameString,
                selectedColor: this.selectedColor),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nazwa',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18))
                        .padding(bottom: 5, horizontal: 5)
                        .width(100),
                    Expanded(
                        child: TextInput(
                            controller: nameController,
                            icon: 'time',
                            hint: 'Nazwa',
                            isDense: false,
                            onChanged: (txt) {
                              setState(() {
                                nameString = txt;
                              });
                            }))
                  ],
                ).padding(bottom: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Ikona',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18))
                        .padding(horizontal: 5)
                        .width(100),
                    GestureDetector(
                      onTap: () {
                        showBarModalBottomSheet(
                          expand: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CategoryIconPicker(
                            current: this.selectedIcon,
                            name: this.nameString,
                            color: this.selectedColor,
                            onChanged: (icon) {
                              setState(() {
                                this.selectedIcon = icon;
                              });
                            },
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                          'assets/category_icons/${this.selectedIcon}.svg',
                          width: 65,
                          height: 65),
                    )
                  ],
                ).padding(bottom: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Kolor',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18))
                        .padding(horizontal: 5)
                        .width(100),
                    GestureDetector(
                        onTap: () {
                          showBarModalBottomSheet(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CategoryColorPicker(
                              name: this.nameString,
                              color: this.selectedColor,
                              currentIcon: this.selectedIcon,
                              onChanged: (Color color) {
                                setState(() {
                                  this.selectedColor = color;
                                });
                              },

                            ),
                          );
                        },
                        child: Container(
                          width: 65,
                          height: 65,
                          color: this.selectedColor,
                        ).clipRRect(all: 15))
                  ],
                ),
              ],
            ).padding(horizontal: 15)
          ],
        ),
      ),
      title: Text(this.nameString!),
      action: () {
        if (widget.category != null) {
          widget.category!.name = this.nameString!;
          widget.category!.icon = this.selectedIcon;
          widget.category!.color = this.selectedColor!.toString().toLowerCase().split('(0xff')[1].split(')')[0];
          RecipesService().updateCategory(widget.category!.key, widget.category!).then((value) => Navigator.of(context).pop());
        }
      },
    );
  }
}
