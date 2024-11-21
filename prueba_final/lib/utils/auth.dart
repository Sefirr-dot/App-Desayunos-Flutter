import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createAccount(String correo, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: correo, password: pass);
      print(userCredential.user);
      return (userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is weak');
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print("Email already is used");
        return 2;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // El usuario canceló el inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user?.uid;
    } catch (e) {
      print("Error en Google Sign-In: $e");
      return null;
    }
  }
}

Future SingInEmailAndPassword(String correo, String pass) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: correo, password: pass);

    final a = userCredential.user;

    if (a?.uid != null) {
      return a?.uid;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 1;
    } else if (e.code == 'wrong-password') {
      return 2;
    }
  } catch (e) {
    print(e);
  }
}
