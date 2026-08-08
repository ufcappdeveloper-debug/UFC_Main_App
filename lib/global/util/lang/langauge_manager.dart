class LanguageManager {
  static String locale = 'en';

  static void update(String? localeString) {
    locale = normalizeLocale(localeString);
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

    return 'en';
  }
}
