import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_benching/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:park_benching/view/constant/images.dart';
import 'package:park_benching/view/widget/my_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Image.asset(
                  kLogo,
                  height: 137,
                ),
                MyText(
                  align: TextAlign.center,
                  text: 'Find a park bench',
                  size: 18,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
