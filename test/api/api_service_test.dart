import 'package:RestaurantsDicoding/service/api_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider Test', () {
    ApiConfig _apiconfig;
    setUp(() {
      _apiconfig = ApiConfig();
    });

    test('Fetch list restaurant length', () async {
      final restoData = await _apiconfig.getRestaurants();
      expect(20, restoData.restaurants.length);
    });

    test('Fetch list restaurant item data', () async {
      var id = "s1knt6za9kkfw1e867";
      final restoData = await _apiconfig.getRestaurants();
      final itemRestoData = await _apiconfig.getDetailRestaurant(id);
      final itemRestoDataFromList = restoData.restaurants
          .where((element) => element.id == id)
          .toList()
          .first;

      expect(itemRestoData.restaurant.name, itemRestoDataFromList.name);
    });

    test('Fetch new review', () async {
      var id = "rqdv5juczeskfw1e867";
      var name = "Belajarubic";
      var review = "lagi belajar flutter";
      final restoData = await _apiconfig.addReviewRestaurant(id, name, review);

      expect(false, restoData.error);
    });
  });
}
