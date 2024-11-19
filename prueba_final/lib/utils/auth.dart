import 'package:firebase_auth/firebase_auth.dart';

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
