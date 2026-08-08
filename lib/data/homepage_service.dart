import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/models/home_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class HomePageService {
  Future<HomeModel> getHomePage(final page, final limit) async {
    List<ProductModel> topOfTheWeek = [];
    List<BannerModel> bigBanners = [];
    List<BannerModel> smolBanners = [];
    Response response =
        await api.get("api/ufc/v1/home_page?page=$page&limit=$limit");

    List topProducts = response.data['top_of_week']['products'];
    for (var item in topProducts) {
      topOfTheWeek.add(ProductModel.fromJson(item));
    }
    List banners = response.data['banner_big']['data']['data'];
    for (var item in banners) {
      bigBanners.add(BannerModel.fromJson(item));
    }
    List smallBanners = response.data['banner_mini']['data']['data'];
    for (var item in smallBanners) {
      smolBanners.add(BannerModel.fromJson(item));
    }

    return HomeModel(
      topOfWeek: topOfTheWeek,
      bannerBig: bigBanners,
      bannerMini: smolBanners,
    );
  }
}
