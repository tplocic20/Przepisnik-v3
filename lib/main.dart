import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:przepisnik_v3/components/app.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class PrzepisnikColors {
  static final PRIMARY = const Color(0xFF6c864f);
  static final PRIMARY_DARK = const Color(0xFF405925);
  static final PRIMARY_LIGHT = const Color(0xFF9bb67c);
  static final ACCENT = const Color(0xFFeebb4d);
  static final SCAFFOLD = const Color(0xFFF5F3E7);
  static final BACKGROUND = const Color(0xFFF5F3E7);
  static final ERROR = const Color(0xFFF46060);
  static final INFO = const Color(0xFFB5DEFF);
  static final WARNING = const Color(0xFFF3D179);
  static final INPUTFILL = const Color(0xFFDBDBDB).withAlpha(160);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PrzepisnikApp());
}

final ThemeData theme = ThemeData();

class PrzepisnikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    fetchModes();
    return GetMaterialApp(
      title: 'Przepisnik',
      home: EntrySwitchApp(),
      theme: theme.copyWith(
          brightness: Brightness.light,
          primaryColor: PrzepisnikColors.PRIMARY,
          primaryColorLight: PrzepisnikColors.PRIMARY_LIGHT,
          primaryColorDark: PrzepisnikColors.PRIMARY_DARK,
          scaffoldBackgroundColor: PrzepisnikColors.SCAFFOLD,
          textTheme: GoogleFonts.montserratTextTheme(Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black87, displayColor: Colors.black87)),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: PrzepisnikColors.PRIMARY,
            selectionHandleColor: PrzepisnikColors.PRIMARY,
          ),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              isDense: true,
              labelStyle: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: PrzepisnikColors.PRIMARY),
              focusColor: PrzepisnikColors.PRIMARY,
              prefixStyle: TextStyle(color: PrzepisnikColors.PRIMARY),
              suffixStyle: TextStyle(color: PrzepisnikColors.PRIMARY),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: PrzepisnikColors.PRIMARY),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: PrzepisnikColors.ERROR),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: PrzepisnikColors.ERROR),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              )),
          colorScheme: theme.colorScheme
              .copyWith(
                primary: PrzepisnikColors.PRIMARY,
                secondary: PrzepisnikColors.ACCENT,
                secondaryContainer: PrzepisnikColors.ACCENT,
                background: PrzepisnikColors.BACKGROUND,
              )
              .copyWith(background: PrzepisnikColors.BACKGROUND)
              .copyWith(error: PrzepisnikColors.ERROR)),
    );
  }
}

Future<void> fetchModes() async {
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } on PlatformException {}
}

ThemeData _appTheme() {
  return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: PrzepisnikColors.PRIMARY,
      primaryColorLight: PrzepisnikColors.PRIMARY_LIGHT,
      primaryColorDark: PrzepisnikColors.PRIMARY_DARK,
      scaffoldBackgroundColor: PrzepisnikColors.SCAFFOLD,
      textTheme: GoogleFonts.montserratTextTheme(TextTheme(
        displayLarge:
            const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        bodyMedium:
            const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
      )),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: PrzepisnikColors.PRIMARY,
        selectionHandleColor: PrzepisnikColors.PRIMARY,
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          isDense: true,
          labelStyle: TextStyle(
              fontSize: 15, letterSpacing: 1, color: PrzepisnikColors.PRIMARY),
          focusColor: PrzepisnikColors.PRIMARY,
          prefixStyle: TextStyle(color: PrzepisnikColors.PRIMARY),
          suffixStyle: TextStyle(color: PrzepisnikColors.PRIMARY),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.PRIMARY),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.ERROR),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: PrzepisnikColors.ERROR),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          )),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(background: PrzepisnikColors.BACKGROUND)
          .copyWith(error: PrzepisnikColors.ERROR));
}
