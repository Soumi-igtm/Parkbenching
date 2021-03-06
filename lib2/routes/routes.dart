import 'package:get/get.dart';
import 'package:park_benching/view/add_park.dart';

import 'package:park_benching/view/launch/intro.dart';
import 'package:park_benching/view/launch/splash_screen.dart';
import 'package:park_benching/view/parks.dart';
import 'package:park_benching/view/rate_park_bench.dart';
import 'package:park_benching/view/report_park_bench/report/report.dart';
import 'package:park_benching/view/report_park_bench.dart';
import 'package:park_benching/view/send_location.dart';
import 'package:park_benching/view/top_rated_park_benches.dart';
import 'package:park_benching/view/login_sign_up.dart';

import '../bindings.dart';
import '../view/add_bench.dart';
import '../view/bottom_nav_bar.dart';

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
      page: () => SendLocation(),
      binding: SendLocationBinding(),
    ),
    GetPage(
      name: AppLinks.topRatedParkBenches,
      page: () => const TopRatedParkBenches(),
    ),
    GetPage(
      name: AppLinks.parks,
      page: () => const Parks(),
    ),
    GetPage(
      name: AppLinks.addPark,
      page: () => const AddPark(),
      binding: AddParkBinding(),
    ),
    GetPage(
      name: AppLinks.addBench,
      page: () => const AddBench(),
      binding: AddBenchBinding(),
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
  static const parks = '/parks';
  static const addPark = '/add_park';
  static const addBench = '/add_bench';
}
