import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/recipes/recipes.dart';
import 'package:przepisnik_v3/services/auth-service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _userName = TextEditingController();
  final _userPassword = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _getInput(String label, TextEditingController _controller, bool _isPassword) {
      return TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            filled: true,
            labelText: label,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                  width: 1
              ),
            )
        ),
        obscureText: _isPassword,
        validator: (value) {
          if(value.length == 0) {
            return label + ' nie może być puste';
          } else {
            return null;
          }
        },
        keyboardType: _isPassword ? TextInputType.text : TextInputType.emailAddress,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 120.0),
            _getInput("Email", _userName, false),
            SizedBox(height: 12.0),
            _getInput("Hasło", _userPassword, true),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Anuluj'),
                  onPressed: () {
                    _userName.clear();
                    _userPassword.clear();
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  onPressed: () async {
                    await _authService.signInCredentials(_userName.text, _userPassword.text).then((val) {
                      if (val != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RecipesPage()),
                        );
                      }
                    });
                  },
                  child: Text('Login')
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}