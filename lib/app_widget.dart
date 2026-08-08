import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_in_app_pip/pip_material_app.dart';
import 'package:flutter_in_app_pip/pip_params.dart';
import 'package:flutter_in_app_pip/pip_view_corner.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/route_tracker.dart';
import 'package:ufc_mobile/global/shared/init/product_injtion.dart';
import 'package:ufc_mobile/global/shared/theme/app_theme.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/application/dashbaord/dashboard_cubit.dart';
import 'package:ufc_mobile/screens/farm/application/livestock_details/livestock_details_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/address/address_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/category/category_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/contact/contact_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/coupon/coupon_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/delivery_cost/delivery_cost_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/notification/notification_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/filter_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/product_rating/rating_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/station/station_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/wallet/wallet_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/contact_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/add_review_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/address_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/my_orders_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/notification_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/order_details_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_rating_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/station_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/update_station_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/wallet_usecase.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed_old/onboarding/select_language_screen.dart';
import 'package:ufc_mobile/screens/navigation/utils/bottom_nav_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/calling_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';

import 'screens/farm/application/death/death_cubit.dart';
import 'screens/farm/application/get_question/get_question_cubit.dart';
import 'screens/farm/application/mothers_babies/mothers_babies_cubit.dart';
import 'screens/feed/application/authentication/auth_cubit.dart';
import 'screens/landing_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AppBarCubit()),
            BlocProvider(create: (_) => AppBarHeightCubit()),
            BlocProvider(create: (_) => BottomBarVisibilityCubit()),
            BlocProvider(create: (_) => BottomNavIndexCubit()),
            BlocProvider(create: (_) => SelectedAppbarItemCubit()),
            BlocProvider(create: (_) => FeedBottomNavCubit()),
            BlocProvider(create: (_) => FeedBackgroundCubit()),
            BlocProvider(create: (_) => FilterCubit()),
            BlocProvider(
              create: (_) => sl<ProductListCubit>()..getProducts(),
            ),
            BlocProvider(
              create: (_) => sl<CartCubit>()..fetchCartCount(),
            ),

            BlocProvider(create: (_) => sl<AuthCubit>()),
            BlocProvider(
              create: (_) => sl<BarnDetailsCubit>(),
            ),
            BlocProvider(create: (_) => FeedBottomNavCubit()),
            BlocProvider(
                create: (_) => MyOrdersCubit(
                    GetMyOrdersUseCase(sl()), GetOrderDetailsUseCase(sl()))),
            BlocProvider<StationCubit>(
              create: (_) => StationCubit(
                GetStationsUseCase(sl()),
                UpdatePreferredShopUseCase(sl()),
              ),
            ),

            BlocProvider<NotificationCubit>(
              create: (_) => NotificationCubit(
                GetUserNotificationsUseCase(sl()),
              ),
            ),

            BlocProvider<ProductRatingCubit>(
              create: (_) => ProductRatingCubit(
                GetProductRatingsUseCase(sl()),
                AddProductRatingUseCase(sl()),
              ),
            ),

            BlocProvider<AddressCubit>(
              create: (_) => AddressCubit(
                sl<GetAddressesUseCase>(),
                sl<DeleteAddressUseCase>(),
                sl<UpdateAddressUseCase>(),
                sl<SetDefaultAddressUseCase>(),
                sl<CreateAddressUseCase>(),
                sl<GetDefaultAddressUseCase>(),
                // ✅ added here
              ),
            ),

            BlocProvider<CategoryCubit>(
              create: (_) => sl<CategoryCubit>()..fetchCategories(),
            ),

            BlocProvider<WalletCubit>(
                create: (_) => WalletCubit(
                      GetWalletTransactionsUseCase(sl()),
                    )),

            BlocProvider(
              create: (_) => sl<FarmDashboardCubit>(),
            ),
            BlocProvider<SupportCubit>(
              create: (_) => SupportCubit(sl<SupportRepository>()),
            ),

            BlocProvider(
              create: (_) => sl<LiveStockDetailsCubit>(),
            ),

            // BlocProvider(
            //   create: (_) => sl<LivestockListByCategoryCubit>(),
            // ),
            BlocProvider(
              create: (_) => sl<DeathCubit>(),
            ),

            BlocProvider(
              create: (_) => sl<AppSettingCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<SadadUserInfoCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<PaymentCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<CouponCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<DeliveryCostCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<GetQuestionCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<LanguageCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<MothersBabiesCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<FavoriteCubit>(),
            ),
          ],
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: PiPMaterialApp(
                  navigatorKey: Constants.navigatorKey,
                  pipParams: PiPParams(
                    topSpace: 55,
                    movable: true,
                    pipWindowWidth: 100,
                    pipWindowHeight: 150,
                    bottomSpace: 11 + kNavBarHeight,
                    initialCorner: PIPViewCorner.bottomRight,
                  ),
                  navigatorObservers: [RouteTracker(), Constants.routeObserver],
                  locale: locale,
                  localeResolutionCallback: (locale, supportedLocales) {
                    final norm =
                        CommonUtils.normalizeLocale(locale?.toString());
                    return supportedLocales.firstWhere(
                      (l) => l.languageCode == norm,
                      orElse: () => const Locale('en'),
                    );
                  },
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.mainThemeData(false),
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates
                    ..add(GlobalCupertinoLocalizations.delegate),
                  onGenerateRoute: (settings) {
                    if (settings.name == '/calling') {
                      final args = settings.arguments as Map<String, dynamic>;
                      return MaterialPageRoute(
                        builder: (_) => CallingScreen(
                          token: args['token'],
                          channelName: args['channelName'],
                          uid: args['uid'],
                          doctor: args['doctor'],
                          appointment: args['appointment'],
                          senderID: args['senderID'],
                        ),
                      );
                    }
                    if (settings.name == '/chat') {
                      final args = settings.arguments as Map<String, dynamic>;
                      return MaterialPageRoute(
                        builder: (_) => ChatScreen2(
                          doctor: args['doctor'],
                          appointment: args['appointment'],
                          roomId: args['roomId'],
                          senderId: args['senderId'],
                          receiverId: args['receiverId'],
                          userId: args['userId'],
                          bookingId: args['bookingId'],
                        ),
                      );
                    }

                    Uri? uri = settings.name != null
                        ? Uri.tryParse(settings.name!)
                        : null;
                    if (uri != null && uri.path == '/usage-policy') {
                      BottomNavUtils.isTermsConditions = true;
                    }
                    if (uri != null && uri.path == '/privacy-and-policy') {
                      BottomNavUtils.isPrivacyPolicy = true;
                    }
                    return null;
                  },
                  builder: EasyLoading.init(),
                  home: Scaffold(
                    body: Center(
                      child:
                          showOnBoard ? SelectLanguageScreen() : LandingPage(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
