import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PrzepisnikIcons {
  back,
  cook,
  cancel,
  check,
  customer,
  edit,
  favorite,
  logout,
  ingredients,
  login,
  plus,
  mana,
  matcha,
  calculator,
  pot,
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

  PrzepisnikIcon({required this.icon, this.color = const Color(0xFF000000), this.size = 45});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/system_icons/${icon.name}.svg', width: this.size, height: this.size, color: this.color,);
  }

}