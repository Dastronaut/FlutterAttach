import 'package:firebase_auth/firebase_auth.dart';

class RegisterProvider {
  Future<String> registerbyEmail(
      {required String email, required String passWord}) async {
    String msg = 'success';
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passWord,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = "weakPassword";
      } else if (e.code == 'email-already-in-use') {
        msg = "doubleEmail";
      }
    } catch (e) {
      print(e);
    }
    return msg;
  }
}
