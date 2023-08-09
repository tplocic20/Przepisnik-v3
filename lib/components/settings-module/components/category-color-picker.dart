import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:przepisnik_v3/components/settings-module/components/category-tile-preview.dart';
import 'package:styled_widget/styled_widget.dart';

List<Color> predefinedColors = [
  Colors.red.shade500,
  Colors.yellow.shade500,
  Colors.pink.shade500,
  Colors.green.shade500,
  Colors.blue.shade500,
  Colors.brown.shade500,
  Colors.orange.shade500,
  Colors.deepPurple.shade500,
  Colors.teal.shade500,
  Colors.indigo.shade500,
];

class CategoryColorPicker extends StatefulWidget {
  final String? currentIcon;
  final String? name;
  final Color? color;
  final Function? onChanged;

  const CategoryColorPicker(
      {this.color,
      @required this.name,
      @required this.currentIcon,
      @required this.onChanged});

  @override
  State<CategoryColorPicker> createState() => _CategoryColorPickerState();
}

class _CategoryColorPickerState extends State<CategoryColorPicker> {
  Color selected = Colors.white;

  @override
  void initState() {
    this.selected = widget.color ?? Theme.of(context).primaryColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryTilePreview(
            selectedColor: this.selected,
            selectedIcon: widget.currentIcon,
            name: widget.name!,
            mode: CategoryTilePreviewMode.full),
        HueRingPicker(
          pickerColor: this.selected,
          onColorChanged: (Color color) {
            setState(() {
              this.selected = color;
              widget.onChanged!(color);
            });
          },
        ),
        Wrap(
                children: predefinedColors
                    .map((Color color) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                this.selected = color;
                                widget.onChanged!(color);
                              });
                            },
                            child: Container(),
                            style: ElevatedButton.styleFrom(backgroundColor: color))
                        .width(50)
                        .height(50)
                        .padding(all: 10))
                    .toList())
            .padding(top: 10)
      ],
    );
  }
}
