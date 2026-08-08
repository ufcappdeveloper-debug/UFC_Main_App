import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/data/communication_preference_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/communication_preference/communication_preference_provider.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_appbar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import '../config/firebase_notification.dart';
import '../../main.dart';
import '../../models/communication_preferences_model.dart';
import '../util/dio/dio_utils.dart';
import '../util/exception/app_exception.dart';

class CommunicationPreferenceScreen extends ConsumerStatefulWidget {
  const CommunicationPreferenceScreen({super.key});

  @override
  ConsumerState<CommunicationPreferenceScreen> createState() =>
      _CommunicationPreferenceScreenState();
}

class _CommunicationPreferenceScreenState
    extends ConsumerState<CommunicationPreferenceScreen>
    with ScreenEngagementTracker {
  UserModel? userModel;
  @override
  void initState() {
    userModel = ref.read(authProvider).asData?.value;
    final preferenceObject = CommunicationPreferencesModel(
      pushNotifAll: userModel?.pushNotifAll,
      pushNotifAccountOrders: userModel?.pushNotifAccountOrders,
      pushNotifOffersPromotion: userModel?.pushNotifOffersPromotion,
      emailNotifAll: userModel?.emailNotifAll,
      emailNotifOfferProducts: userModel?.emailNotifOfferProducts,
      smsNotifAccountOrders: userModel?.smsNotifAccountOrders,
    );
    Future(() => ref
        .read(communicationPreferenceProvider.notifier)
        .initPreferenceObject(preferenceObject));

    super.initState();
  }

  Future<void> updateFirebaseNotificationService(bool onChanged) async {
    await preferences.setBool('init_fcm', onChanged);
    if (onChanged) {
      await FirebaseNotification().initMessaging();
    } else {
      await FirebaseNotification().removeToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comm = ref.watch(communicationPreferenceProvider);
    return WillPopScope(
      onWillPop: () async {
        try {
          final future =
              CommunicationPreferenceService().updatePreference(comm.toJson);

          final updatedUserModel = await LoadingDialog.show(context, future);

          if (userModel?.pushNotifAll != comm.pushNotifAll) {
            if (!context.mounted) return false;
            await LoadingDialog.show(
              context,
              updateFirebaseNotificationService(comm.pushNotifAll!),
            );
          }

          ref.read(authProvider.notifier).updatePreferences(updatedUserModel);
        } on DioException catch (dioError) {
          try {
            DioUtils.handleDioError(dioError);
          } on CustomException catch (custom) {
            debugPrint('Custom Exception: ${custom.message}');
            if (!context.mounted) return false;

            CustomSnackBar.error(context, 'connection_error'.tr());
          }
        } catch (e) {
          if (!context.mounted) return false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('something_wrong'.tr())),
          );
        }

        return true;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'Communication Preferences',
        ),
        body: ListView(
          children: [
            PreferencesCard(
              title: "Push notification",
              children: [
                StatefulSwitchListTile(
                  title: "Enable All notifications",
                  enabled: userModel?.pushNotifAll ?? false,
                  preferenceType: PreferenceType.pushNotificationAll,
                ),
                StatefulSwitchListTile(
                  title: "Account &Orders",
                  subtitle:
                      "Receive push notification about your order and account related information",
                  enabled: userModel?.pushNotifAccountOrders ?? false,
                  preferenceType: PreferenceType.pushNotificationAccountOrders,
                ),
                StatefulSwitchListTile(
                  title: "Offers &Promotion",
                  subtitle:
                      "Receive push notification about your order and account related information",
                  enabled: userModel?.pushNotifOffersPromotion ?? false,
                  preferenceType:
                      PreferenceType.pushNotificationOffersPromotion,
                ),
              ],
            ),
            PreferencesCard(
              title: "Email",
              children: [
                StatefulSwitchListTile(
                  title: "Enable All notifications",
                  enabled: userModel?.emailNotifAll ?? false,
                  preferenceType: PreferenceType.emailNotificationAll,
                ),
                StatefulSwitchListTile(
                  title: "Exclusive offers and product recommended",
                  enabled: userModel?.emailNotifOfferProducts ?? false,
                  preferenceType: PreferenceType.emailNotificationOfferProducts,
                ),
              ],
            ),
            PreferencesCard(
              title: "SMS",
              children: [
                StatefulSwitchListTile(
                  title: "Account &Orders",
                  subtitle:
                      "Receive SMS notification about your order and account related information",
                  enabled: userModel?.smsNotifAccountOrders ?? false,
                  preferenceType: PreferenceType.smsNotificationAccountOrders,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PreferencesCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PreferencesCard(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        shadowColor: Colors.black45,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: CustomText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
            ...children
          ],
        ),
      ),
    );
  }
}

class StatefulSwitchListTile extends ConsumerStatefulWidget {
  final String title;
  final String? subtitle;
  final bool enabled;
  final PreferenceType preferenceType;

  const StatefulSwitchListTile(
      {super.key,
      required this.title,
      required this.preferenceType,
      this.subtitle,
      this.enabled = false});

  @override
  ConsumerState<StatefulSwitchListTile> createState() =>
      _StatefulSwitchListTileState();
}

class _StatefulSwitchListTileState
    extends ConsumerState<StatefulSwitchListTile> {
  late bool enabled;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: enabled,
      onChanged: (onChanged) async {
        ref
            .read(communicationPreferenceProvider)
            .updateCommunicationPreferences(onChanged, widget.preferenceType);
        setState(() {
          enabled = onChanged;
        });
      },
      thumbColor: WidgetStateColor.resolveWith(
        (states) => Colors.white,
      ),
      activeColor: primaryColor,
      title: CustomText(
        text: widget.title,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      subtitle: CustomText(
        text: widget.subtitle ?? '',
        fontSize: 11,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
