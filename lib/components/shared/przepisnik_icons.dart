import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PrzepisnikIcons {
  mana, avatar, cookbook
}

class PrzepisnikIcon extends StatelessWidget {
  final PrzepisnikIcons icon;
  final double size;

  PrzepisnikIcon({required this.icon, this.size = 45});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/system_icons/${icon.name}.svg', width: this.size, height: this.size);
  }

}