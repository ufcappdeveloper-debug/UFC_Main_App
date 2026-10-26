import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/global/shared/widgets/bank_account_card.dart';
import 'package:ufc_mobile/models/order_hh/order_item.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/checkout_options_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/checkout_summary_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/distributor_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/distributor_place_order_result.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/distributor_product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/distributor_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';

/// Parsing tests for the distributor channel (mobile_integration_guide.md,
/// Part A). No network.
void main() {
  group('CheckoutOptionsModel', () {
    final options = CheckoutOptionsModel.fromJson({
      'distributor_id': 105,
      'is_open': true,
      'order_types': [
        {
          'code': 'PICKUP_ONLY',
          'label_en': "Pick up from distributor's location",
          'label_ar': 'استلام من موقع الموزع',
          'subtitle': 'Jeddah, Industrial Area 2',
          'latitude': 21.5,
          'longitude': 39.2,
        },
        {'code': 'DELIVERY', 'label_en': 'Home delivery', 'fee': 15},
      ],
      'payment_methods': [
        {'code': 'CASH', 'label_en': 'Cash'},
        {
          'code': 'BANK',
          'label_en': 'Bank transfer',
          'bank_accounts': [
            {
              'id': 6,
              'bank_name': 'Al Rajhi Bank',
              'account_name': 'Acme Feed',
              'iban': 'SA0380000000608010167519',
              'account_number': '608010167519',
              'branch': null,
            }
          ],
        },
      ],
    });

    test('keeps order types and payment methods in API order', () {
      expect(options.orderTypes.map((e) => e.code),
          ['PICKUP_ONLY', 'DELIVERY']);
      expect(options.paymentMethods.map((e) => e.code), ['CASH', 'BANK']);
    });

    test('parses pickup location, delivery fee (int) and bank accounts', () {
      final pickup = options.orderType('PICKUP_ONLY')!;
      expect(pickup.isPickup, isTrue);
      expect(pickup.hasLocation, isTrue);
      expect(pickup.label, "Pick up from distributor's location");
      expect(options.orderType('DELIVERY')!.fee, 15.0);
      final bank = options.paymentMethod('BANK')!;
      expect(bank.isBank, isTrue);
      expect(bank.bankAccounts.single.iban, 'SA0380000000608010167519');
      expect(bank.bankAccounts.single.branch, isNull);
    });
  });

  group('DistributorProductModel', () {
    test('uses variants[0] for price, offer and stock', () {
      final p = DistributorProductModel.fromJson({
        'id': 1,
        'name_en': 'Bulk Alfalfa 50kg',
        'variants': [
          {
            'id': 1,
            'price': 115,
            'original_price': 150,
            'stock': 38,
            'size': '50kg',
            'is_available': true
          }
        ],
        'images': [
          {'id': 4, 'location': 'https://example.com/a.png'}
        ],
        'favorite': true,
      });
      expect(p.price, 115.0);
      expect(p.isOffer, isTrue);
      expect(p.discountPercent, 23);
      expect(p.isOutOfStock, isFalse);
      expect(p.image, 'https://example.com/a.png');
      expect(p.favorite, isTrue);
    });

    test('is out of stock when stock <= 0 or not available', () {
      final noStock = DistributorProductModel.fromJson({
        'variants': [
          {'id': 1, 'price': 10, 'stock': 0}
        ]
      });
      final unavailable = DistributorProductModel.fromJson({
        'variants': [
          {'id': 1, 'price': 10, 'stock': 5, 'is_available': false}
        ]
      });
      expect(noStock.isOutOfStock, isTrue);
      expect(unavailable.isOutOfStock, isTrue);
    });
  });

  test('DistributorCartModel sums quantities for the badge', () {
    final cart = DistributorCartModel.fromJson({
      'distributor_id': 1,
      'distributor': {'id': 1, 'name_en': 'Acme', 'is_open': true},
      'total_amount': 240,
      'cart': [
        {
          'id': 7,
          'distributor_variant_id': 1,
          'quantity': 2,
          'variant': {'id': 1, 'price': 120, 'stock': 38},
        },
        {
          'id': 8,
          'distributor_variant_id': 2,
          'quantity': 3,
          'variant': {'id': 2, 'price': 10, 'stock': 5},
        },
      ],
    });
    expect(cart.count, 5);
    expect(cart.items.first.total, 240.0);
    expect(cart.distributor!.name, 'Acme');
  });

  test('AddDistributorCartParams only sends replace_cart when set', () {
    const params = AddDistributorCartParams(
        productId: 1, variantId: 1, quantity: 2);
    expect(params.toJson().containsKey('replace_cart'), isFalse);
    expect(params.copyWith(replaceCart: true).toJson()['replace_cart'], true);
  });

  test('place order params never send use_wallet', () {
    const params = DistributorPlaceOrderParams(
        paymentMethod: 'BANK', orderType: 'PICKUP_ONLY', note: 'Gate 3');
    final json = params.toJson();
    expect(json.containsKey('use_wallet'), isFalse);
    expect(json['payment_method'], 'BANK');
    expect(json['note'], 'Gate 3');
  });

  test('checkout summary parses messages and out-of-stock ids', () {
    final s = DistributorCheckoutSummary.fromJson({
      'items_total': 240,
      'vat_amount': 36,
      'delivery_fee': 15,
      'delivery_vat': 2.25,
      'total_with_vat': 293.25,
      'out_of_stock_variant_ids': [3],
      'messages': {'coupon_code': 'Coupon code is invalid'},
    });
    expect(s.totalWithVat, 293.25);
    expect(s.outOfStockVariantIds, [3]);
    expect(s.messages['coupon_code'], 'Coupon code is invalid');
  });

  test('BANK place_order result exposes the bank transfer box data', () {
    final r = DistributorPlaceOrderResult.fromJson({
      'message': 'ok',
      'data': {'id': 30561, 'channel': 'DISTRIBUTOR', 'payment_method': 'BANK'},
      'bank_transfer': {
        'amount': 293.25,
        'reference': '30561',
        'bank_accounts': [
          {'id': 6, 'iban': 'SA0380000000608010167519'}
        ],
      },
      'skipped_cart_item_ids': [],
    });
    expect(r.order!.isDistributor, isTrue);
    expect(r.bankTransfer!.amount, 293.25);
    expect(r.bankTransfer!.reference, '30561');
    expect(r.bankTransfer!.bankAccounts, hasLength(1));
  });

  group('orders (A.8)', () {
    test('distributor order line falls back to distributor_product', () {
      final item = OrderItem.fromJson({
        'item_type': 'DISTRIBUTOR',
        'product_id': null,
        'product': null,
        'distributor_product_id': 1,
        'distributor_variant_id': 1,
        'distributor_product': {
          'id': 1,
          'name_en': 'Bulk Alfalfa 50kg',
          'images': [],
          'category': {'id': 3, 'name_en': 'Feed'},
          'distributor': {'id': 1, 'name_en': 'Acme'},
        },
        'quantity': 2,
        'order_price': 240,
      });
      expect(item.product, isNull);
      expect(item.isDistributor, isTrue);
      expect(item.displayProduct?.nameEn, 'Bulk Alfalfa 50kg');
    });

    test('order exposes channel, vendor and pending bank transfer', () {
      final order = OrderModel.fromJson({
        'id': 30561,
        'channel': 'DISTRIBUTOR',
        'shop': null,
        'distributor': {'id': 1, 'name_en': 'Acme Distribution'},
        'payment_status': 'PENDING',
        'bank_transfer': {'amount': 293.25, 'reference': '30561'},
      });
      expect(order.isDistributor, isTrue);
      expect(order.vendorName, 'Acme Distribution');
      expect(order.bankTransfer?.reference, '30561');
    });

    test('older orders read back as SHOP', () {
      expect(OrderModel.fromJson({'id': 1}).channel, 'SHOP');
    });
  });

  group('Order Now (buy_product)', () {
    test('body has the product fields, DASHBOARD platform, no wallet', () {
      const params = DistributorBuyProductParams(
        productId: 2,
        variantId: 5,
        quantity: 3,
        order: DistributorPlaceOrderParams(
            paymentMethod: 'CASH',
            orderType: 'DELIVERY',
            addressId: 9,
            distributorId: 1),
      );
      final json = params.toJson();
      expect(json['distributor_product_id'], 2);
      expect(json['distributor_variant_id'], 5);
      expect(json['quantity'], 3);
      expect(json['payment_method'], 'CASH');
      expect(json['order_type'], 'DELIVERY');
      expect(json['address_id'], 9);
      expect(json['platform'], 'DASHBOARD');
      expect(json.containsKey('use_wallet'), isFalse);
      expect(json.containsKey('distributor_id'), isFalse);
    });

    test('MADA/CARD response: order nested, checkout_id + integrity', () {
      final r = DistributorPlaceOrderResult.fromJson({
        'message': 'Order placed successfully',
        'data': {
          'order': {'id': 77, 'channel': 'DISTRIBUTOR'},
          'user': {'id': 1},
          'checkout_id': 'abc',
          'integrity': 'sha384-x',
        },
      });
      expect(r.order!.id, 77);
      expect(r.needsCardPayment, isTrue);
      expect(r.checkoutId, 'abc');
    });

    test('CASH response is not a card payment', () {
      final r = DistributorPlaceOrderResult.fromJson({
        'data': {'id': 78, 'payment_method': 'CASH'},
        'skipped_cart_item_ids': [],
      });
      expect(r.order!.id, 78);
      expect(r.needsCardPayment, isFalse);
    });
  });

  test('IBAN is shown in groups of 4 and copied without spaces', () {
    expect(formatIban('SA0380000000608010167519'),
        'SA03 8000 0000 6080 1016 7519');
    expect(compactIban('SA03 8000 0000 6080 1016 7519'),
        'SA0380000000608010167519');
  });
}
