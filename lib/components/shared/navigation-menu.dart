import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/routes.dart';

class NavigationMenu extends StatelessWidget {
  final Routes routeScope;

  const NavigationMenu({@required this.routeScope})
      : assert(routeScope != null);

  @override
  Widget build(BuildContext context) {

    Widget _buildRoute(Routes route) {
      final ThemeData theme = Theme.of(context);
      return GestureDetector(
        onTap: () {
          print('elo');
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 14),
              child: Text(
                getRouteName(route),
                style: TextStyle(
                    color: route == routeScope ? theme.accentColor : Colors.white,
                    fontWeight: route == routeScope ? FontWeight.bold : FontWeight.normal),
                textAlign: TextAlign.end,
              ),
            ),
            Container(
              width: 150.0,
              height: 2.0,
              color: route == routeScope ? theme.accentColor : theme.primaryColor,
            ),
          ],
        ),
      );
    }

    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
          children: Routes.values
              .map((Routes r) => _buildRoute(r))
              .toList()),
    );
  }

  getRouteName(Routes route) {
    switch (route) {
      case Routes.favourites:
        return 'Ulubione';
        break;
      case Routes.recipes:
        return 'Przepisy';
        break;
      case Routes.notes:
        return 'Notatki';
        break;
      case Routes.settings:
        return 'Ustawienia';
        break;
      case Routes.logout:
        return 'Wyloguj';
        break;
    }
  }
}
