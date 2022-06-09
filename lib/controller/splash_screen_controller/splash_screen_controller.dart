import 'dart:async';
import 'package:get/get.dart';
import 'package:park_benching/routes/routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() {
    Timer(
      const Duration(
        seconds: 3,
      ),
      () => Get.offAllNamed(AppLinks.intro),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SplashScreenController>();
  }
}
