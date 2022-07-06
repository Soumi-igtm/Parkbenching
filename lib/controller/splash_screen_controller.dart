import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parkbenching/resources/auth_methods.dart';
import 'package:parkbenching/routes/routes.dart';

class SplashScreenController extends GetxController {
  final box = GetStorage();
  String uid = "";
  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() async {
    uid = await AuthMethods().checkAuth();
    String guest = box.read("guest") ?? "false";
    Timer(
      const Duration(seconds: 2),
      () {
        if (box.read("introread") ?? false) {
          if (uid.isNotEmpty) {
            Get.offAllNamed(AppLinks.bottomNavBar, parameters: {"uid": uid, "guest": guest});
          } else {
            Get.offAllNamed(AppLinks.loginSignUp);
          }
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
