import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';

enum CategoryTilePreviewMode { full, iconColor }

class CategoryTilePreview extends StatelessWidget {
  final String? selectedIcon;
  final Color? selectedColor;
  final String? name;
  final CategoryTilePreviewMode? mode;

  const CategoryTilePreview({
    @required this.selectedIcon,
    @required this.name,
    @required this.selectedColor,
    this.mode = CategoryTilePreviewMode.full,
});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/category_icons/${this.selectedIcon!}.svg',
            width: this.mode == CategoryTilePreviewMode.full ? 40 : 60,
            height: this.mode == CategoryTilePreviewMode.full ? 40 : 60,
          ).padding(all: 0),
          Text(this.name!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, decoration: TextDecoration.none)),
        ],
      )
          .backgroundColor(this.selectedColor!)
          .clipRRect(all: 15)
          .width(this.mode == CategoryTilePreviewMode.full ? 120 : 140)
          .height(this.mode == CategoryTilePreviewMode.full ? 100 : 120)
          .padding(horizontal: 10),
    ).padding(vertical: 25);
  }
}
