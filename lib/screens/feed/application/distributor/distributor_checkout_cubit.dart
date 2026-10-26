import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/distributor/checkout_options_model.dart';
import '../../domain/entities/distributor/checkout_summary_model.dart';
import '../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../domain/entities/distributor/distributor_product_model.dart';
import '../../domain/entities/distributor/distributor_query_params.dart';
import '../../domain/repositories/distributor_repo.dart';

/// The product bought with "Order Now" (direct buy, no cart).
class DirectBuyItem {
  final DistributorProductModel product;
  final int variantId;
  final int quantity;

  const DirectBuyItem({
    required this.product,
    required this.variantId,
    required this.quantity,
  });

  double get itemsTotal => product.price * quantity;
}

class DistributorCheckoutState extends Equatable {
  final CheckoutOptionsModel? options;
  final DistributorCheckoutSummary? summary;
  final String? orderType;
  final String? paymentMethod;
  final String? couponCode;
  final bool loadingOptions;
  final bool loadingSummary;
  final bool placing;
  final String? error;

  /// Server message for the coupon field (summary or place_order).
  final String? couponMessage;

  /// Set when place_order succeeded.
  final DistributorPlaceOrderResult? result;

  /// Set when place_order failed with a stock problem the user must resolve.
  final DistributorApiException? stockError;
  final int eventId;

  const DistributorCheckoutState({
    this.options,
    this.summary,
    this.orderType,
    this.paymentMethod,
    this.couponCode,
    this.loadingOptions = false,
    this.loadingSummary = false,
    this.placing = false,
    this.error,
    this.couponMessage,
    this.result,
    this.stockError,
    this.eventId = 0,
  });

  OrderTypeOption? get selectedOrderType => options?.orderType(orderType);
  PaymentMethodOption? get selectedPayment =>
      options?.paymentMethod(paymentMethod);
  bool get isOpen => options?.isOpen ?? true;
  bool get isDelivery => orderType == DistributorOrderType.delivery;
  List<int> get outOfStockVariantIds => summary?.outOfStockVariantIds ?? [];

  bool get canPlaceOrder =>
      isOpen &&
      !placing &&
      selectedOrderType != null &&
      selectedPayment != null &&
      outOfStockVariantIds.isEmpty;

  DistributorCheckoutState copyWith({
    CheckoutOptionsModel? options,
    DistributorCheckoutSummary? summary,
    String? orderType,
    String? paymentMethod,
    String? couponCode,
    bool clearCoupon = false,
    bool? loadingOptions,
    bool? loadingSummary,
    bool? placing,
    String? error,
    String? couponMessage,
    DistributorPlaceOrderResult? result,
    DistributorApiException? stockError,
    bool bumpEvent = false,
  }) =>
      DistributorCheckoutState(
        options: options ?? this.options,
        summary: summary ?? this.summary,
        orderType: orderType ?? this.orderType,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        couponCode: clearCoupon ? null : (couponCode ?? this.couponCode),
        loadingOptions: loadingOptions ?? this.loadingOptions,
        loadingSummary: loadingSummary ?? this.loadingSummary,
        placing: placing ?? this.placing,
        error: error,
        couponMessage: couponMessage,
        result: result,
        stockError: stockError,
        eventId: bumpEvent ? eventId + 1 : eventId,
      );

  @override
  List<Object?> get props => [
        options?.orderTypes.length,
        options?.paymentMethods.length,
        options?.isOpen,
        summary?.totalWithVat,
        summary?.outOfStockVariantIds,
        orderType,
        paymentMethod,
        couponCode,
        loadingOptions,
        loadingSummary,
        placing,
        error,
        couponMessage,
        result,
        eventId,
      ];
}

/// Distributor checkout: order types / payment methods come from the API
/// (`checkout_options`), totals from `checkout_summary`.
class DistributorCheckoutCubit extends Cubit<DistributorCheckoutState> {
  final DistributorRepository repository;
  late int _distributorId;
  Timer? _debounce;

  /// Set for "Order Now": the order goes to `buy_product` and there is no
  /// checkout_summary (it only works on the cart), so totals are estimated
  /// on the device.
  DirectBuyItem? direct;

  DistributorCheckoutCubit(this.repository)
      : super(const DistributorCheckoutState());

  Future<void> start(int distributorId, {DirectBuyItem? direct}) async {
    _distributorId = distributorId;
    this.direct = direct;
    emit(const DistributorCheckoutState(loadingOptions: true));
    await _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final options = await repository.getCheckoutOptions(_distributorId);
      emit(state.copyWith(
        options: options,
        loadingOptions: false,
        orderType: _keepOrDefault(
            state.orderType, options.orderTypes.map((e) => e.code)),
        paymentMethod: _keepOrDefault(
            state.paymentMethod, options.paymentMethods.map((e) => e.code)),
      ));
      await refreshSummary();
    } catch (e) {
      emit(state.copyWith(loadingOptions: false, error: e.toString()));
    }
  }

  /// Keeps the current choice if still offered; preselects when only one.
  String? _keepOrDefault(String? current, Iterable<String?> codes) {
    final list = codes.whereType<String>().toList();
    if (current != null && list.contains(current)) return current;
    return list.length == 1 ? list.first : null;
  }

  void selectOrderType(String code) {
    emit(state.copyWith(orderType: code));
    _scheduleSummary();
  }

  void selectPaymentMethod(String code) =>
      emit(state.copyWith(paymentMethod: code));

  void applyCoupon(String? code) {
    final trimmed = code?.trim();
    emit(state.copyWith(
        couponCode: trimmed, clearCoupon: trimmed == null || trimmed.isEmpty));
    _scheduleSummary();
  }

  void _scheduleSummary() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), refreshSummary);
  }

  Future<void> refreshSummary() async {
    if (direct != null) {
      // Coupons are checked by buy_product itself.
      emit(state.copyWith(couponMessage: null));
      return;
    }
    final orderType = state.orderType ?? state.options?.orderTypes.firstOrNull?.code;
    if (orderType == null) return;
    emit(state.copyWith(loadingSummary: true));
    try {
      final summary = await repository.getCheckoutSummary(
          orderType: orderType, couponCode: state.couponCode);
      emit(state.copyWith(
        summary: summary,
        loadingSummary: false,
        couponMessage: summary.messages['coupon_code'],
      ));
      // The chosen type was switched off meanwhile: reload the options.
      if (summary.messages['order_type'] != null) {
        emit(state.copyWith(options: summary.checkoutOptions ?? state.options));
        await _loadOptions();
      }
    } catch (e) {
      emit(state.copyWith(loadingSummary: false, error: e.toString()));
    }
  }

  Future<void> placeOrder({
    int? addressId,
    String? note,
    String? bookingDateTime,
    String? driverPlate,
    bool force = false,
  }) async {
    if (!state.canPlaceOrder && !force) return;
    emit(state.copyWith(placing: true));
    final params = DistributorPlaceOrderParams(
      paymentMethod: state.paymentMethod!,
      orderType: state.orderType!,
      distributorId: _distributorId,
      addressId: state.isDelivery ? addressId : null,
      couponCode: state.couponCode,
      note: note,
      bookingDateTime: bookingDateTime,
      driverPlate: state.isDelivery ? null : driverPlate,
      force: force,
    );
    try {
      final item = direct;
      final result = item == null
          ? await repository.placeOrder(params)
          : await repository.buyProduct(DistributorBuyProductParams(
              productId: item.product.id!,
              variantId: item.variantId,
              quantity: item.quantity,
              order: params,
            ));
      emit(state.copyWith(placing: false, result: result, bumpEvent: true));
    } on DistributorApiException catch (e) {
      // Cart stock problems offer "skip / lower quantity"; for a direct buy
      // the message ("Only N left in stock...") is enough.
      if (direct == null && (e.isStockLimit || e.isOutOfStockVariant)) {
        emit(state.copyWith(placing: false, stockError: e, bumpEvent: true));
      } else if (e.isCouponError) {
        emit(state.copyWith(
            placing: false, couponMessage: e.message, bumpEvent: true));
      } else {
        emit(state.copyWith(placing: false, error: e.message, bumpEvent: true));
        if (e.needsOptionsRefresh) await _loadOptions();
      }
    } catch (e) {
      emit(state.copyWith(
          placing: false, error: e.toString(), bumpEvent: true));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
