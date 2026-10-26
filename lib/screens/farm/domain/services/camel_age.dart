import 'package:ufc_mobile/global/shared/constants/constants.dart';

/// Traditional camel names by age ("أسماء الإبل حسب العمر"), computed from
/// the birth date.
class CamelAge {
  CamelAge._();

  /// (minimum age in months, Arabic name, English name), oldest first.
  static const _stages = [
    (84, 'سديس', 'Sudais'), // 7 years
    (72, 'رباع', "Raba'"), // 6 years
    (60, 'ثني', 'Thani'), // 5 years
    (48, 'جذع', "Jitha'"), // 4 years
    (36, 'لقي', 'Laqi'), // 3 years
    (24, 'حق', 'Hiq'), // 2 years
    (12, 'مفرود', 'Mafrood'), // 1 year, weaned from the mother
    (0, 'حوار', 'Hawar'), // from birth
  ];

  /// True when the animal type (any language) is a camel.
  static bool isCamel(String? type) {
    final t = (type ?? '').toLowerCase();
    return t.contains('camel') ||
        t.contains('إبل') ||
        t.contains('أبل') ||
        t.contains('ابل');
  }

  /// The age name at [at] (default: today; pass the death date for dead
  /// animals). Null without a valid birth date.
  static String? nameFor(DateTime? birth, {DateTime? at}) {
    if (birth == null) return null;
    final end = at ?? DateTime.now();
    if (end.isBefore(birth)) return null;
    var months = (end.year - birth.year) * 12 + end.month - birth.month;
    if (end.day < birth.day) months--;
    for (final s in _stages) {
      if (months >= s.$1) return isArOrUr ? s.$2 : s.$3;
    }
    return null;
  }
}
