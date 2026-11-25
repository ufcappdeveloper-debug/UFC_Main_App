import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/screens/feed/application/main_source/main_source_cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/main_source/main_source_checkout_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/main_source/main_source_order_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/main_source/main_source_products_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_api_exception.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_order_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_payment_models.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_quote_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/distributor/distributor_data_source.dart'
    show Paginated;

import 'fake_main_source_repo.dart';
import 'fixtures.dart';

const _location = MainSourceLocation(latitude: 24.7, longitude: 46.6);

MainSourceQuoteModel _quote(Map<String, Object?> overrides) =>
    MainSourceQuoteModel.fromJson(j({...quoteJson, ...overrides}));

void main() {
  late FakeMainSourceRepository repo;

  setUp(() => repo = FakeMainSourceRepository());

  group('MainSourceProductsCubit', () {
    test('load, filter and load more', () async {
      repo.onGetProducts = (p) async => Paginated(
            items: [MainSourceProductModel.fromJson(j(productJson))],
            currentPage: p.page,
            lastPage: 2,
            total: 2,
          );
      final cubit = MainSourceProductsCubit(repo);
      await cubit.load();
      expect(cubit.state.products, hasLength(1));
      expect(cubit.state.hasMore, isTrue);

      await cubit.loadMore();
      expect(cubit.state.products, hasLength(2));
      expect(cubit.state.params.page, 2);
      expect(cubit.state.hasMore, isFalse);

      await cubit.selectCategory(3);
      expect(cubit.state.params.categoryId, 3);
      expect(cubit.state.params.page, 1);
      expect(cubit.state.products, hasLength(1));
      await cubit.close();
    });

    test('error keeps an empty list', () async {
      repo.onGetProducts = (_) async => throw const MainSourceApiException(
          statusCode: 403, code: 'BUSINESS_MODE_DISABLED', message: 'off');
      final cubit = MainSourceProductsCubit(repo);
      await cubit.load();
      expect(cubit.state.error, isA<MainSourceApiException>());
      expect(cubit.state.loading, isFalse);
      await cubit.close();
    });
  });

  group('MainSourceCartCubit', () {
    final cart = MainSourceCartModel.fromJson(j(cartJson));

    test('add: added event and badge', () async {
      repo.onAddToCart = (_, __, ___) async => cart;
      final cubit = MainSourceCartCubit(repo);
      await cubit.addToCart(21, quantity: 2);
      expect(cubit.state.event, MainSourceCartEvent.added);
      expect(cubit.state.count, 1);
      expect(cubit.state.cart.subtotal, 200);
      await cubit.close();
    });

    test('409 MIXED_MAIN_SOURCE_CART then replace', () async {
      repo.onAddToCart = (variant, qty, replace) async {
        if (!replace) {
          throw MainSourceApiException(
              statusCode: 409,
              code: MainSourceErrorCode.mixedCart,
              message: 'mixed',
              data: j({'cart_main_source': sourceRef}));
        }
        return cart;
      };
      final cubit = MainSourceCartCubit(repo);
      await cubit.addToCart(21, quantity: 2);
      expect(cubit.state.event, MainSourceCartEvent.conflict);
      expect(cubit.state.apiError?.cartMainSource?.id, 1);
      await cubit.confirmReplaceCart();
      expect(repo.calls.last, 'addToCart:21:2:true');
      expect(cubit.state.event, MainSourceCartEvent.added);
      await cubit.close();
    });

    test('OUT_OF_STOCK on update: error event, cart reloaded', () async {
      repo.onUpdateCartItem = (_, __) async => throw MainSourceApiException(
          statusCode: 422,
          code: MainSourceErrorCode.outOfStock,
          message: 'Only 10 left in stock',
          data: j({'available_quantity': 10}));
      repo.onGetCart = () async => cart;
      final cubit = MainSourceCartCubit(repo);
      await cubit.setQuantity(27, 50);
      expect(repo.calls, ['updateCartItem:27:50', 'getCart']);
      expect(cubit.state.updatingItemIds, isEmpty);
      await cubit.close();
    });
  });

  group('MainSourceCheckoutCubit', () {
    MainSourceCheckoutCubit build({MainSourceBuyNow? buyNow}) =>
        MainSourceCheckoutCubit(repo,
            buyNow: buyNow, debounce: const Duration(milliseconds: 1));

    test('place order stays disabled until there is a location', () async {
      repo.onQuote = (_) async => _quote({});
      final cubit = build();
      await cubit.start();
      cubit.setPaymentMethod('CASH');
      await cubit.refreshQuote();
      expect(cubit.state.canPlaceOrder, isFalse);
      cubit.setLocation(_location);
      await cubit.refreshQuote();
      expect(cubit.state.canPlaceOrder, isTrue);
      await cubit.close();
    });

    test('quote drops choices the server no longer allows', () async {
      repo.onQuote = (_) async => _quote({
            'payment_methods': ['CASH'],
            'wallet_balance': 0,
            'payable_amount': 30,
            'sadad_min_amount': 50,
          });
      final cubit = build();
      cubit.setUseWallet(true);
      cubit.setPaymentMethod('SADAD');
      await cubit.refreshQuote();
      expect(cubit.state.useWallet, isFalse);
      expect(cubit.state.paymentMethod, isNull);
      await cubit.close();
    });

    test('wallet covering the total sends WALLET', () async {
      MainSourceCheckoutParams? sent;
      repo.onQuote = (_) async => _quote({
            'wallet_balance': 500,
            'wallet_applied': 253,
            'payable_amount': 0,
          });
      repo.onPlaceOrder = (p) async {
        sent = p;
        return MainSourcePlaceOrderResult.fromJson(
            j({'order': orderJson, 'payment': {'method': 'WALLET'}}));
      };
      final cubit = build();
      cubit.setLocation(_location);
      cubit.setUseWallet(true);
      await cubit.refreshQuote();
      expect(cubit.state.walletPaysAll, isTrue);
      await cubit.placeOrder();
      expect(sent?.paymentMethod, 'WALLET');
      expect(sent?.useWallet, isTrue);
      expect(cubit.state.event, MainSourceCheckoutEvent.placed);
      await cubit.close();
    });

    test('invalid coupon: error under the field and quote without it',
        () async {
      var calls = 0;
      repo.onQuote = (p) async {
        calls++;
        if (p.couponCode != null) {
          throw MainSourceApiException(
              statusCode: 422,
              code: MainSourceErrorCode.invalidCoupon,
              message: 'bad',
              data: j({'field': 'coupon_code'}));
        }
        return _quote({});
      };
      final cubit = build();
      cubit.applyCoupon('BAD');
      await cubit.refreshQuote();
      expect(cubit.state.couponCode, isNull);
      expect(cubit.state.couponError, MainSourceErrorCode.invalidCoupon);
      expect(cubit.state.quote, isNotNull);
      expect(calls, 2);
      await cubit.close();
    });

    test('OUT_OF_STOCK with items, then force', () async {
      repo.onQuote = (_) async => _quote({});
      repo.onPlaceOrder = (p) async {
        if (!p.force) {
          throw MainSourceApiException(
              statusCode: 422,
              code: MainSourceErrorCode.outOfStock,
              message: 'x',
              data: j({
                'items': [
                  {
                    'cart_item_id': 32,
                    'variant_id': 21,
                    'product_name': 'Barley',
                    'requested_quantity': 5,
                    'available_quantity': 3,
                    'reason': 'out_of_stock'
                  }
                ]
              }));
        }
        return MainSourcePlaceOrderResult.fromJson(
            j({'order': orderJson, 'payment': {'method': 'CASH'}}));
      };
      final cubit = build();
      cubit.setLocation(_location);
      cubit.setPaymentMethod('CASH');
      await cubit.refreshQuote();
      await cubit.placeOrder();
      expect(cubit.state.event, MainSourceCheckoutEvent.stockIssue);
      expect(cubit.state.stockIssues.single.availableQuantity, 3);
      await cubit.placeOrder(force: true);
      expect(repo.calls.where((c) => c.startsWith('placeOrder')),
          ['placeOrder:false', 'placeOrder:true']);
      expect(cubit.state.event, MainSourceCheckoutEvent.placed);
      await cubit.close();
    });

    test('no location: LOCATION_REQUIRED without calling the API', () async {
      repo.onQuote = (_) async => _quote({});
      final cubit = build();
      cubit.setPaymentMethod('CASH');
      await cubit.refreshQuote();
      await cubit.placeOrder();
      expect(cubit.state.event, MainSourceCheckoutEvent.error);
      expect((cubit.state.error as MainSourceApiException).code,
          MainSourceErrorCode.locationRequired);
      expect(repo.calls.where((c) => c.startsWith('placeOrder')), isEmpty);
      await cubit.close();
    });
  });

  group('MainSourceOrderCubit', () {
    final order = MainSourceOrderModel.fromJson(j(orderJson));

    test('cancel emits the updated order', () async {
      repo.onCancel = (id, reason) async => MainSourceOrderModel.fromJson(j({
            ...orderJson,
            'order_status': 'CANCELLED',
            'can_cancel': false,
          }));
      final cubit = MainSourceOrderCubit(repo, initial: order);
      await cubit.cancel(reason: 'Changed my mind');
      expect(cubit.state.event, MainSourceOrderEvent.cancelled);
      expect(cubit.state.order?.orderStatus, 'CANCELLED');
      expect(cubit.state.order?.canCancel, isFalse);
      await cubit.close();
    });

    test('ORDER_NOT_CANCELLABLE: error and reload', () async {
      repo.onCancel = (_, __) async => throw const MainSourceApiException(
          statusCode: 422,
          code: MainSourceErrorCode.orderNotCancellable,
          message: 'no');
      repo.onGetOrder = (_) async => order;
      final cubit = MainSourceOrderCubit(repo, initial: order);
      await cubit.cancel();
      expect(cubit.state.event, MainSourceOrderEvent.error);
      expect(repo.calls, ['cancelOrder:105', 'getOrder:105']);
      await cubit.close();
    });

    test('receipt upload: progress then PENDING_VERIFICATION', () async {
      repo.onUploadBankTransfer = (_, __) async =>
          MainSourceOrderModel.fromJson(j(uploadedOrderJson));
      final cubit = MainSourceOrderCubit(repo,
          initial: MainSourceOrderModel.fromJson(j({
            ...uploadedOrderJson,
            'payment_status': 'PENDING',
            'bank_transfer': null,
            'can_upload_receipt': true,
          })));
      final progress = <double?>[];
      final sub = cubit.stream.listen((s) => progress.add(s.uploadProgress));
      final ok = await cubit.uploadReceipt(const MainSourceBankTransferParams(
          bankAccountId: 34, filePath: '/tmp/r.jpg', amount: 138));
      await Future<void>.delayed(Duration.zero);
      expect(ok, isTrue);
      expect(progress, contains(.5));
      expect(cubit.state.order?.paymentStatus, 'PENDING_VERIFICATION');
      expect(cubit.state.order?.canUploadReceipt, isFalse);
      expect(cubit.state.event, MainSourceOrderEvent.uploaded);
      await sub.cancel();
      await cubit.close();
    });

    test('Mada verify reloads the order', () async {
      repo.onVerify = (_) async => const MainSourcePaymentVerifyResult(
          paymentStatus: 'PAID', orderId: 105);
      repo.onGetOrder = (_) async => MainSourceOrderModel.fromJson(
          j({...orderJson, 'payment_method': 'MADA', 'payment_status': 'PAID'}));
      final cubit = MainSourceOrderCubit(repo, initial: order);
      final result = await cubit.verifyPayment('8AC7A4A1');
      expect(result?.isPaid, isTrue);
      expect(cubit.state.order?.isPaid, isTrue);
      await cubit.close();
    });
  });
}
