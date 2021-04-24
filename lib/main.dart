import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:provider/provider.dart';
import 'package:przepisnik_v3/components/app.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PrzepisnikApp());
}

class PrzepisnikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    fetchModes();
    return StreamProvider<User>.value(
      value: AuthService().userScope,
      child: MaterialApp(
          title: 'Przepisnik', theme: _appTheme(), home: EntrySwitchApp()),
    );
  }
}

Future<void> fetchModes() async {
  try {
    List<DisplayMode> modes = await FlutterDisplayMode.supported;

    DisplayMode current = await FlutterDisplayMode.current;
    DisplayMode selected = modes.firstWhere(
        (DisplayMode m) =>
            m.width == current.width &&
            m.height == current.height &&
            m.refreshRate > 60,
        orElse: () => null);
    if (selected != null) {
      FlutterDisplayMode.setMode(selected);
    }
  } on PlatformException catch (e) {}
}

ThemeData _appTheme() {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Color(0xFF41681f),
    primaryColorLight: Color(0xFF6f964a),
    primaryColorDark: Color(0xFF153d00),
    accentColor: Color(0xFFd87f33),
    primaryTextTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),

    // Define the default font family.
    fontFamily: 'Poppins',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: Color(0xFF41681f),
              style: BorderStyle.solid,
              width: 1
          ),
        )
    )
  );
}
