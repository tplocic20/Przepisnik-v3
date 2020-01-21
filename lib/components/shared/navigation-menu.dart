import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/routes.dart';

class NavigationMenu extends StatelessWidget {
  final Routes routeScope;

  const NavigationMenu({@required this.routeScope})
      : assert(routeScope != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
          children: Routes.values
              .map((Routes r) => _buildRoute(r, context))
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
    }
  }

  Widget _buildRoute(Routes route, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        print('elo');
      },
      child: Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  getRouteName(route),
                  style: TextStyle(
                      color: route == routeScope ? theme.accentColor : Colors.white,
                      fontWeight: route == routeScope ? FontWeight.bold : FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14.0),
                Container(
                  width: 120.0,
                  height: 2.0,
                  color: route == routeScope ? theme.accentColor : theme.primaryColor,
                ),
              ],
            ),
    );
  }
}
