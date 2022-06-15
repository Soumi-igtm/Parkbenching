import 'package:get/get.dart';
import 'package:park_benching/controller/rate_park_bench_controller.dart';

import 'controller/bottom_nav_controller.dart';
import 'controller/intro_controller.dart';
import 'controller/login_signup_controller.dart';
import 'controller/report_park_bench_controller.dart';
import 'controller/send_location_controller.dart';
import 'controller/splash_screen_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashScreenController>(SplashScreenController());
  }
}

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(() => IntroController());
  }
}

class LoginSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginSignupController>(() => LoginSignupController());
  }
}

class RateParkBenchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateParkBenchController>(() => RateParkBenchController());
  }
}

class SendLocationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SendLocationController>(() => SendLocationController());
  }
}

