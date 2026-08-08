import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/notification/notification_util.dart';

import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../application/notification/notification_cubit.dart';
import '../../../application/notification/notification_state.dart';

class FeedNotificationScreen extends StatefulWidget {
  const FeedNotificationScreen({super.key});

  @override
  State<FeedNotificationScreen> createState() => _FeedNotificationScreenState();
}

class _FeedNotificationScreenState extends State<FeedNotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('ur', timeago.UrMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    context.read<NotificationCubit>().fetchNotifications();

    _scrollController.addListener(() {
      final cubit = context.read<NotificationCubit>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !cubit.isLoadingMore &&
          !cubit.isLastPage) {
        Future.microtask(() => cubit.fetchNotifications());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Notifications',
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading && state is! NotificationLoaded) {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return Center(
                  child: CustomText(
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                text: "No Notifications Found",
                fontSize: 16,
              ));
            }

            return RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<NotificationCubit>();
                cubit.resetNotifications();
                await cubit.fetchNotifications();
              },
              child: Builder(
                builder: (context) {
                  final cubit = context.read<NotificationCubit>();

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    // ✅ Use cubit here safely
                    itemCount:
                        notifications.length + (cubit.isLastPage ? 0 : 1),

                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // ✅ cubit is already available
                      if (!cubit.isLastPage && index == notifications.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.green),
                          ),
                        );
                      }

                      final n = notifications[index];
                      final isUnread = n.readAt == null;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 0,
                            leading: isUnread
                                ? Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    height: 12,
                                    width: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            60, 179, 110, 1),
                                        width: 3,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            title: Text(
                              NotificationUtil.notificationName(n),
                              style: TextStyle(
                                fontFamily: isEnglish
                                    ? AppFontsFamily.english
                                    : AppFontsFamily.arabic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              NotificationUtil.notificationDescription(n),
                              style: TextStyle(
                                fontFamily: isEnglish
                                    ? AppFontsFamily.english
                                    : AppFontsFamily.arabic,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: CustomText(
                                text: n.createdAt != null
                                    ? timeago.format(n.createdAt!,
                                        locale: isArabic
                                            ? 'ar'
                                            : isUrdu
                                                ? 'ur'
                                                : 'en')
                                    : "",
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is NotificationError) {
            return isNetworkError(state.message)
                ? NoInternet(
                    type: AppType.feed,
                    onTap: () =>
                        context.read<NotificationCubit>().fetchNotifications(),
                  )
                : Center(
                    child: CustomReloadProviderV2(
                      error: state.message,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        context.read<NotificationCubit>().fetchNotifications();
                      },
                    ),
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
