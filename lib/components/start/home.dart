import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:styled_widget/styled_widget.dart';

const authErrors = const {
  'user_': 'Użytkownik nie istnieje',
  'bad_pass': 'Błędne hasło',
};

class HomePage extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  Duration get loginTime => Duration(milliseconds: 2250);

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Stack(
          children: [
            CircularParticle(
                // key: UniqueKey(),
                awayRadius: 80,
                numberOfParticles: 100,
                speedOfParticles: 0.5,
                height: screenHeight,
                width: screenWidth,
                onTapAnimation: true,
                particleColor: Colors.white.withAlpha(150),
                awayAnimationDuration: Duration(milliseconds: 600),
                maxParticleSize: 8,
                isRandSize: true,
                isRandomColor: true,
                randColorList: [
                  Theme
                      .of(context)
                      .accentColor
                ],
                awayAnimationCurve: Curves.easeInOutBack,
                enableHover: false,
                connectDots: true, //not recommended
              ).backgroundColor(Theme.of(context).primaryColor).center(),
            FlutterLogin(
                  // logo: 'assets/loader.json',
                  onLogin: authenticate,
                  onSignup: signup,
                  onSubmitAnimationCompleted: () {
                    RecipesService().init();
                    print(RecipesService().categories.length);
                    Navigator.pushAndRemoveUntil(
                        context, _recipesPage(), (Route<dynamic> route) => false);
                  },
                  onRecoverPassword: recover,
                  navigateBackAfterRecovery: true,
                  theme: LoginTheme(
                      pageColorLight: Theme.of(context).accentColor.withAlpha(0),
                      pageColorDark: Theme.of(context).accentColor.withAlpha(32),
                      primaryColor: Theme.of(context).primaryColor,
                      accentColor: Theme.of(context).accentColor,
                      errorColor: Color(0xFFF46060),
                      switchAuthTextColor: Theme.of(context).primaryColor,
                      cardTheme: CardTheme(
                        color: Theme.of(context).backgroundColor,
                        shadowColor: Theme.of(context).accentColor,
                        elevation: 5,
                        margin: EdgeInsets.all(0),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                      ),
                      inputTheme: Theme.of(context).inputDecorationTheme,
                  ),
                  messages: LoginMessages(
                    forgotPasswordButton: 'Zapomniało się?',
                    loginButton: 'ZALOGUJ',
                    signupButton: 'Zacznij gotować',
                    recoverPasswordButton: 'Odzyskaj haslo',
                    userHint: 'Email',
                    goBackButton: 'Wstecz',
                    recoverPasswordDescription: 'Otrzymasz od nas mail z linkiem do zresetownia hasła.',
                    recoverPasswordIntro: 'Odzyskaj hasło',
                    recoverPasswordSuccess: 'Proszę sprawdź email',
                    confirmPasswordError: 'No nie zgadza się',
                    confirmPasswordHint: 'Powtórz hasło',
                    passwordHint: 'Hasło',
                  )).center(),
          ],
        ).backgroundColor(Colors.transparent).center();
  }

  Future<String?> authenticate(LoginData loginData) {
    return _authService
        .signInCredentials(loginData.name, loginData.password);
  }

  Future<String?> signup(LoginData loginData) {
    return _authService
        .signUp(loginData.name, loginData.password);
  }

  Future<String?> recover(String email) {
    return _authService
        .recoverPassword(email);
  }

  Route _recipesPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const RecipesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}