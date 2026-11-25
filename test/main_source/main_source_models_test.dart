import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_api_exception.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_order_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_payment_models.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_quote_model.dart';

import 'fixtures.dart';

/// Parsing of the plan's JSON examples (no network).
void main() {
  group('catalogue', () {
    test('home: sources, categories, latest products', () {
      final home = MainSourceHomeModel.fromJson(j(homeJson));
      expect(home.mainSources.single.deliveryFee, 20);
      expect(home.mainSources.single.paymentMethods, contains('SADAD'));
      expect(home.categories.single.productsCount, 1);
      expect(home.categories.single.nameAr, 'أعلاف');
      expect(home.latestProducts.single.id, 12);
    });

    test('product with variants', () {
      final p = MainSourceProductModel.fromJson(j(productJson));
      expect(p.mainSource?.id, 1);
      expect(p.category?.id, 3);
      expect(p.inStock, isTrue);
      expect(p.minPrice, 100);
      expect(p.hasPriceRange, isFalse);
      final v = p.variants.single;
      expect(v.id, 21);
      expect(v.size, '40 KG');
      expect(v.hasDiscount, isTrue);
      expect(v.stock, 10);
      expect(p.defaultVariant?.id, 21);
      expect(p.gallery, hasLength(1));
    });

    test('variant without discount or stock', () {
      final v = MainSourceVariantModel.fromJson(
          {'id': 1, 'price': 100, 'original_price': 90, 'is_available': false});
      expect(v.hasDiscount, isFalse);
      expect(v.isAvailable, isFalse);
    });

    test('product query', () {
      const p = MainSourceProductParams(
          categoryId: 3, search: ' barley ', sort: 'price_asc', inStockOnly: true);
      expect(p.toQuery(), {
        'category_id': 3,
        'search': 'barley',
        'in_stock': 1,
        'sort': 'price_asc',
        'page': 1,
        'limit': 20,
      });
      expect(p.copyWith(categoryId: () => null).toQuery()['category_id'],
          isNull);
    });
  });

  group('cart', () {
    test('cart', () {
      final c = MainSourceCartModel.fromJson(j(cartJson));
      expect(c.mainSource?.id, 1);
      expect(c.items.single.id, 27);
      expect(c.items.single.variantId, 21);
      expect(c.items.single.hasDiscount, isTrue);
      expect(c.itemsCount, 1);
      expect(c.quantity, 2);
      expect(c.subtotal, 200);
      expect(c.hasUnavailableItems, isFalse);
    });

    test('empty cart has no source', () {
      final c = MainSourceCartModel.fromJson(
          {'main_source': null, 'items': [], 'items_count': 0, 'subtotal': 0});
      expect(c.isEmpty, isTrue);
      expect(c.mainSource, isNull);
    });

    test('count', () {
      final c = MainSourceCartCount.fromJson({'items': 1, 'quantity': 4});
      expect(c.items, 1);
      expect(c.quantity, 4);
    });
  });

  group('checkout', () {
    test('quote and display rules', () {
      final q = MainSourceQuoteModel.fromJson(j(quoteJson));
      expect(q.totalWithVat, 253);
      expect(q.walletApplied, 50);
      expect(q.payableAmount, 203);
      expect(q.vatPercentage, 15);
      expect(q.items.single.cartItemId, 29);
      expect(q.canUseWallet, isTrue);
      expect(q.walletCoversTotal, isFalse);
      expect(q.sadadAllowed, isTrue);
      expect(q.offers('BANK'), isFalse);
    });

    test('place order body never sends delivery-method fields', () {
      const params = MainSourceCheckoutParams(
        location: MainSourceLocation(
            latitude: 24.7136,
            longitude: 46.6753,
            address: 'King Fahd Rd, Al Olaya, Riyadh 12211',
            city: 'Riyadh'),
        paymentMethod: 'CASH',
        note: 'Call before arriving',
      );
      final body = params.toOrderJson();
      expect(body, {
        'payment_method': 'CASH',
        'latitude': 24.7136,
        'longitude': 46.6753,
        'address': 'King Fahd Rd, Al Olaya, Riyadh 12211',
        'city': 'Riyadh',
        'use_wallet': false,
        'note': 'Call before arriving',
        'platform': 'MOBILE',
      });
      for (final key in [
        'order_type',
        'address_id',
        'booking_date_time',
        'variant_id'
      ]) {
        expect(body.containsKey(key), isFalse);
      }
    });

    test('buy now adds variant and quantity', () {
      const params = MainSourceCheckoutParams(
          buyNow: MainSourceBuyNow(variantId: 21, quantity: 3),
          useWallet: true);
      expect(params.toQuoteJson(),
          {'use_wallet': true, 'variant_id': 21, 'quantity': 3});
      expect(params.copyWith(force: true).toOrderJson()['force'], isTrue);
    });

    test('CASH result', () {
      final r = MainSourcePlaceOrderResult.fromJson(
          j({'order': orderJson, 'payment': {'method': 'CASH'}}));
      expect(r.order.orderNumber, 'MS-261119-000105');
      expect(r.order.delivery?.city, 'Riyadh');
      expect(r.order.canCancel, isTrue);
      expect(r.order.statusHistory.single.note, 'Order placed');
      expect(r.order.statusHistory.single.isPaymentEvent, isFalse);
      expect(r.payment.method, 'CASH');
      expect(r.payment.needsMadaPayment, isFalse);
    });

    test('SADAD result', () {
      final r = MainSourcePlaceOrderResult.fromJson(j({
        'order': orderJson,
        'payment': {
          'method': 'SADAD',
          'go_pay': {
            'bill_number': 'ms_106',
            'sadad_number': '987654321012',
            'amount': 138,
            'expire_date': '2026-11-26'
          }
        }
      }));
      expect(r.payment.goPay?.sadadNumber, '987654321012');
      expect(r.payment.goPay?.billNumber, 'ms_106');
      expect(r.payment.goPay?.amount, 138);
    });

    test('MADA result', () {
      final r = MainSourcePlaceOrderResult.fromJson(j({
        'order': orderJson,
        'payment': {
          'method': 'MADA',
          'checkout_id': '8AC7A4A1',
          'integrity': 'sha384-x'
        }
      }));
      expect(r.payment.needsMadaPayment, isTrue);
    });

    test('BANK result: accounts with account_holder_name', () {
      final r = MainSourcePlaceOrderResult.fromJson(j({
        'order': orderJson,
        'payment': {
          'method': 'BANK',
          'bank_accounts': [bankAccountJson]
        }
      }));
      final a = r.payment.bankAccounts.single;
      expect(a.id, 34);
      expect(a.accountName, 'UFC');
      expect(a.iban, 'SA0380000000608010167519');
    });

    test('verify and pay', () {
      final v = MainSourcePaymentVerifyResult.fromJson({
        'payment_status': 'PAID',
        'order_id': 105,
        'order_number': 'MS-261119-000105',
        'order_payment_status': 'PAID'
      });
      expect(v.isPaid, isTrue);
      final p = MainSourcePayStartResult.fromJson({
        'order_id': 105,
        'order_number': 'MS-261119-000105',
        'method': 'MADA',
        'checkout_id': '8AC7A4A2',
        'integrity': 'sha384-y'
      });
      expect(p.checkoutId, '8AC7A4A2');
    });
  });

  group('orders', () {
    test('uploaded receipt', () {
      final o = MainSourceOrderModel.fromJson(j(uploadedOrderJson));
      expect(o.isBank, isTrue);
      expect(o.paymentStatus, 'PENDING_VERIFICATION');
      expect(o.canUploadReceipt, isFalse);
      final t = o.bankTransfer!;
      expect(t.isPending, isTrue);
      expect(t.amount, 138);
      expect(t.isPdf, isFalse);
      expect(t.bankAccount?.accountName, 'UFC');
      expect(o.statusHistory.last.isPaymentEvent, isTrue);
    });

    test('list row', () {
      final o = MainSourceOrderModel.fromJson({
        'id': 107,
        'order_number': 'MS-261119-000107',
        'order_status': 'PENDING',
        'payment_method': 'CASH',
        'payment_status': 'PENDING',
        'total_with_vat': 253,
        'payable_amount': 213,
        'items_count': 1,
        'image': 'https://x/barley.png',
        'main_source': sourceRef,
        'created_at': '2026-11-19T20:32:47.000000Z'
      });
      expect(o.itemsCount, 1);
      expect(o.image, isNotNull);
      expect(o.payableAmount, 213);
      expect(o.createdAt, isNotNull);
    });

    test('reorder', () {
      final r = MainSourceReorderResult.fromJson(
          j({'cart': cartJson, 'skipped_items': ['Oats']}));
      expect(r.cart.items, hasLength(1));
      expect(r.skippedItems, ['Oats']);
    });
  });

  group('errors', () {
    test('mixed cart', () {
      final e = MainSourceApiException(
        statusCode: 409,
        code: 'MIXED_MAIN_SOURCE_CART',
        message: 'x',
        data: j({
          'status': 'fail',
          'code': 'MIXED_MAIN_SOURCE_CART',
          'cart_main_source': sourceRef
        }),
      );
      expect(e.cartMainSource?.nameEn, 'UFC Main Source');
    });

    test('out of stock at checkout', () {
      final e = MainSourceApiException(
        statusCode: 422,
        code: 'OUT_OF_STOCK',
        message: 'x',
        data: j({
          'items': [
            {
              'cart_item_id': 32,
              'variant_id': 21,
              'product_name': 'Barley',
              'product_name_ar': 'شعير',
              'requested_quantity': 5,
              'available_quantity': 3,
              'reason': 'out_of_stock'
            }
          ]
        }),
      );
      expect(e.stockIssues.single.availableQuantity, 3);
      expect(e.stockIssues.single.isUnavailable, isFalse);
    });

    test('payment method disabled and wallet', () {
      final e = MainSourceApiException(
          code: 'PAYMENT_METHOD_DISABLED',
          message: 'x',
          data: j({'payment_methods': ['CASH', 'SADAD', 'WALLET']}));
      expect(e.paymentMethods, ['CASH', 'SADAD', 'WALLET']);
      final w = MainSourceApiException(
          code: 'INSUFFICIENT_WALLET_BALANCE',
          message: 'x',
          data: j({'wallet_balance': 100, 'total': 138}));
      expect(w.walletBalance, 100);
      expect(w.total, 138);
    });
  });
}
