import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:przepisnik_v3/components/app.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:styled_widget/styled_widget.dart';

final PRIMARY = const Color(0xFF6c864f);
final PRIMARY_DARK = const Color(0xFF405925);
final PRIMARY_LIGHT = const Color(0xFF9bb67c);
final ACCENT = const Color(0xFFeebb4d);
final SCAFFOLD = const Color(0xFFF5F3E7);
final BACKGROUND = const Color(0xFFF5F3E7);
final ERROR = Color(0xFFF46060);

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
    return MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialWithModalsPageRoute(settings: settings, builder: (context) => EntrySwitchApp());
      },
      title: 'Przepisnik',
      theme: _appTheme(),
      // home: EntrySwitchApp(),
    );
  }
}

Future<void> fetchModes() async {
  try {
    List<DisplayMode> modes = await FlutterDisplayMode.supported;

    DisplayMode current = await FlutterDisplayMode.active;
    DisplayMode selected = modes.firstWhere(
        (DisplayMode m) =>
            m.width == current.width &&
            m.height == current.height &&
            m.refreshRate > 60,
        orElse: () => current);
    FlutterDisplayMode.setPreferredMode(selected);
  } on PlatformException catch (e) {}
}

ThemeData _appTheme() {
  return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: PRIMARY,
      primaryColorLight: PRIMARY_LIGHT,
      primaryColorDark: PRIMARY_DARK,
      accentColor: ACCENT,
      scaffoldBackgroundColor: SCAFFOLD,
      backgroundColor: BACKGROUND,
      errorColor: ERROR,
      textTheme: GoogleFonts.montserratTextTheme(TextTheme(
        headline1: const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        bodyText2: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
      )),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: PRIMARY,
        selectionHandleColor: PRIMARY,
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          isDense: true,
          labelStyle: TextStyle(fontSize: 15, letterSpacing: 1, color: PRIMARY),
          focusColor: PRIMARY,
          prefixStyle: TextStyle(
            color: PRIMARY
          ),
          suffixStyle: TextStyle(
            color: PRIMARY
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: PRIMARY),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: ERROR),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: ERROR),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          )));
}
