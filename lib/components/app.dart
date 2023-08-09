import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/components/settings-module/settings/settings.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';
import 'start/home.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class EntrySwitchApp extends StatefulWidget {
  @override
  _EntrySwitchAppState createState() => _EntrySwitchAppState();
}

class _EntrySwitchAppState extends State<EntrySwitchApp>
    with TickerProviderStateMixin {
  late int _selectedPage;
  bool _reversed = false;
  PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    this._selectedPage = 1;
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      this._reversed = index < this._selectedPage;
      this._selectedPage = index;
      // this._pageController.jumpToPage(index);
      this._pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.decelerate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userState = AuthService().getUserScope();

    if (_userState == null) {
      return HomePage();
    } else {
      globals.userState = _userState.uid;
      return FutureBuilder(
        future: RecipesService().init(),
        builder: (context, snapshot) => Scaffold(
          bottomNavigationBar: Container(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                snakeShape: SnakeShape.circle,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                ),
                snakeViewColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(top: 4, left: 32, right: 32),
                height: 60,
                currentIndex: this._selectedPage,
                onTap: this.changePage,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Discover'),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My kitchen'),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Settings'),
                ],
              ),
            ),
          ),
          body: BackdropSimple(
            frontLayer: SizedBox.expand(
              child: PageView(
                  children: [SettingsPage(), RecipesPage(), SettingsPage()],
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics()
              ),
            ),
            title: [Text('Discover'), Text('Recipes'), Text('Settings')][this._selectedPage],
            // title: [Text('Discover'), Text('Recipes'), Text('Settings')][this._selectedPage],
          ),
        ),
      );
    }
  }
}
