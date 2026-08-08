import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/init/address_injection.dart';
import 'package:ufc_mobile/global/shared/init/app_setting_injection.dart';
import 'package:ufc_mobile/global/shared/init/barn_injection.dart';
import 'package:ufc_mobile/global/shared/init/coupon_injection.dart';
import 'package:ufc_mobile/global/shared/init/delivery_cost_injection.dart';
import 'package:ufc_mobile/global/shared/init/farm_dashboard_injection.dart';
import 'package:ufc_mobile/global/shared/init/favorite_injection.dart';
import 'package:ufc_mobile/global/shared/init/feed_my_orders_injection.dart';
import 'package:ufc_mobile/global/shared/init/livestock_details_injection.dart';
import 'package:ufc_mobile/global/shared/init/payment_injection.dart';
import 'package:ufc_mobile/global/shared/init/product_injtion.dart';
import 'package:ufc_mobile/global/shared/init/rating_injection.dart';
import 'package:ufc_mobile/global/shared/init/register_livestock_core.dart';
import 'package:ufc_mobile/global/shared/init/sadad_injection.dart';
import 'package:ufc_mobile/global/shared/init/station_injection.dart';
import 'package:ufc_mobile/global/shared/init/wallet_injection.dart';

import 'auth_injection.dart';
import 'cart_injection.dart';
import 'category_injection.dart';
import 'contact_injection.dart';
import 'death_injection.dart';
import 'mothers_babies_injection.dart';
import 'notification_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register modules
  registerProductModule();
  registerAuthModule();
  registerBarnModule();
  registerStationModule();
  registerAddressModule();
  registerFarmDashboard();
  registerOrderModule();
  registerCategoryModule();
  registerNotificationModule();
  registerWalletModule();
  registerLiveStockCore();
  registerLiveStockDetails();
  registerSupportModule();
  // registerLivestockList();
  registerDeathModule();
  registerCartModule();
  registerProductRatingModule();
  registerAppSettingModule();
  registerSadadModule();
  registerPaymentModule();
  registerDeliveryCostModule();
  registerCouponModule();
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  registerMothersBabiesModule();
  registerFavoriteModule();
}
