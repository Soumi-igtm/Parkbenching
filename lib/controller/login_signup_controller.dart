import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parkbenching/view/constant/common.dart';

import '../resources/auth_methods.dart';
import '../routes/routes.dart';

class LoginSignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();
  final TextEditingController emailController = TextEditingController(), passwordController = TextEditingController();

  void checkLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    AuthMethods.instance.loginUser(email: emailController.text, password: passwordController.text);
  }

  void guestLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        String uid = value.user!.uid;
        usersCollection.doc(uid).set({"name": "", "email": "", "image": ""});
        box.write("guest", "true");
        customToast("Signed in with temporary account");
        Get.offAllNamed(AppLinks.bottomNavBar, parameters: {"uid": uid, "guest": "true"});
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          customToast("Anonymous auth hasn't been enabled for this project");
          break;
        default:
          customToast("Some error occurred");
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
