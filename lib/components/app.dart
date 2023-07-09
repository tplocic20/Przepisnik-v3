import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'start/home.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class EntrySwitchApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _userState = AuthService().getUserScope();
    if (_userState == null) {
      return HomePage();
    } else {
      globals.userState = _userState.uid;
      return FutureBuilder(
          future: RecipesService().init(),
          builder: (context, snapshot) => RecipesPage()
      );
    }
  }
}

