import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/settings-module/components/categories-settings.dart';
import 'package:przepisnik_v3/components/shared/backdrop-simple.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BackdropSimple(
      frontLayer: Container(
        child: Container(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxHeight: 150.0),
                  child: TabBar(
                    unselectedLabelColor: Theme.of(context).primaryColorLight,
                    labelColor: Theme.of(context).primaryColorDark,
                    indicatorColor: Theme.of(context).primaryColorDark,
                    tabs: [
                      Tab(text: 'Aplikacja'),
                      Tab(text: 'Kategorie'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(),
                      CategoriesSettings()
                    ],
                  ),
                ),
              ],
            ).backgroundColor(Colors.transparent),
          ),
        ),
      ),
      title: Text('Ustawienia'),
    );
  }
}
