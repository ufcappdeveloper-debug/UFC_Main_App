import 'package:ufc_mobile/global/shared/init/injection.dart';

import '../../domain/entities/livestock/livestock_reports_model.dart';
import '../../domain/services/farm_date_rules.dart';
import '../../domain/usecase/livestock_details_usecase.dart';
import '../../domain/usecase/livestock_reports_usecase.dart';
import '../livestock_details/livestock_details_cubit.dart';

/// Loads the dates the date rules need for an animal (and its mother).
class AnimalDatesLoader {
  AnimalDatesLoader._();

  static final Map<String, AnimalDates> _cache = {};

  /// Dates from an already loaded livestock details page.
  static AnimalDates? fromState(LiveStockDetailsState state) {
    if (state is! LiveStockDetailsLoaded) return null;
    return AnimalDates.from(state.liveStockDetails, state.livestockReportModel);
  }

  /// Fetches the animal's details and records. With [withMother], the
  /// mother's birth/death are added (for birth-date rules).
  static Future<AnimalDates?> load(String? animalKey,
      {bool withMother = false, bool refresh = false}) async {
    if (animalKey == null || animalKey.isEmpty) return null;
    if (!refresh && _cache.containsKey(animalKey) && !withMother) {
      return _cache[animalKey];
    }
    try {
      final details = await sl<GetLiveStockDetailsUseCase>()(animalKey);
      ReportResponse? reports;
      try {
        reports = await sl<GetLiveSTockReportUseCase>()(animalKey);
      } catch (_) {
        // Records are optional for the rules.
      }
      var dates = AnimalDates.from(details.data, reports);
      _cache[animalKey] = dates;
      if (withMother) {
        final motherKey =
            details.data?.predefinedAnimalDetails?.firstOrNull?.animalMother;
        if (motherKey != null &&
            motherKey.isNotEmpty &&
            motherKey != animalKey) {
          dates = dates.withMother(await load(motherKey));
        }
      }
      return dates;
    } catch (_) {
      // Offline or unknown animal: the API still validates on save.
      return null;
    }
  }

  static void invalidate(String? animalKey) => _cache.remove(animalKey);
}
