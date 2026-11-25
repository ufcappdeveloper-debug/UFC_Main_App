import 'package:ufc_mobile/global/util/common/common_utils.dart';

/// Small parsing helpers shared by the Main Source models.
Map<String, dynamic> asMap(dynamic value) =>
    value is Map<String, dynamic> ? value : const <String, dynamic>{};

Map<String, dynamic>? asMapOrNull(dynamic value) =>
    value is Map<String, dynamic> ? value : null;

List<T> asList<T>(dynamic value, T Function(Map<String, dynamic>) parse) =>
    value is List
        ? value.whereType<Map<String, dynamic>>().map(parse).toList()
        : <T>[];

List<String> asStringList(dynamic value) => value is List
    ? value.map((e) => e?.toString()).whereType<String>().toList()
    : const <String>[];

/// Money and amounts: SAR, 2 decimals; `null` becomes 0.
double money(dynamic value) => parseDouble(value) ?? 0;

DateTime? parseDate(dynamic value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;
