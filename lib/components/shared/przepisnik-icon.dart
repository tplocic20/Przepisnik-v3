import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrzepisnikIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color color;

  PrzepisnikIcon({required this.icon, this.color = const Color(0xFF000000), this.size = 25});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/$icon.svg', width: this.size, height: this.size, color: this.color,);
  }

}