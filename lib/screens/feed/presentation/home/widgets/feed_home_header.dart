import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_filter_header.dart';

class FeedHomeHeaderComponent extends StatefulWidget {
  final bool? isCategoryScreen;
  final UserModel? user;
  const FeedHomeHeaderComponent(
      {super.key,
      required this.isCategoryScreen,
      required this.user});

  @override
  State<FeedHomeHeaderComponent> createState() =>
      _FeedHomeHeaderComponentState();
}

class _FeedHomeHeaderComponentState extends State<FeedHomeHeaderComponent> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //*----STATION NAME CONTAINER ----/
        Expanded(
            flex: 3,
            child: StationFilter(user: widget.user,)),
        kWidth15,
        //*---------SEARCH BAR-------/
        searchBar(searchCtrl, context, widget.user),

        if (widget.isCategoryScreen == true) ...[
          kWidth15,
          FilterSection()
        ]
      ],
    );
  }

  /// Returns the station name or a default message if the name is empty.
}
