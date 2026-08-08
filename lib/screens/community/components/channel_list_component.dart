import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/community/community_utils.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/models/community_models/channel_model/datum.dart';
import 'package:ufc_mobile/riverpod/community/channel_riverpod.dart';
import 'package:ufc_mobile/screens/community/pages/community_chat_screen.dart';
import 'package:ufc_mobile/screens/community/pages/community_page.dart';
import 'package:ufc_mobile/screens/community/widgets/community_list_tile.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';

class CommunityChannelList extends ConsumerStatefulWidget {
  const CommunityChannelList({
    super.key,
  });

  @override
  ConsumerState<CommunityChannelList> createState() =>
      _CommunityChannelListState();
}

class _CommunityChannelListState extends ConsumerState<CommunityChannelList> {
  bool termsAndConditionAgreed = false;
  @override
  Widget build(BuildContext context) {
    final channelDataAsync = ref.watch(channelRiverpodProvider);
    return channelDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (channelList) {
          if ((channelList?.data ?? []).isEmpty) {
            return Center(
              child: Padding(
                padding: konlyt(100),
                child: CustomText(
                  text: 'No Channels Found',
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: konlyb(15),
            itemCount: channelList?.data!.length,
            itemBuilder: (context, index) {
              final channel = channelList?.data![index];
              if (channel == null) {
                return SizedBox.shrink();
              }
              return InkWell(
                onTap: () async {
                  CommunityUtils.enterChannel(
                    context: context,
                    channelId: parseString(channel.id) ?? '',
                    onNavigate: () {
                      onTapOfCommunityChannel(channel);
                    },
                  );

                  // /// check the user agreed for terms and condition
                  // bool agreed =
                  //     await CommunityUtils.showTermsPolicyBottomSheet(context);
                  // if (agreed) {
                  //   onTapOfCommunityChannel(channel);
                  // }
                },
                child: CustomCommunityTile(
                  title: title(context, channel),
                  subTitle: subTitle(context, channel),
                  image: channel.icon,
                ),
              );
            },
          );
        });
  }

  /// on tap of community channel
  void onTapOfCommunityChannel(ChannelModel channel) async {
    ref.read(isInHomeProvider.notifier).state = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isInHome = ref.read(isInHomeProvider);
      context.read<AppBarHeightCubit>().setHeight(isInHome ? 74 : 31);
      context
          .read<AppBarCubit>()
          .setMode(isInHome ? AppBarMode.normal : AppBarMode.channel);
      context.read<BottomNavIndexCubit>().update(farm: isInHome);
    });

    if (channel.id != null) {
      await push(
        context,
        CommunityChatScreen(
          channelId: channel.id!,
          channelName: isArabic ? channel.nameAr : channel.nameEn,
          channelDesc: isArabic ? channel.descriptionAr : channel.descriptionEn,
          channelIcon: channel.icon,
          channel: channel,
        ),
      );
    }
    ref.read(isInHomeProvider.notifier).state = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isInHome = ref.read(isInHomeProvider);
      context.read<AppBarHeightCubit>().setHeight(isInHome ? 74 : 31);
      context
          .read<AppBarCubit>()
          .setMode(isInHome ? AppBarMode.normal : AppBarMode.channel);
      context.read<BottomNavIndexCubit>().update(farm: isInHome);
    });
  }

  String title(BuildContext context, ChannelModel channel) {
    return isArOrUr
        ? channel.nameAr ?? channel.nameEn ?? 'Unknown'
        : channel.nameEn ?? channel.nameAr ?? 'Unknown';
  }

  String subTitle(BuildContext context, ChannelModel channel) {
    return isArOrUr
        ? channel.descriptionAr ?? channel.descriptionEn ?? ''
        : channel.descriptionEn ?? channel.descriptionAr ?? '';
  }
}
