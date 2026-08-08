import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/chat/chat_report_bottom_sheet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/community/terms_and_service.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_chat_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_reply_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_sender_mode.dart';
import 'package:ufc_mobile/models/community_models/rules/community_rules_model.dart';
import 'package:ufc_mobile/screens/community/components/community_terms_ui.dart';
import 'package:ufc_mobile/screens/community/widgets/community_chat_tile.dart';

class CommunityUtils {
  static Future<void> showCustomReportSheet({
    required BuildContext context,
    required String userName,
    required String messageText,
    required final void Function(String? reason) onAction,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ReportMessageBottomSheet(
          username: userName,
          messageText: messageText,
          actionText: "Submit",
          actionButtonColor: primaryPurple,
          onAction: (reason) => onAction(reason),
        );
      },
    );
  }

  static String communityRuleTitle(CommunityRulesModel? rule) {
    if (isArabic) {
      return rule?.titleAr ?? rule?.titleEn ?? rule?.titleUr ?? '';
    } else if (isUrdu) {
      return rule?.titleUr ?? rule?.titleEn ?? rule?.titleAr ?? '';
    } else {
      return rule?.titleEn ?? rule?.titleAr ?? rule?.titleUr ?? '';
    }
  }

  static String communityRuleDescription(CommunityRulesModel? rule) {
    if (isArabic) {
      return rule?.descriptionAr ??
          rule?.descriptionEn ??
          rule?.descriptionUr ??
          '';
    } else if (isUrdu) {
      return rule?.descriptionUr ??
          rule?.descriptionEn ??
          rule?.descriptionAr ??
          '';
    } else {
      return rule?.descriptionEn ??
          rule?.descriptionAr ??
          rule?.descriptionUr ??
          '';
    }
  }

  static String iconsForMessageAction(ChatMessageAction action) {
    switch (action) {
      case ChatMessageAction.reply:
        return AppSvgImages.chatReply;
      case ChatMessageAction.delete:
        return AppSvgImages.chatDelete;
      case ChatMessageAction.report:
        return AppSvgImages.chatReport;
      case ChatMessageAction.edit:
        return AppSvgImages.chatEdit;
    }
  }

  static Color getColorForAvatar(CommunityChatModel? chatItem) {
    String input = parseString(chatItem?.sender?.id ??
            chatItem?.admin?.id ??
            chatItem?.id ??
            '0') ??
        '';
    final hash = input.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);

    final baseColor = Color.fromRGBO(r, g, b, 1.0);

    final aestheticColor = Color.lerp(baseColor, Colors.white, 0.2)!;

    // ignore: deprecated_member_use
    return aestheticColor.withOpacity(.8);
  }

  static String senderName(CommunityChatModel? chat) {
    // Case: Sender user
    if (chat?.senderId != null && chat?.sender != null) {
      final sender = chat!.sender!;

      //  full name
      String uName = senderUserName(sender);
      if (uName.isNotEmpty) {
        return uName.trim();
      }

      // Fallback: Phone number
      final phone = senderPhone(chat.sender);
      if (phone.isNotEmpty) {
        return phone;
      }

      // Fallback: email
      String email = chat.sender?.email?.email ?? '';
      if (email.isNotEmpty) {
        return email;
      }
    }

    // Case: Admin user
    if (chat?.adminId != null && chat?.admin != null) {
      final adminName = chat!.admin?.name?.trim();
      if (adminName != null && adminName.isNotEmpty) {
        return adminName;
      }
      return 'Admin';
    }
    // Fallback
    return 'Unknown';
  }

  static String replyToUserName(ReplyForMessage? reply) {
    if (reply?.sender != null) {
      //  full name
      String uName = senderUserName(reply?.sender);
      if (uName.isNotEmpty) {
        return uName.trim();
      }

      final phone = senderPhone(reply?.sender);
      if (phone.isNotEmpty) {
        return phone;
      }

      String email = reply?.sender?.email?.email ?? '';
      if (email.isNotEmpty) {
        return email;
      }
    }
    // Case: Admin user
    if (reply?.admin != null) {
      final adminName = reply!.admin?.name?.trim() ?? '';
      if (adminName.isNotEmpty) {
        return adminName;
      }
      return 'Admin';
    }
    return 'Unknown';
  }

  static String senderPhone(CommunitySenderModel? sender) {
    String cCode = sender?.phone?.countryCode ?? '';
    String phone = sender?.phone?.phoneNumber ?? '';

    String number = '';
    if (phone.isNotEmpty) {
      number = cCode.isNotEmpty ? '\u200E$cCode $phone' : phone;
    }
    return number;
  }

  static String senderUserName(CommunitySenderModel? sender) {
    //  full name
    String name = (sender?.name ?? '').trim();
    if (name.isNotEmpty) {
      return name;
    }

    // Fallback: Combine middle + last name if available
    final middle = sender?.middleName?.trim();
    final last = sender?.lastName?.trim();
    final combined =
        [middle, last].where((e) => e != null && e.isNotEmpty).join(' ');

    if (combined.isNotEmpty) {
      return combined;
    }
    return '';
  }

  /// Will check whether the user had agreed on terms and condition before
  static Future<void> enterChannel({
    required BuildContext context,
    required String channelId,
    required VoidCallback onNavigate,
  }) async {
    final alreadyAgreed = await CommunityTermsService.hasAgreed(channelId);

    if (!alreadyAgreed) {
      /// if user dont agreed show the bottom sheet
      if (!context.mounted) return;
      final accepted = await showTermsPolicyBottomSheet(context);
      if (accepted) {
        await CommunityTermsService.setAgreed(channelId);
        // if agreed navigate to channel
        onNavigate();
      }
    } else {
      // if already agreed navigate to channel
      onNavigate();
    }
  }

  static Future<bool> showTermsPolicyBottomSheet(BuildContext context) async {
    if (!context.mounted) return false;

    final result = await showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CommunityTermsAndConditionScreen();
          },
        );
      },
    );

    return result ?? false;
  }
}
