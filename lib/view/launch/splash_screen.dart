import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkbenching/controller/splash_screen_controller.dart';
import 'package:parkbenching/view/constant/images.dart';
import 'package:parkbenching/view/widget/my_text.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
