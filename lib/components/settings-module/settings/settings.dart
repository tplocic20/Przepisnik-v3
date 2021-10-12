import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontLayer: Container(
        child: Center(
          child: Text('setting baby~~~'),
        ),
      ),
      backLayer: [],
      title: Text('Ustawienia'),
    );
  }
}
