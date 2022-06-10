import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/resources/auth_methods.dart';
import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/utils/utils.dart';
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

  final _auth = FirebaseAuth.instance;


  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void signUpUser()async{
    String res = await AuthMethods().signUpUser(
        email: _emailController.text, password: _passwordController.text
    );

    if(res == "success"){

    }else{
      showSnackBar(res, context);
    }
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
        child: Column(
          children: [
            Flexible(child: Container(), flex: 2,),
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
            TextFormField(
                autofocus: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Your Email");
                  }
                  // reg expression for email validation
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return ("Please Enter a valid email");
                  }
                  return null;
                },

                onSaved: (value) {
                  _emailController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
            TextFormField(
                autofocus: false,
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Password(Min. 6 Character)");
                  }
                },
                onSaved: (value) {
                  _passwordController.text = value!;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
             InkWell(
               onTap: signUpUser,
               child: MyButton(
                  onPressed: () => Get.toNamed(AppLinks.bottomNavBar),
                  text: 'Next',
                ),
             ),
            const SizedBox(
              height: 5,
            ),
            skipButton(),
            Flexible(child: Container(), flex: 2,),
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