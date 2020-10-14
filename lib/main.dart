import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/app.dart';
import 'package:przepisnik_v3/services/auth-service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PrzepisnikApp());
}

class PrzepisnikApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return StreamProvider<User>.value(
      value: AuthService().userScope,
      child: MaterialApp(
          title: 'Przepisnik',
          theme: _appTheme(),
          home: EntrySwitchApp()
      ),
    );
  }
}


ThemeData _appTheme() {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Color(0xFF41681f),
    primaryColorLight: Color(0xFF6f964a),
    primaryColorDark: Color(0xFF153d00),
    accentColor: Color(0xFFd87f33),
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white)
    ),

    // Define the default font family.
    fontFamily: 'Poppins',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
    ),
  );
}