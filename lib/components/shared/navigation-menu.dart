import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/models/routes.dart';
import 'package:przepisnik_v3/services/auth-service.dart';

class NavigationMenu extends StatelessWidget {
  final Routes routeScope;
  final Function closeBackdrop;
  final Function backDropGrab;
  final Function backDropGrabEnd;

  const NavigationMenu(
      {@required this.routeScope,
      this.closeBackdrop,
      this.backDropGrab,
      this.backDropGrabEnd})
      : assert(routeScope != null);

  @override
  Widget build(BuildContext context) {
    double _lastDragPos = 0.0;
    bool _dragDirection;

    Widget _buildRoute(Routes route) {
      final ThemeData theme = Theme.of(context);
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: (DragUpdateDetails details) {
          _dragDirection = details.localPosition.dy > _lastDragPos;
          _lastDragPos = details.localPosition.dy;
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (closeBackdrop != null &&
              _dragDirection != null &&
              !_dragDirection) {
            closeBackdrop();
          }
          _lastDragPos = 0.0;
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 14),
              child: GestureDetector(
                child: Text(
                  getRouteName(route),
                  style: TextStyle(
                      color: route == routeScope
                          ? theme.accentColor
                          : Colors.white,
                      fontWeight: route == routeScope
                          ? FontWeight.bold
                          : FontWeight.normal),
                  textAlign: TextAlign.end,
                ),
                onTap: () {
                  print(getRouteName(route));
                  handleRoute(route, context);
                },
              ),
            ),
            Container(
              width: 150.0,
              height: 2.0,
              color:
                  route == routeScope ? theme.accentColor : theme.primaryColor,
            ),
          ],
        ),
      );
    }

    List<Widget> getListChildren() {
      List<Widget> widgets =
          Routes.values.map((Routes r) => _buildRoute(r)).toList();
      if (backDropGrab != null && this.backDropGrabEnd != null) {
        widgets.add(GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            backDropGrab(details.localPosition.dy);
          },
          onVerticalDragEnd: (DragEndDetails details) {
            backDropGrabEnd();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(''),
          ),
        ));
      }

      return widgets;
    }

    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(children: getListChildren()),
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

  handleRoute(Routes route, BuildContext context) {
    if (route == this.routeScope) {
      return;
    }
    switch (route) {
      case Routes.logout:
        AuthService().signOut();
        break;
      default:
        this.goBack(context);
    }
  }

  goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      this.closeBackdrop();
    }
  }
}
