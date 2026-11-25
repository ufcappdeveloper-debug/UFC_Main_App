import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufc_mobile/global/shared/widgets/bank_account_card.dart';
import 'package:ufc_mobile/global/shared/widgets/copyable_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../application/main_source/main_source_order_cubit.dart';
import '../../../domain/entities/distributor/bank_account_model.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../distributor/pages/bank_receipt_viewer_page.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../utils/main_source_errors.dart';

/// Bank transfer of a BANK order (plan §4.5): accounts to transfer to,
/// receipt upload, "being verified", rejection + new upload, paid.
/// Reads the order from the [MainSourceOrderCubit] above it.
class MainSourceBankTransferSection extends StatelessWidget {
  const MainSourceBankTransferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSourceOrderCubit, MainSourceOrderState>(
      builder: (context, state) {
        final order = state.order;
        if (order == null || !order.isBank) return const SizedBox.shrink();
        final transfer = order.bankTransfer;
        final status = order.paymentStatus;
        final uploading = state.busy == MainSourceOrderAction.upload;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: DistributorStyle.card(radius: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_outlined,
                      color: DistributorStyle.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Bank Transfer'.tr(),
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w600)),
                  ),
                  _StatusChip(status: status),
                ],
              ),
              const SizedBox(height: 10),
              if (status == MainSourcePaymentStatus.pendingVerification)
                _Note(
                    text: 'Your transfer is being verified'.tr(),
                    color: DistributorStyle.textSecondary),
              if (status == MainSourcePaymentStatus.rejected ||
                  (transfer?.isRejected ?? false)) ...[
                _Note(text: 'Transfer rejected'.tr(), color: DistributorStyle.error),
                if ((transfer?.rejectionReason ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: Text(transfer!.rejectionReason!,
                        style: DistributorStyle.style(
                            size: 13, color: DistributorStyle.error)),
                  ),
              ],
              if (order.canUploadReceipt) ...[
                Row(
                  children: [
                    Flexible(
                      child: Text('Transfer'.tr(),
                          style: DistributorStyle.style(size: 13)),
                    ),
                    const SizedBox(width: 6),
                    RiyalAmount(order.payableAmount, size: 14),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Transfer to one of these accounts'.tr(),
                    style: DistributorStyle.style(
                        size: 12, color: DistributorStyle.textSecondary)),
                if ((order.orderNumber ?? '').isNotEmpty)
                  CopyableField(
                      label: 'Transfer reference', value: order.orderNumber!),
                for (final account in order.bankAccounts)
                  BankAccountCard(account: account),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DistributorStyle.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                    ),
                    onPressed: uploading || order.bankAccounts.isEmpty
                        ? null
                        : () => showMainSourceReceiptSheet(context),
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: Text((transfer == null
                            ? 'Upload receipt'
                            : 'Upload new receipt')
                        .tr()),
                  ),
                ),
              ],
              if (transfer != null && !order.canUploadReceipt) ...[
                if (transfer.bankAccount != null)
                  BankAccountCard(account: transfer.bankAccount!),
                _TransferDetails(transfer: transfer),
              ],
              if ((transfer?.receiptUrl ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                _ReceiptLink(transfer: transfer!),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      MainSourcePaymentStatus.paid => ('Paid', DistributorStyle.green),
      MainSourcePaymentStatus.pendingVerification =>
        ('Being verified', DistributorStyle.textSecondary),
      MainSourcePaymentStatus.rejected => ('Rejected', DistributorStyle.error),
      MainSourcePaymentStatus.refunded =>
        ('Refunded', DistributorStyle.textSecondary),
      _ => ('Awaiting transfer', DistributorStyle.priceGrey),
    };
    return OutlineChip(label: label, color: color);
  }
}

class _Note extends StatelessWidget {
  final String text;
  final Color color;

  const _Note({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: DistributorStyle.style(
                size: 13, weight: FontWeight.w500, color: color)),
      );
}

class _TransferDetails extends StatelessWidget {
  final MainSourceBankTransfer transfer;

  const _TransferDetails({required this.transfer});

  @override
  Widget build(BuildContext context) {
    Widget row(String label, Widget value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Text(label.tr(),
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.textSecondary)),
              const Spacer(),
              value,
            ],
          ),
        );
    return Column(
      children: [
        if (transfer.amount != null)
          row('Amount', RiyalAmount(transfer.amount, size: 12)),
        if ((transfer.referenceNumber ?? '').isNotEmpty)
          row('Reference number',
              Text(transfer.referenceNumber!,
                  style: DistributorStyle.style(size: 12))),
        if ((transfer.transferDate ?? '').isNotEmpty)
          row('Transfer date',
              Text(transfer.transferDate!,
                  style: DistributorStyle.style(size: 12))),
      ],
    );
  }
}

class _ReceiptLink extends StatelessWidget {
  final MainSourceBankTransfer transfer;

  const _ReceiptLink({required this.transfer});

  /// The link lasts 60 minutes: reload the order for a fresh one.
  Future<String?> _fresh(BuildContext context) async {
    final cubit = context.read<MainSourceOrderCubit>();
    await cubit.refresh();
    return cubit.state.order?.bankTransfer?.receiptUrl;
  }

  Future<void> _open(BuildContext context) async {
    final url = await _fresh(context) ?? transfer.receiptUrl;
    if (url == null || !context.mounted) return;
    final isPdf =
        (Uri.tryParse(url)?.path ?? '').toLowerCase().endsWith('.pdf');
    if (isPdf) {
      final opened =
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        CustomSnackBar.error(context, 'receipt_open_failed'.tr());
      }
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) =>
          BankReceiptViewerPage(url: url, refreshUrl: () => _fresh(context)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DistributorStyle.greenTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(transfer.isPdf ? Icons.picture_as_pdf : Icons.receipt_long,
                color: transfer.isPdf
                    ? DistributorStyle.error
                    : DistributorStyle.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text('view_receipt'.tr(),
                  style: DistributorStyle.style(
                      size: 14, color: DistributorStyle.green)),
            ),
            const Icon(Icons.chevron_right, color: DistributorStyle.green),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ upload sheet

enum _ReceiptSource {
  camera('receipt_camera', Icons.photo_camera_outlined),
  gallery('receipt_gallery', Icons.photo_library_outlined),
  files('receipt_files', Icons.description_outlined);

  final String label;
  final IconData icon;

  const _ReceiptSource(this.label, this.icon);

  Future<({String path, String name})?> pick() async {
    if (this == _ReceiptSource.files) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: MainSourceReceiptRules.extensions,
      );
      final file = result?.files.single;
      return file?.path == null ? null : (path: file!.path!, name: file.name);
    }
    // Compressed to stay well under the 5 MB limit.
    final photo = await ImagePicker().pickImage(
      source: this == _ReceiptSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 80,
    );
    return photo == null ? null : (path: photo.path, name: photo.name);
  }
}

/// `receipt_image`: jpg, jpeg, png, webp, heic or pdf; max 5 MB.
class MainSourceReceiptRules {
  static const maxBytes = 5 * 1024 * 1024;
  static const extensions = ['jpg', 'jpeg', 'png', 'webp', 'heic', 'pdf'];

  static bool allowedName(String name) =>
      extensions.contains(name.split('.').last.toLowerCase());
}

/// Upload form: account, amount (pre-filled with `payable_amount`),
/// reference, date (today) and the receipt file.
Future<void> showMainSourceReceiptSheet(BuildContext context) {
  final cubit = context.read<MainSourceOrderCubit>();
  final order = cubit.state.order;
  if (order == null) return Future.value();
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ReceiptForm(order: order),
    ),
  );
}

class _ReceiptForm extends StatefulWidget {
  final MainSourceOrderModel order;

  const _ReceiptForm({required this.order});

  @override
  State<_ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<_ReceiptForm> {
  late BankAccountModel? _account = widget.order.bankAccounts.firstOrNull;
  late final _amount = TextEditingController(
      text: widget.order.payableAmount.toStringAsFixed(2));
  final _reference = TextEditingController();
  DateTime _date = DateTime.now();
  ({String path, String name})? _file;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final source = await showModalBottomSheet<_ReceiptSource>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in _ReceiptSource.values)
              ListTile(
                leading: Icon(s.icon, color: DistributorStyle.green),
                title: Text(s.label.tr(), style: DistributorStyle.style()),
                onTap: () => Navigator.pop(ctx, s),
              ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await source.pick();
    if (file == null || !mounted) return;
    if (!MainSourceReceiptRules.allowedName(file.name)) {
      setState(() => _error = 'Please choose an image or a PDF file.'.tr());
      return;
    }
    if (await File(file.path).length() > MainSourceReceiptRules.maxBytes) {
      setState(() => _error = 'receipt_too_large'.tr());
      return;
    }
    setState(() {
      _file = file;
      _error = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', '.'));
    if (_account?.id == null) {
      setState(() => _error = 'Choose the account you transferred to.'.tr());
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter the transferred amount.'.tr());
      return;
    }
    if (_file == null) {
      setState(() => _error = 'Choose the receipt file.'.tr());
      return;
    }
    setState(() => _error = null);
    final cubit = context.read<MainSourceOrderCubit>();
    final ok = await cubit.uploadReceipt(MainSourceBankTransferParams(
      bankAccountId: _account!.id!,
      filePath: _file!.path,
      fileName: _file!.name,
      amount: amount,
      referenceNumber: _reference.text,
      transferDate: DateFormat('yyyy-MM-dd', 'en').format(_date),
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      CustomSnackBar.success(context, 'receipt_uploaded_toast'.tr());
    } else {
      final error = cubit.state.error;
      setState(() => _error =
          error == null ? 'Something went wrong'.tr() : mainSourceErrorText(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = widget.order.bankAccounts;
    final state = context.watch<MainSourceOrderCubit>().state;
    final uploading = state.busy == MainSourceOrderAction.upload;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Upload receipt'.tr(),
                  style:
                      DistributorStyle.style(size: 16, weight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text('Account you transferred to'.tr(),
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.textSecondary)),
              for (final a in accounts)
                RadioListTile<int?>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: a.id,
                  groupValue: _account?.id,
                  activeColor: DistributorStyle.green,
                  onChanged: uploading ? null : (_) => setState(() => _account = a),
                  title: Text(a.bankName ?? '-',
                      style: DistributorStyle.style(size: 13)),
                  subtitle: Text(a.iban ?? a.accountNumber ?? '',
                      style: DistributorStyle.style(
                          size: 11, color: DistributorStyle.textSecondary)),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _amount,
                enabled: !uploading,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount transferred'.tr(),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reference,
                enabled: !uploading,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: 'Reference number (optional)'.tr(),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              InkWell(
                onTap: uploading ? null : _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Transfer date'.tr(),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd', 'en').format(_date),
                      style: DistributorStyle.style(size: 13)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: DistributorStyle.green,
                  side: const BorderSide(color: DistributorStyle.green),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: uploading ? null : _pickFile,
                icon: Icon(_file == null ? Icons.attach_file : Icons.check),
                label: Text(_file?.name ?? 'Choose receipt'.tr(),
                    overflow: TextOverflow.ellipsis),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!,
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.error)),
                ),
              const SizedBox(height: 12),
              if (uploading)
                LinearProgressIndicator(
                  value: state.uploadProgress,
                  color: DistributorStyle.green,
                  backgroundColor: DistributorStyle.greenTint,
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DistributorStyle.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)),
                  ),
                  onPressed: uploading ? null : _submit,
                  child: Text('Upload receipt'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
