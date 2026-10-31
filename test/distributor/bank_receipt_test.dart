import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/bank_transfer_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/distributor/widgets/bank_receipt_section.dart';

OrderModel _order(Map<String, dynamic> overrides) => OrderModel.fromJson({
      'id': 30560,
      'channel': 'DISTRIBUTOR',
      'payment_method': 'BANK',
      'payment_status': 'PENDING',
      'order_status': 'PENDING',
      ...overrides,
    });

void main() {
  group('upload rules', () {
    test('unpaid BANK distributor order can upload', () {
      expect(_order({}).canUploadBankReceipt, isTrue);
    });

    test('paid, cancelled and rejected orders cannot', () {
      expect(_order({'payment_status': 'PAID'}).canUploadBankReceipt, isFalse);
      expect(_order({'order_status': 'CANCELLED'}).canUploadBankReceipt, isFalse);
      expect(_order({'order_status': 'REJECTED'}).canUploadBankReceipt, isFalse);
    });

    test('CASH and shop orders get no receipt UI', () {
      expect(_order({'payment_method': 'CASH'}).canUploadBankReceipt, isFalse);
      final shop = _order({'channel': 'SHOP'});
      expect(shop.isBankDistributorOrder, isFalse);
      expect(shop.canUploadBankReceipt, isFalse);
    });

    test('parses the receipt fields', () {
      final order = _order({
        'bank_receipt_url': 'https://s3/a.jpg?X-Amz-Expires=3600',
        'bank_receipt_uploaded_at': '2026-10-30T09:12:44.000000Z',
      });
      expect(order.hasBankReceipt, isTrue);
      expect(_order({}).hasBankReceipt, isFalse);
    });
  });

  group('receipt link', () {
    test('PDF check ignores the signed query string', () {
      expect(BankReceiptModel.isPdf('https://s3/a/B.PDF?X-Amz-Signature=x'),
          isTrue);
      expect(BankReceiptModel.isPdf('https://s3/a.jpg?file=b.pdf'), isFalse);
      expect(BankReceiptModel.isPdf(null), isFalse);
    });

    test('reads the upload response', () {
      final r = BankReceiptModel.fromJson({
        'order_id': 30560,
        'bank_receipt_url': 'https://s3/a.jpg',
        'bank_receipt_uploaded_at': '2026-10-30T09:12:44.000000Z',
      });
      expect(r.url, 'https://s3/a.jpg');
      expect(r.uploadedAt, '2026-10-30T09:12:44.000000Z');
    });
  });

  group('upload time in Saudi time', () {
    test('both API formats give the same time', () {
      expect(
          BankReceiptSection.formatUploadedAt('2026-10-30T09:12:44.000000Z'),
          '2026-10-30 12:12');
      expect(BankReceiptSection.formatUploadedAt('2026-10-30 09:12'),
          '2026-10-30 12:12');
    });

    test('empty or invalid values are hidden', () {
      expect(BankReceiptSection.formatUploadedAt(null), isNull);
      expect(BankReceiptSection.formatUploadedAt('soon'), isNull);
    });
  });
}
