import 'package:get/get.dart';
import 'package:park_benching/model/park_bench_model/park_bench_modek.dart';

class ParkBenchController extends GetxController {
  int? currentIndex = 0;

  void selectedIndex(int index) {
    currentIndex = index;
    update();
  }

  final List<ParkBenchModel> dummyBenches = [
    ParkBenchModel(
      parkImage: 'assets/images/dummy_bench.png',
      parkName: 'Shiraj Park',
      rating: 5.0,
      distance: 300,
    ),
    ParkBenchModel(
      parkImage: 'assets/images/unsplash_rpI9UrPcRTI.png',
      parkName: 'Aikatan park',
      rating: 4.0,
      distance: 500,
    ),
    ParkBenchModel(
      parkImage: 'assets/images/unsplash_RF6ihUs5ShA.png',
      parkName: 'Fermont Park',
      rating: 4.0,
      distance: 2000,
    ),
    ParkBenchModel(
      parkImage: 'assets/images/unsplash_pNaljhHpssA.png',
      parkName: 'Redwood Park',
      rating: 3.0,
      distance: 3500,
    ),
  ];

  List<ParkBenchModel> get getDummyBenches => dummyBenches;

}