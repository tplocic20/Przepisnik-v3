import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/components/start/UserNavigation.dart';
import 'package:przepisnik_v3/services/auth-service.dart';

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
      padding: EdgeInsets.only(top: 30),
        child: FlutterLogin(
            title: 'Przepiśnik',
            logo: 'assets/ico.png',
            onLogin: authenticate,
            onSignup: (_) => Future(null),
            onSubmitAnimationCompleted: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserNavigation()),
                  (Route<dynamic> route) => false);
            },
            onRecoverPassword: (_) => Future(null),
            theme: LoginTheme(
                cardTheme: CardTheme(
              // color: Colors.yellow.shade50,
              elevation: 5,
              margin: EdgeInsets.only(top: 15),
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
