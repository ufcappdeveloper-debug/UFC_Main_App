import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_order_model.dart';
import '../../domain/entities/main_source/main_source_params.dart';
import '../../domain/entities/main_source/main_source_payment_models.dart';
import 'package:ufc_mobile/global/util/common/invoice_file.dart';

import '../../domain/repositories/main_source_repo.dart';

enum MainSourceOrderAction { none, cancel, pay, upload, invoice }

enum MainSourceOrderEvent { none, cancelled, uploaded, error }

class MainSourceOrderState extends Equatable {
  final MainSourceOrderModel? order;
  final bool loading;
  final Object? loadError;
  final MainSourceOrderAction busy;

  /// 0..1 while a receipt is uploading.
  final double? uploadProgress;

  final MainSourceOrderEvent event;
  final int eventId;
  final Object? error;

  const MainSourceOrderState({
    this.order,
    this.loading = false,
    this.loadError,
    this.busy = MainSourceOrderAction.none,
    this.uploadProgress,
    this.event = MainSourceOrderEvent.none,
    this.eventId = 0,
    this.error,
  });

  MainSourceOrderState copyWith({
    MainSourceOrderModel? order,
    bool? loading,
    Object? Function()? loadError,
    MainSourceOrderAction? busy,
    double? Function()? uploadProgress,
  }) =>
      MainSourceOrderState(
        order: order ?? this.order,
        loading: loading ?? this.loading,
        loadError: loadError != null ? loadError() : this.loadError,
        busy: busy ?? this.busy,
        uploadProgress:
            uploadProgress != null ? uploadProgress() : this.uploadProgress,
        event: event,
        eventId: eventId,
        error: error,
      );

  MainSourceOrderState withEvent(MainSourceOrderEvent event,
          {Object? error, MainSourceOrderModel? order}) =>
      MainSourceOrderState(
        order: order ?? this.order,
        loading: false,
        loadError: loadError,
        busy: MainSourceOrderAction.none,
        event: event,
        eventId: eventId + 1,
        error: error,
      );

  @override
  List<Object?> get props => [
        order?.id,
        order?.orderStatus,
        order?.paymentStatus,
        order?.canCancel,
        order?.canPay,
        order?.canUploadReceipt,
        order?.bankTransfer?.id,
        order?.bankTransfer?.status,
        order?.bankTransfer?.receiptUrl,
        order?.statusHistory.length,
        loading,
        loadError?.toString(),
        busy,
        uploadProgress,
        eventId,
      ];
}

/// One Main Source order: details, cancel, Mada "Pay now", bank receipt
/// upload (plan §4.5 / §5). Used by the success page and order details.
class MainSourceOrderCubit extends Cubit<MainSourceOrderState> {
  final MainSourceRepository repository;

  MainSourceOrderCubit(this.repository, {MainSourceOrderModel? initial})
      : super(MainSourceOrderState(order: initial));

  int? get _id => state.order?.id;

  Future<void> load(int id, {bool silent = false}) async {
    if (!silent) emit(state.copyWith(loading: true, loadError: () => null));
    try {
      final order = await repository.getOrder(id);
      emit(state.copyWith(order: order, loading: false, loadError: () => null));
    } catch (e) {
      emit(state.copyWith(loading: false, loadError: () => e));
    }
  }

  /// Reload (push received, screen resumed, fresh receipt link).
  Future<void> refresh() async {
    final id = _id;
    if (id != null) await load(id, silent: true);
  }

  /// Downloads the PDF invoice to the app's storage and returns its path,
  /// or `null` after emitting the error.
  Future<String?> downloadInvoice() async {
    final id = _id;
    if (id == null) return null;
    emit(state.copyWith(busy: MainSourceOrderAction.invoice));
    try {
      final path = await InvoiceFile.pathFor(state.order?.orderNumber ?? id);
      await repository.downloadInvoice(id, path);
      emit(state.copyWith(busy: MainSourceOrderAction.none));
      return path;
    } catch (e) {
      emit(state.withEvent(MainSourceOrderEvent.error, error: e));
      return null;
    }
  }

  Future<void> cancel({String? reason}) async {
    final id = _id;
    if (id == null) return;
    emit(state.copyWith(busy: MainSourceOrderAction.cancel));
    try {
      final order = await repository.cancelOrder(id, reason: reason);
      emit(state.withEvent(MainSourceOrderEvent.cancelled, order: order));
    } catch (e) {
      emit(state.withEvent(MainSourceOrderEvent.error, error: e));
      await refresh();
    }
  }

  /// "Pay now" / "Try again" (Mada): a new checkout. Errors are emitted
  /// and `null` is returned.
  Future<MainSourcePayStartResult?> startPayment() async {
    final id = _id;
    if (id == null) return null;
    emit(state.copyWith(busy: MainSourceOrderAction.pay));
    try {
      final result = await repository.payOrder(id);
      emit(state.copyWith(busy: MainSourceOrderAction.none));
      return result;
    } catch (e) {
      emit(state.withEvent(MainSourceOrderEvent.error, error: e));
      await refresh();
      return null;
    }
  }

  /// Result of the Mada widget; the order is reloaded afterwards.
  Future<MainSourcePaymentVerifyResult?> verifyPayment(
      String checkoutId) async {
    emit(state.copyWith(busy: MainSourceOrderAction.pay));
    try {
      final result = await repository.verifyPayment(checkoutId);
      emit(state.copyWith(busy: MainSourceOrderAction.none));
      await refresh();
      return result;
    } catch (e) {
      emit(state.withEvent(MainSourceOrderEvent.error, error: e));
      await refresh();
      return null;
    }
  }

  Future<bool> uploadReceipt(MainSourceBankTransferParams params) async {
    final id = _id;
    if (id == null) return false;
    emit(state.copyWith(
        busy: MainSourceOrderAction.upload, uploadProgress: () => 0));
    try {
      final order = await repository.uploadBankTransfer(id, params,
          onProgress: (sent, total) {
        if (total > 0 && !isClosed) {
          emit(state.copyWith(uploadProgress: () => sent / total));
        }
      });
      emit(state.withEvent(MainSourceOrderEvent.uploaded, order: order));
      return true;
    } catch (e) {
      emit(state.withEvent(MainSourceOrderEvent.error, error: e));
      return false;
    }
  }
}
