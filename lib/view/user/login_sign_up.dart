import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/resources/auth_methods.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/utils/utils.dart';
import 'package:park_benching/view/constant/color.dart';
import 'package:park_benching/view/constant/validators.dart';
import 'package:park_benching/view/widget/my_button.dart';
import 'package:park_benching/view/widget/my_text.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: "pradeepta@shaderbytes.com"),
      _passwordController = TextEditingController(text: "1234abcd");

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Flexible(child: Container(), flex: 2),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    autofocus: false,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                    onSaved: (value) {
                      _emailController.text = value!;
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
                  controller: _passwordController,
                  obscureText: true,
                  validator: passwordValidator,
                  onSaved: (value) {
                    _passwordController.text = value!;
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
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
                  },
                  text: 'Next'),
              const SizedBox(height: 5),
              skipButton(),
              Flexible(child: Container(), flex: 2),
            ],
          ),
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
