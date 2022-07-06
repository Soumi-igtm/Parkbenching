import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:parkbenching/routes/routes.dart';
import 'package:parkbenching/view/constant/common.dart';

class AuthMethods {
  static AuthMethods instance = AuthMethods();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> checkAuth() async {
    return _auth.currentUser == null ? "" : _auth.currentUser!.uid;
  }

  void loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
        Get.offAllNamed(AppLinks.bottomNavBar, parameters: {"uid": value.user!.uid});
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          signupUser(email: email, password: password);
          break;
        case "wrong-password":
          customToast("Password is incorrect");
          break;
        case "invalid-email":
          customToast("Invalid email address");
          break;
      }
    }
  }

  void signupUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        String uid = value.user!.uid;
        usersCollection.doc(uid).set({"name": "", "email": email, "image": ""});
        Get.offAllNamed(AppLinks.bottomNavBar, parameters: {"uid": uid});
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          customToast("Account exists");
          break;
        case "weak-password":
          customToast("Password is weak");
          break;
        case "invalid-email":
          customToast("Invalid email address");
          break;
      }
    }
  }

  Future<bool> updateField({required String uid, required String key, required String value}) async {
    await usersCollection.doc(uid).update({key: value});
    return true;
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppLinks.loginSignUp);
  }
}
