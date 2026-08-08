import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class DateTimeFormatters {
  static String getMonthText(DateTime? dateTime) {
    if (dateTime == null) return '';

    final locale = isEnglish ? 'en' : 'ar';
    final month = DateFormat('MMMM', locale).format(dateTime);

    return isEnglish && month.length > 4 ? month.substring(0, 3) : month;
  }

  static String getDateText(DateTime? dateTime) {
    if (dateTime == null) return '';

    final locale = isEnglish ? 'en' : 'ar';
    return DateFormat('d', locale).format(dateTime);
  }

  static String getTimeText(DateTime? dateTime) {
    if (dateTime == null) return '';

    final locale = isEnglish ? 'en' : 'ar';
    return DateFormat.jm(locale).format(dateTime);
  }

  static String getTimeRangeText(
    DateTime? startDateTime,
    int? durationInMinutes,
  ) {
    if (startDateTime == null || durationInMinutes == null) {
      return 'Time not available'.tr();
    }

    final locale = isEnglish ? 'en' : 'ar';

    final endDateTime = startDateTime.add(Duration(minutes: durationInMinutes));
    final startFormatted = DateFormat.jm(locale).format(startDateTime);
    final endFormatted = DateFormat.jm(locale).format(endDateTime);

    return '$startFormatted - $endFormatted';
  }

  static DateTime? parseLocalDateTime(String? datetime) {
    if (datetime == null) return null;
    return DateTime.tryParse(datetime)?.toLocal();
  }
}

String getSafeLocale() {
  String locale = PlatformDispatcher.instance.locale.toString();

  // Fix Arabic variants like "ars_US"
  if (locale.startsWith('ars')) locale = 'ar_SA';

  // Allow only supported locales
  final validLocales = ['en', 'en_US', 'ar', 'ar_SA', 'ar_AE'];
  if (!validLocales.contains(locale)) locale = 'en_US';

  return locale;
}

DateFormat safeDateFormat(String pattern) {
  try {
    return DateFormat(pattern, getSafeLocale());
  } catch (_) {
    return DateFormat(pattern, 'en_US');
  }
}

String convertArabicDigitsToEnglish(String input) {
  const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  for (int i = 0; i < arabicDigits.length; i++) {
    input = input.replaceAll(arabicDigits[i], i.toString());
  }
  return input;
}
