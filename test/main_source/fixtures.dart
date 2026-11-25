import 'dart:convert';

/// JSON examples from docs/MainSourceBusineessPlan-fixed-21-11-2026.md.
Map<String, dynamic> j(Object value) =>
    jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

const sourceRef = {
  'id': 1,
  'name_en': 'UFC Main Source',
  'name_ar': 'المصدر الرئيسي',
  'name_ur': null,
  'icon': null,
};

const productJson = {
  'id': 12,
  'main_source_id': 1,
  'main_source': sourceRef,
  'category': {'id': 3, 'name_en': 'Feed', 'name_ar': 'أعلاف', 'name_ur': null},
  'name_en': 'Barley',
  'name_ar': 'شعير',
  'name_ur': null,
  'sku': null,
  'image': 'https://x/main_source_products/barley.png',
  'images': ['https://x/main_source_products/barley.png'],
  'min_price': 100,
  'max_price': 100,
  'in_stock': true,
  'variants': [
    {
      'id': 21,
      'size': '40 KG',
      'price': 100,
      'original_price': 110,
      'stock': 10,
      'is_available': true
    }
  ],
};

const productsPageJson = {
  'message': 'Products fetched successfully',
  'data': {
    'current_page': 1,
    'data': [productJson],
    'last_page': 1,
    'per_page': 20,
    'total': 1,
  },
};

const homeJson = {
  'main_sources': [
    {
      'id': 1,
      'name_en': 'UFC Main Source',
      'name_ar': 'المصدر الرئيسي',
      'name_ur': null,
      'description_en': null,
      'description_ar': null,
      'icon': null,
      'photo': null,
      'phone': '0500000000',
      'email': 'main@ufc-app.com',
      'delivery_fee': 20,
      'payment_methods': ['CASH', 'SADAD', 'MADA', 'WALLET'],
      'categories': [
        {
          'id': 3,
          'main_source_id': 1,
          'name_en': 'Feed',
          'name_ar': 'أعلاف',
          'name_ur': null,
          'image': null,
          'products_count': 1
        }
      ],
    }
  ],
  'latest_products': [productJson],
};

const cartJson = {
  'main_source': sourceRef,
  'items': [
    {
      'id': 27,
      'product_id': 12,
      'variant_id': 21,
      'product_name_en': 'Barley',
      'product_name_ar': 'شعير',
      'product_name_ur': null,
      'image': 'https://x/barley.png',
      'size': '40 KG',
      'unit_price': 100,
      'original_price': 110,
      'quantity': 2,
      'total': 200,
      'stock': 10,
      'is_available': true,
    }
  ],
  'items_count': 1,
  'quantity': 2,
  'subtotal': 200,
  'has_unavailable_items': false,
};

const quoteJson = {
  'main_source': sourceRef,
  'items': [
    {
      'cart_item_id': 29,
      'product_id': 12,
      'variant_id': 21,
      'product_name': 'Barley',
      'product_name_ar': 'شعير',
      'size': '40 KG',
      'unit_price': 100,
      'quantity': 2,
      'total': 200
    }
  ],
  'subtotal': 200,
  'coupon_amount': 0,
  'vat_percentage': 15,
  'vat_amount': 30,
  'delivery_fee': 20,
  'delivery_coupon_amount': 0,
  'delivery_vat': 3,
  'total': 220,
  'total_with_vat': 253,
  'wallet_balance': 50,
  'wallet_applied': 50,
  'payable_amount': 203,
  'payment_methods': ['CASH', 'SADAD', 'MADA', 'WALLET'],
  'sadad_min_amount': 50,
};

const orderJson = {
  'id': 105,
  'order_number': 'MS-261119-000105',
  'order_status': 'PENDING',
  'payment_method': 'CASH',
  'payment_status': 'PENDING',
  'main_source': {
    'id': 1,
    'name_en': 'UFC Main Source',
    'name_ar': 'المصدر الرئيسي',
    'name_ur': null,
    'icon': null,
    'phone': '0500000000'
  },
  'delivery': {
    'latitude': 24.7136,
    'longitude': 46.6753,
    'address': 'King Fahd Rd, Al Olaya, Riyadh 12211',
    'city': 'Riyadh',
    'landmark': null
  },
  'items': [
    {
      'id': 105,
      'product_id': 12,
      'variant_id': 21,
      'product_name': 'Barley',
      'product_name_ar': 'شعير',
      'size': '40 KG',
      'image': 'https://x/barley.png',
      'unit_price': 100,
      'quantity': 2,
      'total': 200
    }
  ],
  'subtotal': 200,
  'coupon_code': null,
  'coupon_amount': 0,
  'delivery_fee': 20,
  'delivery_coupon_amount': 0,
  'vat_amount': 30,
  'delivery_vat': 3,
  'total_with_vat': 253,
  'wallet_amount_used': 0,
  'payable_amount': 253,
  'go_pay': null,
  'bank_transfer': null,
  'bank_accounts': [],
  'can_upload_receipt': false,
  'note': 'Call before arriving',
  'can_cancel': true,
  'can_pay': false,
  'status_history': [
    {
      'from_status': null,
      'to_status': 'PENDING',
      'note': 'Order placed',
      'created_at': '2026-11-19T20:32:46.000000Z'
    }
  ],
  'created_at': '2026-11-19T20:32:46.000000Z',
};

const bankAccountJson = {
  'id': 34,
  'bank_name': 'Al Rajhi Bank',
  'account_holder_name': 'UFC',
  'account_number': '608010167519',
  'iban': 'SA0380000000608010167519',
  'swift_code': 'RJHISARI',
  'branch': null,
  'currency': 'SAR',
  'notes': null,
};

/// `POST /main-source/orders/{id}/bank-transfer` response `data`.
const uploadedOrderJson = {
  'id': 148,
  'order_number': 'MS-261121-000148',
  'payment_method': 'BANK',
  'payment_status': 'PENDING_VERIFICATION',
  'bank_transfer': {
    'id': 22,
    'status': 'pending',
    'amount': 138,
    'reference_number': 'TRX123456',
    'transfer_date': '2026-11-21',
    'receipt_url':
        'https://x/main_source_bank_receipts/148/receipt.jpg?X-Amz-Signature=abc',
    'rejection_reason': null,
    'bank_account': bankAccountJson,
    'created_at': '2026-11-21T11:56:53.000000Z',
    'reviewed_at': null,
  },
  'bank_accounts': [],
  'can_upload_receipt': false,
  'can_cancel': true,
  'status_history': [
    {
      'from_status': null,
      'to_status': 'PENDING',
      'note': 'Order placed',
      'created_at': '2026-11-21T11:56:53.000000Z'
    },
    {
      'from_status': 'PENDING',
      'to_status': 'PENDING',
      'note': 'Bank transfer receipt uploaded',
      'created_at': '2026-11-21T11:56:53.000000Z'
    }
  ],
};
