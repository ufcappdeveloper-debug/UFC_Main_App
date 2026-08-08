import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

import '../../extensions/app_colors.dart';

class CommonUtils {
  static List<List<Color>> appBarColors = [
    [Color(0xFFA6D96A), Color(0xFFF7FCF1)],
    // ignore: deprecated_member_use
    [Color(0xff0095FF).withOpacity(0.175), Color(0xFFF7FCF1)],
    [Color(0xFF50D18A), Colors.white],
    [Color(0XFFE2CBF5), Color(0XFFFFFFFF)],
  ];

  static BoxDecoration get scaffoldBackgroundColor {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0XFFF9F3FD),
          const Color(0XFFFFFFFF),
        ],
      ),
    );
  }

  static BoxDecoration chatBackgroundColor(int index) {
    return BoxDecoration(
      gradient: LinearGradient(
        stops: index == 2 ? [0, 0.7] : null,
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: appBarColors[index],
      ),
    );
  }

  static String normalizeLocale(String? locale) {
    if (locale == null || locale.trim().isEmpty) return 'en';

    final normalized = locale.toLowerCase();

    if (normalized.startsWith('ar')) {
      return 'ar';
    }

    if (normalized.startsWith('en')) {
      return 'en';
    }

    if (normalized.startsWith('ur')) {
      return 'ur';
    }

    // Default fallback
    return 'en';
  }

  static Color getAppThemeColor(AppType appType) {
    switch (appType) {
      case AppType.veterinary:
        return AppColors.veterinaryColor;
      case AppType.farm:
        return AppColors.farmColor;
      case AppType.community:
        return primaryPurple;
      default:
        return primaryColor;
    }
  }

  static String getAppLogo(AppType appType) {
    switch (appType) {
      case AppType.veterinary:
        return AppPngImages.vetAppPngLogo;
      case AppType.farm:
        return AppPngImages.farmAppPngLogo;
      case AppType.community:
        return AppPngImages.communityAppPngLogo;
      default:
        return AppPngImages.feedAppPngLogo;
    }
  }

  static BoxDecoration get feedDefaulBoxDecoration {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: feedDefaultBoxShadow,
      borderRadius: BorderRadius.circular(10),
    );
  }

  static List<BoxShadow> get feedDefaultBoxShadow {
    return [
      BoxShadow(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        spreadRadius: 0.5,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        spreadRadius: 1,
        offset: Offset(0, 4),
      ),
    ];
  }
}

/// Safely updates the state of a widget if it is currently mounted.
void safeSetState(State state, VoidCallback callback) {
  if (state.mounted) {
    // ignore: invalid_use_of_protected_member
    state.setState(callback);
  } else {
    debugLog('WARNING: Attempted to update state on an unmounted widget.');
  }
}

int? parseInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return int.tryParse(value.toString());
  if (value is String) return int.tryParse(value);
  return null;
}

bool? parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return (value == '1' || value == 'true');
  return null;
}

String? parseString(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toString();
  return null;
}

double? parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

enum AppType { feed, veterinary, farm, community }
