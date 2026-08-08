import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class CategoryCustomTabBar extends StatelessWidget {
  const CategoryCustomTabBar(
      {super.key, required this.categoryData, required this.onNotification});
  final List<CategoryModel> categoryData;
  final bool Function(ScrollNotification)? onNotification;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: SizedBox(
        height: 53,
        child: NotificationListener<ScrollNotification>(
          onNotification: onNotification,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: primaryColor.withValues(alpha: 0.23),
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              isScrollable: true,
              indicatorWeight: 1,
              indicatorColor: primaryColor,
              padding: const EdgeInsets.all(0),
              labelColor: const Color(0xFF000000),
              physics: const BouncingScrollPhysics(),
              unselectedLabelColor: const Color(0xFFA8A8A8),
              labelPadding: const EdgeInsets.symmetric(horizontal: 14.5),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
              tabs: categoryData.map(
                (data) {
                  debugPrint(
                      "Category Name: ${data.nameEn} nameAr ${data.nameAr}  nameUr${data.nameUr}");
                  return Tab(
                    text: tabName(data, context),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String tabName(CategoryModel data, BuildContext context) {
    String? nameEn =
        (data.nameEn != null && data.nameEn != 'null') ? data.nameEn : null;
    String? nameAr =
        (data.nameAr != null && data.nameAr != 'null') ? data.nameAr : null;
    String? nameUr =
        (data.nameUr != null && data.nameUr != 'null') ? data.nameUr : null;

    String? name;
    if (isArabic) {
      name = nameAr ?? nameEn ?? nameUr ?? '';
    } else if (isUrdu) {
      name = nameUr ?? nameEn ?? nameAr ?? '';
    } else {
      name = nameEn ?? nameAr ?? nameUr ?? '';
    }

    return name;
  }
}
