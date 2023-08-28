import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:lottie/lottie.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/components/settings-module/settings/settings.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:przepisnik_v3/components/shared/przepisnik_icons.dart';
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
  late final AnimationController _firstPageIconController;
  late final AnimationController _secondPageIconController;
  late final AnimationController _thirdPageIconController;
  PageController _pageController = PageController(initialPage: 1);
  PageController _titleController = PageController(initialPage: 1);
  Widget _headerText = Text('Discover', key: ValueKey(1));

  @override
  void initState() {
    super.initState();
    this._selectedPage = 1;

    this._firstPageIconController = AnimationController(vsync: this)
      ..value = 0
      ..duration = const Duration(milliseconds: 2000)
      ..addListener(() {
        setState(() {});
      });
    this._secondPageIconController = AnimationController(vsync: this)
      ..value = 0
      ..duration = const Duration(milliseconds: 2000)
      ..addListener(() {
        setState(() {});
      });
    this._thirdPageIconController = AnimationController(vsync: this)
      ..value = 0
      ..duration = const Duration(milliseconds: 2000)
      ..addListener(() {
        setState(() {});
      });

    this._secondPageIconController.animateTo(0.5);
  }

  void changePage(int index) {
    setState(() {
      this._selectedPage = index;
      this._pageController.animateToPage(index,
          duration: const Duration(milliseconds: 1000), curve: Curves.easeOutExpo);
      this._titleController.animateToPage(index,
          duration: const Duration(milliseconds: 1000), curve: Curves.easeOutExpo);

      if (index == 0) {
        this._firstPageIconController.animateTo(0.5, curve: Curves.easeOut);
        this._secondPageIconController.animateTo(0, curve: Curves.ease);
        this._thirdPageIconController.animateTo(0, curve: Curves.easeOutCubic);
        this._headerText = Text('Discover', key: ValueKey(1));
      } else if (index == 1) {
        this._firstPageIconController.animateTo(0, curve: Curves.easeIn);
        this._secondPageIconController.animateTo(0.5, curve: Curves.ease);
        this._thirdPageIconController.animateTo(0, curve: Curves.easeOutCubic);
        this._headerText = Text('Recipes', key: ValueKey(2));
      } else if (index == 2) {
        this._firstPageIconController.animateTo(0, curve: Curves.ease);
        this._secondPageIconController.animateTo(0, curve: Curves.ease);
        this._thirdPageIconController.animateTo(0.5, curve: Curves.bounceOut);
        this._headerText = Text('Settings', key: ValueKey(3));
      }
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
                  BottomNavigationBarItem(
                      icon: Lottie.asset('assets/chocolate.json',
                          repeat: false,
                          controller: this._firstPageIconController,
                          frameRate: FrameRate(120),
                          height: 45,
                          fit: BoxFit.fitHeight).scale(all: this._selectedPage == 0 ? 1: .8, animate: true).animate(const Duration(milliseconds: 250), Curves.ease),
                      label: 'Discover'),
                  BottomNavigationBarItem(
                      icon: Lottie.asset('assets/book.json',
                          repeat: false,
                          controller: this._secondPageIconController,
                          frameRate: FrameRate(120),
                          height: 45,
                          fit: BoxFit.fitHeight).scale(all: this._selectedPage == 1 ? 1: .8, animate: true).animate(const Duration(milliseconds: 250), Curves.ease),
                      label: 'My kitchen'),
                  BottomNavigationBarItem(
                      icon: Lottie.asset('assets/settings.json',
                          repeat: false,
                          controller: this._thirdPageIconController,
                          frameRate: FrameRate(120),
                          height: 45,
                          fit: BoxFit.fitHeight).scale(all: this._selectedPage == 2 ? 1: .8, animate: true).animate(const Duration(milliseconds: 250), Curves.ease),
                      label: 'Settings'),
                ],
              ),
            ),
          ),
          body: BackdropSimple(
            frontLayer: SizedBox.expand(
              child: PageView(
                  children: [SettingsPage(), RecipesPage(), SettingsPage()],
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics()),
            ),
            // title: AnimatedSwitcher(
            //   duration: Duration(milliseconds: 250),
            //   child: _headerText,
            // ),
            title: SizedBox(
              height: 40,
              child: PageView(
                  children: [Center(child: Text('Discover')), Center(child: Text('Recipes')), Center(child: Text('Settings'))],
                  controller: _titleController,
                  physics: NeverScrollableScrollPhysics()),
            ),
            // title: [Text('Discover'), Text('Recipes'), Text('Settings')][this._selectedPage],
          ),
        ),
      );
    }
  }
}
