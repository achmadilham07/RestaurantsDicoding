import 'package:RestaurantsDicoding/data/model/restaurant_detail.dart';
import 'package:RestaurantsDicoding/provider/restaurant_provider.dart';
import 'package:RestaurantsDicoding/utils/result_state.dart';
import 'package:RestaurantsDicoding/utils/static_value.dart';
import 'package:RestaurantsDicoding/widget/search_bar_cupertino.dart';
import 'package:RestaurantsDicoding/widget/search_result_list.dart';
import 'package:RestaurantsDicoding/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<Restaurant> restaurantList;

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
    Provider.of<RestaurantProvider>(context, listen: false)
        .fetchSearchRestaurant(_terms);
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Styles.scaffoldBackground,
      ),
      child: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchBox(context),
        Expanded(
          child: _buildListView(),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        switch (state.state) {
          case ResultState.Loading:
            return Center(child: CircularProgressIndicator());
          case ResultState.HasData:
            restaurantList = state.listRestaurant;

            final suggessionList = _terms.isEmpty
                ? randomRestaurant(widget.restaurantList)
                : restaurantList;
            if (suggessionList == null) {
              return Center(child: CircularProgressIndicator());
            } else if (suggessionList.isEmpty) {
              return Center(child: Text("No data"));
            } else {
              return SearchResultListView(suggessionList: suggessionList);
            }
            break;
          case ResultState.NoData:
            return Center(child: Text(state.message));
          case ResultState.Error:
            return Center(child: Text(state.message));
          default:
            return Center(child: Text(''));
        }
      },
    );
  }
}
