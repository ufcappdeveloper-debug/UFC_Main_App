import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

import 'main_source_json.dart';
import 'main_source_model.dart';

/// `GET /app/business-config` (plan §1).
class BusinessConfigModel extends Equatable {
  static const modeMainSource = 'main_source';
  static const modeMarketplace = 'marketplace';

  final String mode;
  final bool mainSourceEnabled;
  final bool stationsEnabled;
  final bool distributorsEnabled;
  final List<MainSourceModel> mainSources;

  const BusinessConfigModel({
    this.mode = modeMarketplace,
    this.mainSourceEnabled = false,
    this.stationsEnabled = true,
    this.distributorsEnabled = true,
    this.mainSources = const [],
  });

  /// No network and nothing cached: marketplace with both cards (the
  /// backend defaults).
  static const defaults = BusinessConfigModel();

  factory BusinessConfigModel.fromJson(Map<String, dynamic> json) =>
      BusinessConfigModel(
        mode: parseString(json['mode']) ?? modeMarketplace,
        mainSourceEnabled: parseBool(json['main_source_enabled']) ?? false,
        stationsEnabled: parseBool(json['stations_enabled']) ?? false,
        distributorsEnabled: parseBool(json['distributors_enabled']) ?? false,
        mainSources: asList(json['main_sources'], MainSourceModel.fromJson),
      );

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'main_source_enabled': mainSourceEnabled,
        'stations_enabled': stationsEnabled,
        'distributors_enabled': distributorsEnabled,
        'main_sources': mainSources.map((e) => e.toJson()).toList(),
      };

  bool get isMainSource => mode == modeMainSource || mainSourceEnabled;

  @override
  List<Object?> get props => [
        mode,
        mainSourceEnabled,
        stationsEnabled,
        distributorsEnabled,
        mainSources.map((e) => '${e.id}:${e.paymentMethods.join('|')}').join(),
      ];
}
