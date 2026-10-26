import 'package:easy_localization/easy_localization.dart';

import '../entities/livestock/live_stock_details_model.dart';
import '../entities/livestock/livestock_reports_model.dart';
import '../entities/report_category.dart' show ReportQuestion;
import 'camel_age.dart';

/// What a farm date means, which decides the logical limits that apply.
enum FarmDateKind {
  /// Any record on a living animal: weight, medicine, disease, pregnancy,
  /// mating, productive status... (today or earlier, within its life).
  event,

  /// A vaccination (event rules + not the same vaccine twice on a day).
  vaccination,

  /// The animal's death (not before birth or its latest record).
  death,

  /// The animal's own birth date (Add/Edit livestock): not after its first
  /// record, within its mother's life.
  birth,

  /// A newborn's birth date in the newborn report, where the selected animal
  /// is the mother: within the mother's life.
  newbornBirth,

  /// Forecasts such as "Expected Calving Date": may be in the future, not
  /// before the mating date.
  expected,
}

/// The dates the app knows about one animal (and optionally its mother).
class AnimalDates {
  final DateTime? birth;
  final DateTime? death;

  /// Every dated record of the animal (report answers, vaccinations, ...),
  /// excluding the death itself.
  final List<DateTime> records;

  /// (vaccine type id, date) of the animal's vaccinations.
  final List<({int? vaccineTypeId, DateTime date, int? id})> vaccinations;

  final DateTime? motherBirth;
  final DateTime? motherDeath;

  /// The animal is a camel (for the camel age names).
  final bool isCamel;

  const AnimalDates({
    this.birth,
    this.death,
    this.records = const [],
    this.vaccinations = const [],
    this.motherBirth,
    this.motherDeath,
    this.isCamel = false,
  });

  static const empty = AnimalDates();

  DateTime? get firstRecord =>
      records.isEmpty ? null : records.reduce((a, b) => a.isBefore(b) ? a : b);

  DateTime? get latestRecord =>
      records.isEmpty ? null : records.reduce((a, b) => a.isAfter(b) ? a : b);

  /// The same dates with [birth] set (e.g. the birth date typed in the
  /// same form, for Add Livestock).
  AnimalDates withBirth(DateTime? birth) => AnimalDates(
        birth: birth ?? this.birth,
        death: death,
        records: records,
        vaccinations: vaccinations,
        motherBirth: motherBirth,
        motherDeath: motherDeath,
        isCamel: isCamel,
      );

  AnimalDates withMother(AnimalDates? mother) => AnimalDates(
        birth: birth,
        death: death,
        records: records,
        vaccinations: vaccinations,
        motherBirth: mother?.birth,
        motherDeath: mother?.death,
        isCamel: isCamel || (mother?.isCamel ?? false),
      );

  /// Builds the dates from the livestock details and report answers.
  factory AnimalDates.from(
      LiveStockDetailsModel? details, ReportResponse? reports) {
    final records = <DateTime>[];
    final vaccinations = <({int? vaccineTypeId, DateTime date, int? id})>[];

    for (final v in details?.vaccinations ?? const []) {
      final date = FarmDateRules.parse(v.vaccinationDate);
      if (date == null) continue;
      records.add(date);
      vaccinations.add((vaccineTypeId: v.vaccineTypeId, date: date, id: v.id));
    }

    for (final group
        in reports?.data ?? const <Map<String, ReportCategory>>[]) {
      for (final category in group.values) {
        for (final answers in (category.answers ?? const {}).values) {
          for (final a in answers) {
            final key = (a.questionKey ?? '').toLowerCase();
            if (key.contains('birth') || key.contains('expected')) continue;
            final date = FarmDateRules.parse(a.answer?.toString());
            if (date != null) records.add(date);
          }
        }
      }
    }

    final birth = FarmDateRules.parse(
        details?.predefinedAnimalDetails?.firstOrNull?.birthDate);
    // The birth date itself is not a "record".
    if (birth != null) records.removeWhere((d) => _sameDay(d, birth));

    final type = details?.predefinedAnimalDetails?.firstOrNull;
    return AnimalDates(
      birth: birth,
      death: details?.deathRecord?.date,
      records: records,
      vaccinations: vaccinations,
      isCamel: CamelAge.isCamel(
          '${type?.animalTypeNameEn ?? ''} ${type?.animalTypeNameAr ?? ''}'),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// The logical date rules of the farm (mirrors the API's validation, so
/// illogical dates are blocked before anything is sent).
class FarmDateRules {
  FarmDateRules._();

  /// "Today" as the farm API sees it (Saudi time, UTC+3).
  static DateTime today() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 3));
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static final _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  /// Parses `yyyy-MM-dd[...]` or `dd/MM/yyyy`; anything else is not a date.
  static DateTime? parse(String? value) {
    if (value == null) return null;
    final v = value.trim();
    if (_datePattern.hasMatch(v)) {
      final d = DateTime.tryParse(v.substring(0, 10));
      return d == null ? null : _day(d);
    }
    final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
    if (m != null) {
      return DateTime(int.parse(m.group(3)!), int.parse(m.group(2)!),
          int.parse(m.group(1)!));
    }
    return null;
  }

  /// `yyyy-MM-dd` (the farm API format), independent of the app locale.
  static String format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Classifies a report date question by its key and text.
  static FarmDateKind kindOf(ReportQuestion? q,
      {bool isNewBornReport = false}) {
    final text = [
      q?.key,
      q?.questionText,
      q?.questionTextAr,
      q?.questionTextUr,
    ].whereType<String>().join(' ').toLowerCase();
    if (text.contains('expected') || text.contains('متوقع')) {
      return FarmDateKind.expected;
    }
    if (text.contains('death') ||
        text.contains('نفوق') ||
        text.contains('وفاة')) {
      return FarmDateKind.death;
    }
    if (text.contains('vaccin') ||
        text.contains('تحصين') ||
        text.contains('تطعيم')) {
      return FarmDateKind.vaccination;
    }
    if (text.contains('birth') ||
        text.contains('ولادة') ||
        text.contains('الميلاد')) {
      return isNewBornReport ? FarmDateKind.newbornBirth : FarmDateKind.birth;
    }
    return FarmDateKind.event;
  }

  /// True for the mating/insemination question that "expected" dates follow.
  static bool isMatingQuestion(String? key, String? text) {
    final t = '${key ?? ''} ${text ?? ''}'.toLowerCase();
    return t.contains('mating') ||
        t.contains('insemination') ||
        t.contains('تلقيح') ||
        t.contains('تزاوج') ||
        t.contains('طلوقة');
  }

  /// Picker limits for a date of [kind]. `max == null` = no upper limit.
  static ({DateTime? min, DateTime? max}) range(
    FarmDateKind kind,
    AnimalDates? a, {
    DateTime? matingDate,
  }) {
    final t = today();
    DateTime? latest(List<DateTime?> ds) {
      final v = ds.whereType<DateTime>().toList();
      return v.isEmpty ? null : v.reduce((x, y) => x.isAfter(y) ? x : y);
    }

    DateTime? earliest(List<DateTime?> ds) {
      final v = ds.whereType<DateTime>().toList();
      return v.isEmpty ? null : v.reduce((x, y) => x.isBefore(y) ? x : y);
    }

    switch (kind) {
      case FarmDateKind.event:
      case FarmDateKind.vaccination:
        return (min: a?.birth, max: earliest([t, a?.death]));
      case FarmDateKind.death:
        return (min: latest([a?.birth, a?.latestRecord]), max: t);
      case FarmDateKind.birth:
        return (
          min: a?.motherBirth,
          max: earliest([t, a?.firstRecord, a?.motherDeath]),
        );
      case FarmDateKind.newbornBirth:
        // The selected animal is the mother.
        return (min: a?.birth, max: earliest([t, a?.death]));
      case FarmDateKind.expected:
        return (min: latest([matingDate, a?.birth]), max: null);
    }
  }

  /// Returns null when [date] is logical, else the message to show.
  static String? validate(
    FarmDateKind kind,
    DateTime date,
    AnimalDates? a, {
    DateTime? matingDate,
    int? vaccineTypeId,
    int? editingVaccinationId,
  }) {
    final d = _day(date);
    String f(DateTime x) => format(x);

    if (kind != FarmDateKind.expected && d.isAfter(today())) {
      return 'date_in_future'.tr();
    }

    switch (kind) {
      case FarmDateKind.event:
      case FarmDateKind.vaccination:
        if (a?.birth != null && d.isBefore(a!.birth!)) {
          return 'date_before_birth'.tr(namedArgs: {'date': f(a.birth!)});
        }
        if (a?.death != null && d.isAfter(a!.death!)) {
          return 'date_after_death'.tr(namedArgs: {'date': f(a.death!)});
        }
        if (kind == FarmDateKind.vaccination && vaccineTypeId != null) {
          final duplicate = (a?.vaccinations ?? const []).any((v) =>
              v.vaccineTypeId == vaccineTypeId &&
              v.id != editingVaccinationId &&
              _sameDay(v.date, d));
          if (duplicate) return 'vaccine_same_day'.tr();
        }
        return null;
      case FarmDateKind.death:
        if (a?.birth != null && d.isBefore(a!.birth!)) {
          return 'date_before_birth'.tr(namedArgs: {'date': f(a.birth!)});
        }
        final last = a?.latestRecord;
        if (last != null && d.isBefore(last)) {
          return 'death_before_last_record'.tr(namedArgs: {'date': f(last)});
        }
        return null;
      case FarmDateKind.birth:
        final first = a?.firstRecord;
        if (first != null && d.isAfter(first)) {
          return 'birth_after_first_record'.tr(namedArgs: {'date': f(first)});
        }
        if (a?.motherBirth != null && d.isBefore(a!.motherBirth!)) {
          return 'birth_before_mother_birth'
              .tr(namedArgs: {'date': f(a.motherBirth!)});
        }
        if (a?.motherDeath != null && d.isAfter(a!.motherDeath!)) {
          return 'birth_after_mother_death'
              .tr(namedArgs: {'date': f(a.motherDeath!)});
        }
        return null;
      case FarmDateKind.newbornBirth:
        if (a?.birth != null && d.isBefore(a!.birth!)) {
          return 'birth_before_mother_birth'
              .tr(namedArgs: {'date': f(a.birth!)});
        }
        if (a?.death != null && d.isAfter(a!.death!)) {
          return 'birth_after_mother_death'
              .tr(namedArgs: {'date': f(a.death!)});
        }
        return null;
      case FarmDateKind.expected:
        if (matingDate != null && d.isBefore(matingDate)) {
          return 'expected_before_mating'
              .tr(namedArgs: {'date': f(matingDate)});
        }
        if (a?.birth != null && d.isBefore(a!.birth!)) {
          return 'date_before_birth'.tr(namedArgs: {'date': f(a.birth!)});
        }
        return null;
    }
  }

  /// Prohibition (withdrawal) period must be a whole number >= 0.
  static String? validateWithdrawal(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final n = int.tryParse(value.trim());
    if (n == null || n < 0) return 'withdrawal_negative'.tr();
    return null;
  }

  /// The mating date among the answers given so far (for "expected" dates).
  static DateTime? matingDateFrom(List<Map<String, dynamic>>? answers) {
    for (final a in answers ?? const <Map<String, dynamic>>[]) {
      if (isMatingQuestion(a['report_question_key']?.toString(), null)) {
        final d = parse(a['answer']?.toString());
        if (d != null) return d;
      }
    }
    return null;
  }
}
