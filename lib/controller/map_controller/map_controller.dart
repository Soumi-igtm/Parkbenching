import 'package:get/get.dart';

class MapController extends GetxController {
  bool? isDetailsShown = false;

  void showMoreDetails() {
    isDetailsShown = !isDetailsShown!;
    print(isDetailsShown);
    update();
  }
}
