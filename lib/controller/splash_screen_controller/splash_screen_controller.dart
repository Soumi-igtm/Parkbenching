import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_benching/resources/auth_methods.dart';
import 'package:park_benching/routes/routes.dart';

class SplashScreenController extends GetxController {
  final box = GetStorage();
  String uid = "";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() async {
    uid = await AuthMethods().checkAuth();
    Timer(
      const Duration(seconds: 3),
      () {
        if (box.read("introread") ?? false) {
          if (uid.isNotEmpty) {
            Get.offAllNamed(AppLinks.bottomNavBar, parameters: {"uid": uid});
          }
          Get.offAllNamed(AppLinks.loginSignUp);
        } else {
          Get.offAllNamed(AppLinks.intro);
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SplashScreenController>();
  }
}
