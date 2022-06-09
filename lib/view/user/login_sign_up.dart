import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/resources/auth_methods.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/widget/my_button.dart';
import 'package:park_benching/view/widget/my_text.dart';
import 'package:park_benching/view/widget/my_text_field.dart';

class LoginSignUp extends StatefulWidget {
   const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void dispose() {
    dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: ListView(
          children: [
            MyText(
              paddingTop: 48,
              text: 'Welcome! Do you wish to create an account',
              size: 18,
              weight: FontWeight.w900,
            ),
            MyText(
              text: 'Enter your email to login or sign up',
              paddingTop: 10,
              paddingBottom: Get.height * 0.035,
            ),
            MyTextField(
              hintText: 'Enter your email',
              paddingBottom: Get.height * 0.05,
            ),
            MyTextField(
              obSecure: true,
              hintText: 'Enter your password',
              paddingBottom: Get.height * 0.1,
            ),
            InkWell(
              onTap: () async {
                String res = await AuthMethods().signUpUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                print(res);
              },

            child :MyButton(
              onPressed: () => Get.toNamed(AppLinks.bottomNavBar),
              text: 'Next',
            ),
            ),
            const SizedBox(
              height: 5,
            ),
            skipButton(),
          ],
        ),
      ),
    );
  }

  Widget skipButton() {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kBorderColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(AppLinks.bottomNavBar),
        borderRadius: BorderRadius.circular(5),
        splashColor: kTertiaryColor.withOpacity(0.05),
        highlightColor: kTertiaryColor.withOpacity(0.05),
        child: Center(
          child: MyText(
            text: 'Skip',
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}