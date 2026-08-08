import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/product/pages/product_details_page.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/tab_bar_product_details_container.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';

class ProductDetailsTabBarSection extends StatefulWidget {
  const ProductDetailsTabBarSection(
      {super.key, required this.length, required this.productData});
  final int length;
  final ProductModel productData;

  @override
  State<ProductDetailsTabBarSection> createState() =>
      _ProductDetailsTabBarSectionState();
}

class _ProductDetailsTabBarSectionState
    extends State<ProductDetailsTabBarSection> with TickerProviderStateMixin {
  bool expand = false;
  bool allowExpand = false;
  late TabController _tabController;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: widget.length, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.0),
              border: const Border(
                  bottom: BorderSide(color: Color(0xffDFDFDF), width: 1)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                  splashColor: primaryColor.withValues(alpha: 0.23),
                  highlightColor: Colors.transparent),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: primaryColor,
                indicatorWeight: 1,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                onTap: (index) {
                  if (_tabController.index == 1) {
                    allowExpand = true;
                  } else {
                    expand = false;
                    allowExpand = false;
                  }
                  setState(() {});
                },
                tabs: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Tab(
                        icon: CustomText(
                      text: 'Product Details'.tr(),
                      fontSize: MediaQuery.of(context).size.width * 0.035, // 15
                    )),
                  ),
                  if (_tabController.length == 2)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                      ),
                      child: Tab(
                          icon: CustomText(
                        text: 'Product Description'.tr(),
                        fontSize:
                            MediaQuery.of(context).size.width * 0.035, // 15
                      )),
                    ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            height: expand
                ? constraints.maxWidth > 500
                    ? 131
                    : 151
                : 77,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TabBarProductDetailsContainer(tabDetailsData: tabDetailsData),
                if (_tabController.length == 2)
                  ListView(
                    controller: controller,
                    physics: expand
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: CustomText(
                          text: ProductUtils.productDescription(
                            widget.productData,
                          )??"",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (allowExpand)
            InkWell(
              onTap: () {
                expand = !expand;
                if (!expand) {
                  controller.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
                setState(() {});
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: !expand ? 'See more' : 'See less',
                  color: primaryColor,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          const Divider(
            color: Color(0xffDFDFDF),
            thickness: 1,
            height: 30,
          ),
        ],
      );
    });
  }
}
