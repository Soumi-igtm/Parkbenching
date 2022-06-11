import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/routes.dart';

class IntroController extends GetxController {
  final box = GetStorage();

  void next () {
    box.write("introread", true);
    Get.toNamed(AppLinks.loginSignUp);
  }
}