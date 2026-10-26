import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

/// Tokens, passwords and OTPs must never reach logs or crash reports.
void main() {
  test('redacts token values in JSON and Map text', () {
    expect(redactSecrets('{"message":"ok","token":"14825|abcDEF"}'),
        '{"message":"ok","token":"[REDACTED]"}');
    expect(redactSecrets({'token': '14825|abc', 'name': 'Ali'}),
        '{token: [REDACTED], name: Ali}');
  });

  test('redacts OTP, password and Bearer headers', () {
    expect(redactSecrets('{"phone":"055","otp":"123456"}'),
        '{"phone":"055","otp":"[REDACTED]"}');
    expect(redactSecrets('password=secret1'), 'password=[REDACTED]');
    expect(redactSecrets('Authorization: Bearer 14825|abc'),
        'Authorization: Bearer [REDACTED]');
  });

  test('keeps normal data', () {
    expect(redactSecrets('{"id":5,"name_en":"Feras"}'),
        '{"id":5,"name_en":"Feras"}');
  });

  test('safeHeaders hides Authorization and X-Owner-Id', () {
    final h = safeHeaders({
      'Authorization': 'Bearer x',
      'X-Owner-Id': '5401',
      'Accept': 'application/json',
    });
    expect(h['Authorization'], '[REDACTED]');
    expect(h['X-Owner-Id'], '[REDACTED]');
    expect(h['Accept'], 'application/json');
  });
}
