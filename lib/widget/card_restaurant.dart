import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant item;

  const RestaurantCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, DetailRestaurant.routeName,
            arguments: item);
      },
      leading: Hero(
        tag: item.id,
        child: Container(
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            image: item.getPictureLink(),
            placeholder: "images/food-store.png",
          ),
          constraints: BoxConstraints(maxWidth: 100, minWidth: 100),
        ),
      ),
      title: Text(
        item.name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/baseline_grade_black_48dp.png",
                color: Colors.yellow,
                width: 24,
              ),
              Text(item.rating.toString()),
            ],
          ),
          Text(item.city),
        ],
      ),
    );
  }
}
