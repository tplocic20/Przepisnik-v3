import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropSimple(
      frontLayer: Container(
        child: Center(
          child: Text('setting baby~~~'),
        ),
      ),
      title: Text('Ustawienia'),
    );
  }
}
