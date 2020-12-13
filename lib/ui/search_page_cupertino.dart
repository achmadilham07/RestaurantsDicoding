import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/ui/detail_restaurant_screen.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/search_bar_cupertino.dart';
import 'package:RestaurantsDicoding/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  static const routeName = '/search_cupertino';
  final List<Restaurant> restaurantList;

  SearchTab({@required this.restaurantList});

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  Widget _buildSearchBox([BuildContext context]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.back),
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: SearchBar(
              controller: _controller,
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggessionList = _terms.isEmpty
        ? randomRestaurant(widget.restaurantList)
        : widget.restaurantList
            .where((element) =>
                element.name.toLowerCase().contains(_terms.toLowerCase()))
            .toList();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Styles.scaffoldBackground,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildSearchBox(context),
            Expanded(
              child: ListView.builder(
                itemCount: suggessionList.length,
                itemBuilder: (context, index) => Material(
                  child: ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text(suggessionList.elementAt(index).name),
                    onTap: () {
                      Navigator.pushNamed(context, DetailRestaurant.routeName,
                          arguments: suggessionList.elementAt(index));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
