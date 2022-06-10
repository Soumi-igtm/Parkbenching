import 'package:get/get.dart';

class BottomTabController extends GetxController {
  String? uid = Get.parameters["uid"];

  @override
  void onInit() {
    print(uid);
    super.onInit();
  }
}