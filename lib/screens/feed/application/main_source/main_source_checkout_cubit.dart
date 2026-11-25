import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_api_exception.dart';
import '../../domain/entities/main_source/main_source_model.dart';
import '../../domain/entities/main_source/main_source_params.dart';
import '../../domain/entities/main_source/main_source_payment_models.dart';
import '../../domain/entities/main_source/main_source_quote_model.dart';
import '../../domain/repositories/main_source_repo.dart';

enum MainSourceCheckoutEvent { none, placed, stockIssue, error }

class MainSourceCheckoutState extends Equatable {
  final MainSourceBuyNow? buyNow;
  final MainSourceLocation? location;
  final bool locating;
  final bool useWallet;
  final String? paymentMethod;
  final String? couponCode;
  final String? couponError;
  final String note;
  final MainSourceQuoteModel? quote;
  final bool quoting;
  final Object? quoteError;
  final bool placing;

  /// One-shot outcome of place order. [eventId] changes on each one.
  final MainSourceCheckoutEvent event;
  final int eventId;
  final MainSourcePlaceOrderResult? result;
  final Object? error;
  final List<MainSourceStockIssue> stockIssues;

  const MainSourceCheckoutState({
    this.buyNow,
    this.location,
    this.locating = false,
    this.useWallet = false,
    this.paymentMethod,
    this.couponCode,
    this.couponError,
    this.note = '',
    this.quote,
    this.quoting = false,
    this.quoteError,
    this.placing = false,
    this.event = MainSourceCheckoutEvent.none,
    this.eventId = 0,
    this.result,
    this.error,
    this.stockIssues = const [],
  });

  /// The wallet pays everything: no other method is needed.
  bool get walletPaysAll =>
      useWallet && quote != null && quote!.payableAmount <= 0;

  /// The method sent to place order.
  String? get effectivePaymentMethod =>
      walletPaysAll ? MainSourcePaymentMethod.wallet : paymentMethod;

  /// "Place order" stays disabled until there is a location (plan §4.2),
  /// a quote and a payment method.
  bool get canPlaceOrder =>
      location != null &&
      quote != null &&
      !quoting &&
      !placing &&
      effectivePaymentMethod != null;

  MainSourceCheckoutState copyWith({
    MainSourceLocation? location,
    bool? locating,
    bool? useWallet,
    String? Function()? paymentMethod,
    String? Function()? couponCode,
    String? Function()? couponError,
    String? note,
    MainSourceQuoteModel? quote,
    bool? quoting,
    Object? Function()? quoteError,
    bool? placing,
  }) =>
      MainSourceCheckoutState(
        buyNow: buyNow,
        location: location ?? this.location,
        locating: locating ?? this.locating,
        useWallet: useWallet ?? this.useWallet,
        paymentMethod:
            paymentMethod != null ? paymentMethod() : this.paymentMethod,
        couponCode: couponCode != null ? couponCode() : this.couponCode,
        couponError: couponError != null ? couponError() : this.couponError,
        note: note ?? this.note,
        quote: quote ?? this.quote,
        quoting: quoting ?? this.quoting,
        quoteError: quoteError != null ? quoteError() : this.quoteError,
        placing: placing ?? this.placing,
        event: event,
        eventId: eventId,
        result: result,
        error: error,
        stockIssues: stockIssues,
      );

  MainSourceCheckoutState withEvent(
    MainSourceCheckoutEvent event, {
    MainSourcePlaceOrderResult? result,
    Object? error,
    List<MainSourceStockIssue> stockIssues = const [],
  }) =>
      MainSourceCheckoutState(
        buyNow: buyNow,
        location: location,
        locating: locating,
        useWallet: useWallet,
        paymentMethod: paymentMethod,
        couponCode: couponCode,
        couponError: couponError,
        note: note,
        quote: quote,
        quoting: quoting,
        quoteError: quoteError,
        placing: false,
        event: event,
        eventId: eventId + 1,
        result: result,
        error: error,
        stockIssues: stockIssues,
      );

  @override
  List<Object?> get props => [
        location,
        locating,
        useWallet,
        paymentMethod,
        couponCode,
        couponError,
        note,
        quote?.totalWithVat,
        quote?.payableAmount,
        quote?.walletApplied,
        quote?.paymentMethods.join(','),
        quote?.items.length,
        quoting,
        quoteError?.toString(),
        placing,
        eventId,
      ];
}

/// Main Source checkout (plan §4): location, quote (debounced on every
/// change), wallet checkbox, payment method, coupon and place order.
class MainSourceCheckoutCubit extends Cubit<MainSourceCheckoutState> {
  final MainSourceRepository repository;
  final Duration debounce;
  Timer? _timer;
  int _request = 0;

  MainSourceCheckoutCubit(
    this.repository, {
    MainSourceBuyNow? buyNow,
    this.debounce = const Duration(milliseconds: 400),
  }) : super(MainSourceCheckoutState(buyNow: buyNow));

  MainSourceCheckoutParams _params({bool force = false}) =>
      MainSourceCheckoutParams(
        location: state.location,
        useWallet: state.useWallet,
        paymentMethod: state.effectivePaymentMethod,
        couponCode: state.couponCode,
        buyNow: state.buyNow,
        note: state.note,
        force: force,
      );

  /// Quote right away (checkout opened).
  Future<void> start() => _quote();

  void _scheduleQuote() {
    _timer?.cancel();
    emit(state.copyWith(quoting: true));
    _timer = Timer(debounce, _quote);
  }

  Future<void> refreshQuote() => _quote();

  Future<void> _quote() async {
    _timer?.cancel();
    final id = ++_request;
    emit(state.copyWith(quoting: true));
    try {
      final quote = await repository.quote(_params());
      if (id != _request || isClosed) return;
      emit(_normalize(state.copyWith(
          quote: quote, quoting: false, quoteError: () => null)));
    } on MainSourceApiException catch (e) {
      if (id != _request || isClosed) return;
      if (e.code == MainSourceErrorCode.invalidCoupon &&
          state.couponCode != null) {
        // Show the error under the field and quote again without it.
        emit(state.copyWith(
            couponCode: () => null,
            couponError: () => e.code,
            quoting: false));
        await _quote();
        return;
      }
      emit(state.copyWith(quoting: false, quoteError: () => e));
    } catch (e) {
      if (id != _request || isClosed) return;
      emit(state.copyWith(quoting: false, quoteError: () => e));
    }
  }

  /// Drops choices the new quote no longer allows (plan §4.3).
  MainSourceCheckoutState _normalize(MainSourceCheckoutState s) {
    final q = s.quote;
    if (q == null) return s;
    var next = s;
    if (next.useWallet && !q.canUseWallet) {
      next = next.copyWith(useWallet: false);
    }
    final method = next.paymentMethod;
    final invalid = method != null &&
        (!q.offers(method) ||
            (method == MainSourcePaymentMethod.wallet && !q.walletCoversTotal) ||
            (method == MainSourcePaymentMethod.sadad && !q.sadadAllowed));
    if (invalid) next = next.copyWith(paymentMethod: () => null);
    return next;
  }

  void setLocating(bool value) => emit(state.copyWith(locating: value));

  void setLocation(MainSourceLocation location) {
    emit(state.copyWith(location: location, locating: false));
    _scheduleQuote();
  }

  void setUseWallet(bool value) {
    var next = state.copyWith(useWallet: value);
    // Unchecking the wallet drops WALLET as the main method.
    if (!value && next.paymentMethod == MainSourcePaymentMethod.wallet) {
      next = next.copyWith(paymentMethod: () => null);
    }
    emit(next);
    _scheduleQuote();
  }

  void setPaymentMethod(String? method) {
    emit(state.copyWith(paymentMethod: () => method));
    _scheduleQuote();
  }

  void applyCoupon(String? code) {
    final value = code?.trim();
    emit(state.copyWith(
      couponCode: () => value == null || value.isEmpty ? null : value,
      couponError: () => null,
    ));
    _scheduleQuote();
  }

  void setNote(String note) => emit(state.copyWith(note: note));

  /// [force]: skip out-of-stock cart lines (after the user agreed).
  Future<void> placeOrder({bool force = false}) async {
    if (state.location == null) {
      emit(state.withEvent(MainSourceCheckoutEvent.error,
          error: const MainSourceApiException(
              code: MainSourceErrorCode.locationRequired,
              message: 'Choose the delivery location on the map.')));
      return;
    }
    if (state.effectivePaymentMethod == null || state.placing) return;
    _timer?.cancel();
    emit(state.copyWith(placing: true));
    try {
      final result = await repository.placeOrder(_params(force: force));
      emit(state.withEvent(MainSourceCheckoutEvent.placed, result: result));
    } on MainSourceApiException catch (e) {
      switch (e.code) {
        case MainSourceErrorCode.outOfStock when e.stockIssues.isNotEmpty:
          emit(state.withEvent(MainSourceCheckoutEvent.stockIssue,
              error: e, stockIssues: e.stockIssues));
        case MainSourceErrorCode.paymentMethodDisabled:
          // Ask the user to pick again from the fresh list.
          emit(state
              .copyWith(paymentMethod: () => null)
              .withEvent(MainSourceCheckoutEvent.error, error: e));
          await _quote();
        case MainSourceErrorCode.invalidCoupon:
          emit(state
              .copyWith(couponCode: () => null, couponError: () => e.code)
              .withEvent(MainSourceCheckoutEvent.error, error: e));
          await _quote();
        default:
          emit(state.withEvent(MainSourceCheckoutEvent.error, error: e));
      }
    } catch (e) {
      emit(state.withEvent(MainSourceCheckoutEvent.error, error: e));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
