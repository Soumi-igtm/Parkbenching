import 'package:get/get.dart';
import 'package:park_benching/view/bottom_nav_bar.dart';
import 'package:park_benching/view/launch/intro.dart';
import 'package:park_benching/view/launch/splash_screen.dart';
import 'package:park_benching/view/rate_park_bench.dart';
import 'package:park_benching/view/report_park_bench/report/report.dart';
import 'package:park_benching/view/report_park_bench/report_park_bench.dart';
import 'package:park_benching/view/send_location/send_location.dart';
import 'package:park_benching/view/top_rated_park_benches/top_rated_park_benches.dart';
import 'package:park_benching/view/login_sign_up.dart';

import '../bindings.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppLinks.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppLinks.intro,
      page: () => const Intro(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: AppLinks.loginSignUp,
      page: () => const LoginSignUp(),
      binding: LoginSignupBinding(),
    ),
    GetPage(
      name: AppLinks.bottomNavBar,
      page: () => const BottomNavBar(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppLinks.reportParkBench,
      page: () => const ReportParkBench(),
    ),
    GetPage(
      name: AppLinks.report,
      page: () => const Report(),
    ),
    GetPage(
      name: AppLinks.rateParkBench,
      page: () => const RateParkBench(),
      binding: RateParkBenchBinding(),
    ),
    GetPage(
      name: AppLinks.sendLocation,
      page: () => const SendLocation(),
    ),
    GetPage(
      name: AppLinks.topRatedParkBenches,
      page: () => const TopRatedParkBenches(),
    ),
  ];
}

class AppLinks {
  static const splashScreen = '/splash_screen';
  static const intro = '/intro';
  static const loginSignUp = '/login_sign_up';
  static const bottomNavBar = '/bottom_nav_bar';
  static const reportParkBench = '/report_park_bench';
  static const report = '/report';
  static const rateParkBench = '/rate_park_bench';
  static const sendLocation = '/send_location';
  static const topRatedParkBenches = '/top_rated_park_benches';
}
