import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ParkBenchController extends GetxController {
  String? uid = Get.parameters['uid'];
  final box = GetStorage();
  double userLatitude = 0.0, userLongitude = 0.0;
  int? currentIndex = 0;

  void selectedIndex(int index) {
    currentIndex = index;
    update();
  }

  @override
  void onInit() {
    Map userLocation = box.read("userLocation");
    userLatitude = userLocation["latitude"];
    userLongitude = userLocation["longitude"];
    super.onInit();
  }
}