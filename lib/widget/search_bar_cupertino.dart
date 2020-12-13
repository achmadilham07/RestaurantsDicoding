import 'package:RestaurantsDicoding/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  SearchBar({
    @required this.controller,
    @required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: CupertinoTextField(
              placeholder: "Search",
              controller: controller,
              focusNode: focusNode,
              style: Styles.searchText,
              cursorColor: Styles.searchCursorColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: controller.clear,
          child: Icon(
            CupertinoIcons.clear_thick,
            color: Styles.searchIconColor,
          ),
        ),
      ],
    );
  }
}
