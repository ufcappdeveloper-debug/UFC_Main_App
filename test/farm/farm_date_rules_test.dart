import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/report_category.dart';
import 'package:ufc_mobile/screens/farm/domain/services/camel_age.dart';
import 'package:ufc_mobile/screens/farm/domain/services/farm_date_rules.dart';

/// Logical farm date rules (mobile_integration_guide.md, C1). No network.
void main() {
  final birth = DateTime(2026, 3, 1);
  final death = DateTime(2026, 9, 1);
  final animal = AnimalDates(
    birth: birth,
    records: [DateTime(2026, 4, 1), DateTime(2026, 8, 15)],
    vaccinations: [(vaccineTypeId: 7, date: DateTime(2026, 5, 1), id: 50)],
  );
  final dead = AnimalDates(birth: birth, death: death);
  final tomorrow = FarmDateRules.today().add(const Duration(days: 1));

  group('records (weight, medicine, disease, vaccine...)', () {
    test('not in the future', () {
      expect(FarmDateRules.validate(FarmDateKind.event, tomorrow, animal),
          isNotNull);
    });
    test('not before birth, not after death', () {
      expect(
          FarmDateRules.validate(
              FarmDateKind.event, DateTime(2026, 2, 28), animal),
          isNotNull);
      expect(
          FarmDateRules.validate(FarmDateKind.event, DateTime(2026, 9, 2), dead),
          isNotNull);
      expect(
          FarmDateRules.validate(FarmDateKind.event, DateTime(2026, 6, 1), dead),
          isNull);
    });
    test('the same vaccine twice on one day is refused', () {
      expect(
          FarmDateRules.validate(
              FarmDateKind.vaccination, DateTime(2026, 5, 1), animal,
              vaccineTypeId: 7),
          isNotNull);
      // Editing that same vaccination keeps its date.
      expect(
          FarmDateRules.validate(
              FarmDateKind.vaccination, DateTime(2026, 5, 1), animal,
              vaccineTypeId: 7, editingVaccinationId: 50),
          isNull);
      // Another vaccine on that day is fine.
      expect(
          FarmDateRules.validate(
              FarmDateKind.vaccination, DateTime(2026, 5, 1), animal,
              vaccineTypeId: 8),
          isNull);
    });
  });

  test('death not before the latest record', () {
    expect(
        FarmDateRules.validate(FarmDateKind.death, DateTime(2026, 8, 1), animal),
        isNotNull);
    expect(
        FarmDateRules.validate(
            FarmDateKind.death, DateTime(2026, 8, 20), animal),
        isNull);
  });

  test("birth not after the first record and within the mother's life", () {
    final child = AnimalDates(
      records: [DateTime(2026, 6, 1)],
      motherBirth: DateTime(2024, 1, 1),
      motherDeath: DateTime(2026, 7, 1),
    );
    expect(FarmDateRules.validate(FarmDateKind.birth, DateTime(2026, 6, 2), child),
        isNotNull);
    expect(FarmDateRules.validate(FarmDateKind.birth, DateTime(2023, 12, 1), child),
        isNotNull);
    expect(FarmDateRules.validate(FarmDateKind.birth, DateTime(2026, 5, 1), child),
        isNull);
  });

  test('newborn birth date within the mother (selected animal) life', () {
    expect(
        FarmDateRules.validate(
            FarmDateKind.newbornBirth, DateTime(2026, 2, 1), dead),
        isNotNull);
    expect(
        FarmDateRules.validate(
            FarmDateKind.newbornBirth, DateTime(2026, 9, 5), dead),
        isNotNull);
  });

  test('expected dates may be future but not before mating', () {
    final mating = DateTime(2026, 6, 1);
    expect(
        FarmDateRules.validate(FarmDateKind.expected, tomorrow, animal,
            matingDate: mating),
        isNull);
    expect(
        FarmDateRules.validate(
            FarmDateKind.expected, DateTime(2026, 5, 1), animal,
            matingDate: mating),
        isNotNull);
  });

  test('picker range for a record on a dead animal is birth..death', () {
    final r = FarmDateRules.range(FarmDateKind.event, dead);
    expect(r.min, birth);
    expect(r.max, death);
  });

  test('withdrawal period must be >= 0', () {
    expect(FarmDateRules.validateWithdrawal('-1'), isNotNull);
    expect(FarmDateRules.validateWithdrawal('0'), isNull);
    expect(FarmDateRules.validateWithdrawal('14'), isNull);
  });

  test('question classification', () {
    ReportQuestion q(String key, String text) =>
        ReportQuestion(key: key, questionText: text);
    expect(FarmDateRules.kindOf(q('expected_calving_date', 'Expected Calving Date')),
        FarmDateKind.expected);
    expect(FarmDateRules.kindOf(q('birth_date', 'Birth Date')),
        FarmDateKind.birth);
    expect(
        FarmDateRules.kindOf(q('birth_date', 'Birth Date'),
            isNewBornReport: true),
        FarmDateKind.newbornBirth);
    expect(FarmDateRules.kindOf(q('weight_date', 'Weight date')),
        FarmDateKind.event);
  });

  test('parse accepts yyyy-MM-dd and dd/MM/yyyy only', () {
    expect(FarmDateRules.parse('2026-10-01 00:00:00'), DateTime(2026, 10, 1));
    expect(FarmDateRules.parse('01/10/2026'), DateTime(2026, 10, 1));
    expect(FarmDateRules.parse('45'), isNull);
    expect(FarmDateRules.parse('20261001'), isNull);
  });

  group('camel age names (English locale)', () {
    final birth = DateTime(2020, 1, 15);
    String? at(int y, int m, int d) =>
        CamelAge.nameFor(birth, at: DateTime(y, m, d));
    test('stages by completed months', () {
      expect(at(2020, 6, 1), 'Hawar');
      expect(at(2021, 1, 15), 'Mafrood');
      expect(at(2022, 1, 14), 'Mafrood');
      expect(at(2022, 1, 15), 'Hiq');
      expect(at(2023, 2, 1), 'Laqi');
      expect(at(2024, 3, 1), "Jitha'");
      expect(at(2025, 3, 1), 'Thani');
      expect(at(2026, 3, 1), "Raba'");
      expect(at(2030, 1, 1), 'Sudais');
    });
    test('camel detection and missing dates', () {
      expect(CamelAge.isCamel('إبل (ساحلية)'), isTrue);
      expect(CamelAge.isCamel('Camel'), isTrue);
      expect(CamelAge.isCamel('ضأن (سواكني)'), isFalse);
      expect(CamelAge.nameFor(null), isNull);
    });
  });
}
