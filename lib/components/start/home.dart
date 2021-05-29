import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/start/UserNavigation.dart';
import 'package:przepisnik_v3/external/flutter_login/flutter_login.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:przepisnik_v3/services/recipes-service.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;


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
    return Container(
        color: Theme.of(context).primaryColor,
        child: FlutterLogin(
            logo: 'assets/loader.json',
            onLogin: authenticate,
            onSignup: (_) => Future(null),
            onSubmitAnimationCompleted: () {
              RecipesService().init();
              print(globals.categories.length);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserNavigation()),
                  (Route<dynamic> route) => false);
            },
            onRecoverPassword: (_) => Future(null),
            theme: LoginTheme(
                cardTheme: CardTheme(
              elevation: 5,
              margin: EdgeInsets.all(0),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            )),
            messages: LoginMessages(
              forgotPasswordButton: 'Zapomniało się?',
              loginButton: 'ZALOGUJ',
              signupButton: 'Zacznij gotować',
              recoverPasswordButton: 'Odzyskaj haslo',
              usernameHint: 'Email',
              goBackButton: 'Wstecz',
              recoverPasswordDescription: 'recoverPasswordDescription',
              recoverPasswordIntro: 'recoverPasswordIntro',
              recoverPasswordSuccess: 'recoverPasswordSuccess',
              confirmPasswordError: 'confirmPasswordError',
              confirmPasswordHint: 'Powtórz hasło',
              passwordHint: 'Hasło',
            )));
  }

  Future<String> authenticate(LoginData loginData) {
    return _authService
        .signInCredentials(loginData.name, loginData.password)
        .then((val) => val);
  }
}
