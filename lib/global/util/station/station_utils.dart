import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class StationUtils {
  static String stationName(StationModel? station) {
    if (isArabic) {
      return station?.nameAr ?? station?.nameEn ?? station?.nameUr ?? '';
    } else if (isUrdu) {
      return station?.nameUr ?? station?.nameEn ?? station?.nameAr ?? '';
    } else {
      return station?.nameEn ?? station?.nameAr ?? station?.nameUr ?? '';
    }
  }
}
