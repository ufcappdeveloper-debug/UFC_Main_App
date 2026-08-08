import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../global/shared/widgets/custom_indicator.dart';
import '../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../riverpod/farm/report_categories_async.dart';
import 'report_questions_page.dart';

class AddReportPage extends ConsumerStatefulWidget {
  const AddReportPage({super.key});

  @override
  ConsumerState<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends ConsumerState<AddReportPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await ref
        .read(reportCategoriesAsyncProvider.notifier)
        .getReportCategories();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future(() => _onRefresh());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportCategoriesAsync = ref.watch(reportCategoriesAsyncProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            text: 'Add Report',
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: reportCategoriesAsync.when(
          data: (data) {
            return SmartRefresher(
              enablePullUp: false,
              enablePullDown: true,
              onRefresh: _onRefresh,
              controller: _refreshController,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => data?[index].id != null
                    ? buildOptionTile(data?[index].localizedName(context) ?? '',
                        data![index].id!, data[index].isAnimalRequired)
                    : SizedBox(),
                itemCount: data?.length ?? 0,
              ),
            );
          },
          error: (error, stack) => isNetworkError(error.toString())
              ? NoInternet(
                  type: AppType.farm,
                  onTap: () => _onRefresh(),
                )
              : CustomReloadProvider(
                  height: 118,
                  onPressed: () => _onRefresh(),
                ),
          loading: () => const SizedBox(
            height: 157,
            child: Center(child: CustomIndicator(padding: 50)),
          ),
        ));
  }

  Widget buildOptionTile(String title, int id, int? isAnimalRequired) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [customBoxShadow]),
      child: ListTile(
        title: CustomText(
            text: title,
            fontSize: 15,
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontWeight: FontWeight.w400),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReportQuestionsPage(
                isAnimalRequired: isAnimalRequired, title: title, id: id),
          ),
        ),
      ),
    );
  }
}
