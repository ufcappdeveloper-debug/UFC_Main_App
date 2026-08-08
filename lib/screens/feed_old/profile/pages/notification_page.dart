import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ufc_mobile/data/notification_service.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/auth/un_authorized_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/notification_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/notification/notification_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';

import '../widgets/notification_list.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage>
    with SingleTickerProviderStateMixin, ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;

  List<String> categories = ["All messages"];
  late TabController controller;
  final PageController _pageController = PageController();
  int selectedIndex = 0;
  int previousIndex = 0;
  bool isAuthorized = false;
  bool categoryLoading = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('ur', timeago.UrMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    Future.microtask(_init);
  }

  Future<void> _init() async {
    isAuthorized = ref.read(authProvider.notifier).isAuthorized();

    if (isAuthorized) {
      getCategories();
      Future(() =>
          ref.read(notificationAsyncProvider.notifier).getNotifications());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedBottomSheet(context);
      });
    }
  }

  Future<void> getCategories() async {
    try {
      categoryLoading = true;
      setState(() {});
      final List<String> response =
          await NotificationService().getNotificationCategories();
      categories.addAll(response);

      controller = TabController(length: categories.length, vsync: this);
    } finally {
      categoryLoading = false;
      controller = TabController(length: categories.length, vsync: this);

      setState(() {});
    }
  }

  void _showUnauthorizedBottomSheet(BuildContext context) {
    showUnauthorizedBottomSheet(
      context,
      onSignInPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isAuthorized = ref.watch(authProvider.notifier).isAuthorized();
    final notificationProvider = ref.watch(notificationAsyncProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonBackAppBar(
        title: "Notification",
        onLeadingTap: () => Navigator.pop(context),
      ),
      body: !isAuthorized
          ? UnAuthorizedWidget()
          : categoryLoading
              ? const SizedBox(
                  height: 157,
                  child: Center(child: CustomIndicator(padding: 50)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      isScrollable: true,
                      controller: controller,
                      indicatorColor: Colors.transparent,
                      physics: const BouncingScrollPhysics(),
                      labelPadding: const EdgeInsetsDirectional.only(start: 12),
                      tabs: categories.map((data) {
                        final index = categories.indexOf(data);
                        return Tab(
                          child: InkWell(
                            onTap: () {
                              previousIndex = selectedIndex = index;
                              ref
                                  .read(notificationAsyncProvider.notifier)
                                  .getNotifications(
                                      category: previousIndex == 0
                                          ? null
                                          : data.toLowerCase());

                              _pageController.jumpToPage(
                                previousIndex,
                              );
                            },
                            child: Container(
                              height: 30,
                              // width: 121,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: selectedIndex == index
                                        ? primaryColor
                                        : primaryGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (index != 0)
                                      Icon(Icons.sell,
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : primaryGrey,
                                          size: 15),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    CustomText(
                                      text: data.replaceAll("_", " "),
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : primaryGrey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                    if (index == 0)
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : primaryGrey,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Expanded(
                        child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        controller.index = page;
                        ref
                            .read(notificationAsyncProvider.notifier)
                            .getNotifications(
                                category: page == 0 ? null : categories[page]);
                        selectedIndex = page;
                        setState(() {});
                      },
                      children: List.generate(categories.length, (index) {
                        return notificationProvider.when(
                          data: (data) {
                            return (data == null || data.isEmpty)
                                ? const CustomNoData(
                                    height: 56,
                                    text: "No Notifications Found",
                                  )
                                : NotificationList(
                                    data: data,
                                    category: categories[selectedIndex],
                                  );
                          },
                          error: (error, stack) => CustomReloadProvider(
                            height: 118,
                            onPressed: () => ref
                                .read(notificationAsyncProvider.notifier)
                                .getNotifications(),
                          ),
                          loading: () => const SizedBox(
                            height: 157,
                            child: Center(child: CustomIndicator(padding: 50)),
                          ),
                        );
                      }),
                    )),
                  ],
                ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Icon(Icons.notifications, color: primaryColor, size: 29),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: (notification.category ?? "DEALS").tr(),
                      color: primaryColor,
                      fontSize: 14,
                    ),
                    CustomText(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      text: getTranslatedNotification(
                          context, notification.title),
                    ),
                    CustomText(
                      fontSize: 13,
                      text: 'order_status_updated'.tr(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomText(
                  text: () {
                    final rawText = timeago.format(
                      notification.createdAt as DateTime,
                      locale: LanguageManager.locale,
                    );

                    if (isArabic) {
                      return convertToArabicNumbers(rawText);
                    }

                    return rawText;
                  }(),
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  String getTranslatedNotification(BuildContext context, String? text) {
    final normalizedText = text?.trim();

    switch (normalizedText) {
      case "Your order status has been updated to SHIPPED":
        return isEnglish
            ? "Your order status has been updated to SHIPPED"
            : "تم تحديث حالة طلبك إلى تم الشحن";

      case "Your order status has been updated to CANCELLED":
        return isEnglish
            ? "Your order status has been updated to CANCELLED"
            : "تم تحديث حالة طلبك إلى تم الإلغاء";

      case "Your order status has been updated to COMPLETED":
        return isEnglish
            ? "Your order status has been updated to COMPLETED"
            : "تم تحديث حالة طلبك إلى مكتمل";

      case "Your order status has been updated to PENDING":
        return isEnglish
            ? "Your order status has been updated to PENDING"
            : "تم تحديث حالة طلبك إلى قيد الانتظار";

      default:
        return normalizedText ?? "";
    }
  }

  String convertToArabicNumbers(String input) {
    const westernToArabic = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };

    return input.split('').map((char) {
      return westernToArabic[char] ?? char;
    }).join();
  }
}
