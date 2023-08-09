import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PrzepisnikIcons {
  cook,
  customer,
  edit,
  favorite,
  logout,
  plus,
  scale,
  settings,
  share,
  temperature,
  time,
  trash
}

class PrzepisnikIcon extends StatelessWidget {
  final PrzepisnikIcons icon;
  final double size;
  final Color color;

  PrzepisnikIcon({required this.icon, this.color = const Color(0xFF000000), this.size = 25});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/${icon.name}.svg', width: this.size, height: this.size, color: this.color,);
  }

}