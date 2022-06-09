import 'package:get/get.dart';
import 'package:park_benching/model/top_rated_park_benches_model/top_rated_park_benches_model.dart';

class TopRatedParkBenchesController extends GetxController {
  int? currentIndex = 0;

  void selectedIndex(int index) {
    currentIndex = index;
    update();
  }

  final List<TopRatedParkBenchesModel> dummyBenches = [
    TopRatedParkBenchesModel(
      parkImage: 'assets/images/dummy_bench.png',
      parkName: 'Berlin park',
      rating: 5.0,
      distance: 300,
    ),
    TopRatedParkBenchesModel(
      parkImage: 'assets/images/unsplash_rpI9UrPcRTI.png',
      parkName: 'Carpet park',
      rating: 4.0,
      distance: 500,
    ),
    TopRatedParkBenchesModel(
      parkImage: 'assets/images/unsplash_RF6ihUs5ShA.png',
      parkName: 'Fermont Park',
      rating: 4.0,
      distance: 2000,
    ),
    TopRatedParkBenchesModel(
      parkImage: 'assets/images/unsplash_pNaljhHpssA.png',
      parkName: 'Redwood Park',
      rating: 3.0,
      distance: 3500,
    ),
  ];

  List<TopRatedParkBenchesModel> get getDummyBenches => dummyBenches;

}
