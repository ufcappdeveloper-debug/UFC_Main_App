extension StringExtensions on String {
  int? toTryInt() => int.tryParse(this);

  double? toTryDouble() => double.tryParse(this);

  String capitalize() => split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

extension StringListExtensions on String? {
  DateTime? toDateTime() {
    if (this == null) return null;
    try {
      return DateTime.parse(this!);
    } catch (e) {
      return null;
    }
  }
}
