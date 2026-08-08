import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/community_models/rules/community_rules_model.dart';
import 'package:ufc_mobile/riverpod/community/community_rules/community_rules_async_riverpord.dart';
import 'package:ufc_mobile/screens/community/widgets/rule_item.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/shadows.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/community/community_utils.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';

class Rules extends ConsumerStatefulWidget {
  const Rules({super.key});

  @override
  ConsumerState<Rules> createState() => _RulesState();
}

class _RulesState extends ConsumerState<Rules> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(communityRulesRiverpodProvider.notifier).fetchRules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rulesListAsync = ref.watch(communityRulesRiverpodProvider);
    return Scaffold(
      appBar: AppBar(
        leading: navigationIcon(),
        elevation: 0,
        title: CustomText(
          text: 'Read the rules'.tr(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textGrey,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: kall(15),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: ksymmetric(15, 10),
                decoration: BoxDecoration(
                    boxShadow: btmSmContainerShadow,
                    color: Colors.white,
                    borderRadius: boRadius(20)),
                child: RuleItem(
                  text1: '📜 Community Rules'.tr(),
                  text2:
                      'Please read and follow the following rules to maintain a respectful and enjoyable environment for all members.'
                          .tr(),
                ),
              ),
              kHeight15,
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: ksymmetric(15, 25),
                  decoration: BoxDecoration(
                    boxShadow: btmSmContainerShadow,
                    color: Colors.white,
                  ),
                  child: rulesListAsync.when(
                    data: (data) => rulesList(data),
                    error: (error, stack) => errorWidget(),
                    loading: () => loaidngWidget(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rulesList(List<CommunityRulesModel>? rulesList) {
    if ((rulesList ?? []).isEmpty) {
      return Center(child: CustomText(text: 'No rules found'));
    }
    return ListView.builder(
      itemCount: rulesList?.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        CommunityRulesModel? rule = rulesList?[index];
        return Padding(
          padding: konlyb(40),
          child: RuleItem(
            text1: CommunityUtils.communityRuleTitle(rule),
            text2: CommunityUtils.communityRuleDescription(rule),
          ),
        );
      },
    );
  }

  Widget errorWidget() {
    return Column(
      children: [
        CustomReloadProvider(
          height: 118,
          onPressed: () =>
              ref.read(communityRulesRiverpodProvider.notifier).fetchRules(),
        ),
      ],
    );
  }

  Widget loaidngWidget() {
    return const Column(
      children: [
        SizedBox(
          height: 157,
          child: Center(child: CustomIndicator(padding: 50)),
        ),
      ],
    );
  }

  Widget navigationIcon() => GestureDetector(
      onTap: () => pop(context),
      child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20));
}
