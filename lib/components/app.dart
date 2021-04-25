import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/components/start/UserNavigation.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'start/home.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class EntrySwitchApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _userState = Provider.of<User>(context);
    final _recipesService = RecipesService();
    if (_userState == null) {
      return HomePage();
    } else {
      globals.userState = _userState.uid;
      _recipesService.init();
      return UserNavigation();
    }
  }
}

