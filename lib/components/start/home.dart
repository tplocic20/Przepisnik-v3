import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:przepisnik_v3/components/recipes-module/recipes/recipes.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
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
    return Stack(
          children: [
            FlutterLogin(
                  onLogin: authenticate,
                  // onSignup: signup,
                  onSubmitAnimationCompleted: () {
                    RecipesService().init();
                    Navigator.pushAndRemoveUntil(
                        context, _recipesPage(), (Route<dynamic> route) => false);
                  },
                  onRecoverPassword: recover,
                  navigateBackAfterRecovery: true,
                  theme: LoginTheme(
                      cardTheme: CardTheme(
                        color: Theme.of(context).colorScheme.background,
                        shadowColor: Theme.of(context).colorScheme.secondary,
                        elevation: 5,
                        margin: EdgeInsets.all(0),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                      ),
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
        ).backgroundColor(Theme.of(context).primaryColor).center();
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
      pageBuilder: (context, animation, secondaryAnimation) => RecipesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}