import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime? {
  DateFormat get formatter => DateFormat('yyyy-MM-dd', 'en');
  DateFormat get monthWithDay => DateFormat('EEE MMM d', 'en');

  String? toFormattedDate() {
    if (this == null) return null;
    try {
      return formatter.format(this!);
    } catch (e) {
      return null;
    }
  }

  String? toFormattedDateWithDay(String locale) {
    if (this == null) return null;
    try {
      final date = this!;
      if (locale == 'ar') {
        // Temporarily use English locale for numbers, but Arabic for words
        final formatter = DateFormat('EEEE d MMMM', 'ar');

        // Format normally
        String result = formatter.format(date);

        // Replace Arabic numerals (٠١٢٣٤٥٦٧٨٩) with Western ones (0123456789)
        const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
        for (int i = 0; i <= 9; i++) {
          result = result.replaceAll(arabicNums[i], i.toString());
        }

        return result;
      } else {
        return "${DateFormat('EEE', locale).format(date)}\t${DateFormat('MMM', locale).format(date)}\t${DateFormat('d').format(date)}";
      }
    } catch (e) {
      return null;
    }
  }

  String? toFormattedTime(String locale) {
    if (this == null) return null;
    try {
      // Format the time in 12-hour format with AM/PM with timezone
      return "${DateFormat('hh:mm', 'en').format(this!)} ${DateFormat('a', locale).format(this!)}";
    } catch (e) {
      return null;
    }
  }
}
