import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/auth_methods.dart';

class LoginSignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: "pradeepta@shaderbytes.com"),
      passwordController = TextEditingController(text: "1234abcd");

  void checkLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    AuthMethods.instance.loginUser(email: emailController.text, password: passwordController.text);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
