import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TopRatedParkBenchesController extends GetxController {
  int? currentIndex = 0;
  double userLatitude = 0.0, userLongitude = 0.0;
  final box = GetStorage();
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
