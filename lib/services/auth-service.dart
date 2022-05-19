import 'package:firebase_auth/firebase_auth.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

class CustomException implements Exception {
  String code;

  CustomException(this.code);
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userScope {
    return _auth.authStateChanges();
  }

  getUserScope() {
    return _auth.currentUser;
  }

  Future<String?> signInCredentials(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!result.user!.emailVerified) {
        return this.getExceptionMessage('EMAIL-NOT-VERIFIED');
      }
      User user = result.user!;
      globals.userState = user.uid;
      return null;
    } catch (e) {
      return this.getExceptionMessage(e);
    }
  }

  Future<String?> recoverPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return this.getExceptionMessage(e);
    }
  }

  Future<String?> signUp(email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return this.getExceptionMessage(e);
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  getExceptionMessage(e) {
    switch (e.code.toString().toUpperCase()) {
      case "INVALID-EMAIL":
        return "Błędny email";
      case "WRONG-PASSWORD":
        return "Błędne hasło";
      case "USER-NOT-FOUND":
        return "Użytkownik nie istnieje";
      case "USER-DISABLED":
        return "Użytkownik nieaktywny";
      case "EMAIL-NOT-VERIFIED":
        return "Proszę zweryfikować adres email";
      case "EMAIL-ALREADY-IN-USE":
        return "Użytkownik pod podanym adresem istnieje";
      default:
        return "Błąd przy logowaniu";
    }
  }
}
