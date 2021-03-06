import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_villains/villain.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // fetchModes();
    return MaterialApp(
          navigatorObservers: [new VillainTransitionObserver()],
          title: 'Przepisnik',
          theme: _appTheme(),
          home: EntrySwitchApp(),
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

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: GoogleFonts.montserratSubrayadaTextTheme(TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
      )),
      // textTheme: TextTheme(
      //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      //   bodyText2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
      // ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          isDense: true,
          labelStyle: TextStyle(
            fontSize: 15,
            letterSpacing: 1
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFF41681f)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          )));
}
