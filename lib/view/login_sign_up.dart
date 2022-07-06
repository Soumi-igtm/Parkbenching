import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkbenching/controller/login_signup_controller.dart';
import 'package:parkbenching/routes/routes.dart';
import 'package:parkbenching/view/constant/color.dart';
import 'package:parkbenching/view/constant/validators.dart';
import 'package:parkbenching/view/widget/my_button.dart';
import 'package:parkbenching/view/widget/my_text.dart';

class LoginSignUp extends GetView<LoginSignupController> {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Center(child: Image.asset("assets/images/logo.png", width: context.width / 2)),
              MyText(
                text: 'BenchNearby',
                size: 30,
                align: TextAlign.center,
                weight: FontWeight.w900,
              ),
              MyText(
                paddingTop: 40,
                text: 'Welcome! Do you wish to create an account',
                size: 18,
                weight: FontWeight.w700,
              ),
              MyText(
                text: 'Enter your email to login or sign up',
                paddingTop: 10,
                paddingBottom: Get.height * 0.020,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    autofocus: false,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                    onSaved: (value) {
                      controller.emailController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  controller: controller.passwordController,
                  obscureText: true,
                  validator: passwordValidator,
                  onSaved: (value) {
                    controller.passwordController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              MyButton(
                  onPressed: () async {
                    controller.checkLogin();
                  },
                  text: 'Next'),
              const SizedBox(height: 5),
              Container(
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: kBorderColor,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => controller.guestLogin(),
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
              ),
              Flexible(child: Container(), flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
