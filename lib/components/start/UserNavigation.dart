import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/components/settings-module/settings/settings.dart';
import 'package:przepisnik_v3/components/shared/backdrop.dart';
import 'package:przepisnik_v3/models/routes.dart';
import 'package:przepisnik_v3/services/navigation-service.dart';

class UserNavigation extends StatefulWidget {
  @override
  _UserNavigationState createState() => _UserNavigationState();
}

class _UserNavigationState extends State<UserNavigation> {
  Widget currentView = Container();
  Widget currentBottomNav;
  Widget currentBottomButton;
  String currentTitle = '';
  Routes scope = Routes.recipes;

  navigateTo(Routes route) {
    setState(() {
      this.scope = route;
      switch (route) {
        case Routes.favourites:
          // TODO: Handle this case.
          break;
        case Routes.recipes:
          this.currentView = RecipesPage(this.setTitle, this.setBottomNav, this.setBottomBtn);
          break;
        case Routes.notes:
          // TODO: Handle this case.
          break;
        case Routes.settings:
          this.currentView = SettingsPage();
          this.currentTitle = 'Ustawienia';
          this.currentBottomButton = null;
          this.currentBottomNav = null;
          break;
        default:
          break;
      }
    });
  }

  setBottomNav(Widget widget) {
    setState(() {
      this.currentBottomNav = widget;
    });
  }

  setBottomBtn(Widget widget) {
    setState(() {
      this.currentBottomButton = widget;
    });
  }

  setTitle(String title) {
    setState(() {
      this.currentTitle = title;
    });
  }

  @override
  void initState() {
    super.initState();
    this.currentView = RecipesPage(this.setTitle, this.setBottomNav, this.setBottomBtn);
    this.scope = Routes.recipes;
    NavigationService().init(this.navigateTo);
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
        backButtonOverride: false,
        scope: this.scope ?? Routes.recipes,
        title: Text(this.currentTitle),
        frontLayer: AnimatedSwitcher(
          child: this.currentView,
          transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(scale: animation, child: child),
          duration: Duration(milliseconds: 200),
          reverseDuration: Duration(milliseconds: 200),
        ),
        bottomNavigation: this.currentBottomNav,
        bottomMainBtn: this.currentBottomButton);
  }
}
