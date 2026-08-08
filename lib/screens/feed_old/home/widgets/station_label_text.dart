import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StationLabelText extends StatelessWidget {
  final String stationName;

  const StationLabelText({
    super.key,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Station: ".tr(),
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              color: Color(0xFFA8A8A8),
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: stationName,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              color: Color(0xFFA8A8A8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
