import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:przepisnik_v3/components/start/login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              _helloMsg(),
              _getStarted(context),
              _orDivider(),
              _doLogin(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _helloMsg() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 25),
      child: Text(
        'Witaj w przepiśniku',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget _orDivider() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Text('lub'),
    );
  }

  Widget _getStarted(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: RaisedButton(
          onPressed: () {},
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('Zacznij gotowanie', style: TextStyle(fontSize: 15))),
    );
  }

  Widget _doLogin(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        textColor: Theme.of(context).accentColor,
        child: Text('Zaloguj się'),
      ),
    );
  }
}
