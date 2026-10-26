import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../screens/feed/domain/entities/distributor/bank_account_model.dart';
import '../../../screens/feed/domain/entities/distributor/bank_transfer_model.dart';
import '../../extensions/saudi_riyal_icon.dart';
import 'copyable_field.dart';

/// IBAN shown in groups of 4 ("SA03 8000 ..."); always copied without spaces.
String formatIban(String iban) {
  final raw = iban.replaceAll(RegExp(r'\s+'), '');
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && i % 4 == 0) buffer.write(' ');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String compactIban(String iban) => iban.replaceAll(RegExp(r'\s+'), '');

/// One bank account with copyable rows. Empty rows are hidden; the branch
/// is text only.
class BankAccountCard extends StatelessWidget {
  final BankAccountModel account;

  const BankAccountCard({super.key, required this.account});

  static bool _has(String? v) => v != null && v.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              spreadRadius: .5,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          if (_has(account.bankName))
            CopyableField(label: 'Bank', value: account.bankName!),
          if (_has(account.accountName))
            CopyableField(label: 'Account name', value: account.accountName!),
          if (_has(account.iban))
            CopyableField(
              label: 'IBAN',
              value: formatIban(account.iban!),
              copyValue: compactIban(account.iban!),
            ),
          if (_has(account.accountNumber))
            CopyableField(
                label: 'Account number', value: account.accountNumber!),
          if (_has(account.branch))
            CopyableField(
                label: 'Branch', value: account.branch!, copyable: false),
        ],
      ),
    );
  }
}

/// Bank transfer instructions: amount, reference (order number) and the
/// distributor's accounts. Used on checkout success and order details.
class BankTransferBox extends StatelessWidget {
  final BankTransferModel transfer;
  final String? title;

  const BankTransferBox({super.key, required this.transfer, this.title});

  @override
  Widget build(BuildContext context) {
    final amount = (transfer.amount ?? 0).toStringAsFixed(2);
    final reference = transfer.reference ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x1AF7D66D),
        border: Border.all(color: const Color(0xFFF7D66D)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_outlined,
                  size: 20, color: Color(0xff78B833)),
              const SizedBox(width: 8),
              Expanded(
                child: Text((title ?? 'Bank transfer').tr(),
                    style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'bank_transfer_instruction'
                .tr(namedArgs: {'amount': amount, 'reference': reference}),
            style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFF44444F)),
          ),
          const SizedBox(height: 8),
          CopyableField(
            label: 'Amount to transfer',
            value: amount,
            trailingValue: Row(
              children: [
                SelectableText(amount,
                    style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 2),
                const SaudiRiyalIcon(size: 13),
              ],
            ),
          ),
          if (reference.isNotEmpty)
            CopyableField(label: 'Reference (order number)', value: reference),
          for (final account in transfer.bankAccounts)
            BankAccountCard(account: account),
        ],
      ),
    );
  }
}
