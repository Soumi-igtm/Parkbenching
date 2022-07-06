import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AllBenchController extends GetxController {
  String? parkID = Get.parameters["parkID"];
  String? parkName = Get.parameters["parkName"];

  final box = GetStorage();
  double userLatitude = 0.0, userLongitude = 0.0;

  @override
  void onInit() {
    Map userLocation = box.read("userLocation");
    userLatitude = userLocation["latitude"];
    userLongitude = userLocation["longitude"];
    super.onInit();
  }
}
