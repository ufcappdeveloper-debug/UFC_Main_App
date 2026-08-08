import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/models/common/link_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';

class OrderResponseModel {
  String? message;

  OrderListModel? orders;

  OrderResponseModel({this.message, this.orders});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['status'];

    orders = json['data'] != null ? OrderListModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (orders != null) {
      data['data'] = orders!.toJson();
    }
    return data;
  }
}

class OrderListModel {
  int? currentPage;
  List<OrderModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  OrderListModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    /// products
    if (json['data'] != null) {
      data = <OrderModel>[];
      json['data'].forEach((v) {
        data!.add(OrderModel.fromJson(v));
      });
    }
    currentPage = parseInt(json['current_page']);
    firstPageUrl = parseString(json['first_page_url']);
    from = parseInt(json['from']);
    lastPage = parseInt(json['last_page']);
    lastPageUrl = parseString(json['last_page_url']);
    nextPageUrl = parseString(json['next_page_url']);
    path = parseString(json['path']);
    perPage = parseInt(json['per_page']);
    prevPageUrl = parseString(json['prev_page_url']);
    to = parseInt(json['to']);
    total = parseInt(json['total']);

    ///links
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

