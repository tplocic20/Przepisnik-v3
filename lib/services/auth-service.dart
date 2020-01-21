import 'package:firebase_auth/firebase_auth.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get userScope {
    return _auth.onAuthStateChanged;
  }

  Future signInCredentials(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      FirebaseUser user = result.user;
      globals.userState = user.uid;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
