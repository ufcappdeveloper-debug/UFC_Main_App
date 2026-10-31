import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/distributor/bank_transfer_model.dart';
import '../../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../../domain/repositories/distributor_repo.dart';
import '../pages/bank_receipt_viewer_page.dart';
import '../utils/distributor_style.dart';

/// Upload / view / replace the transfer receipt of an unpaid BANK order.
/// Once paid ([canUpload] false) an existing receipt is read only.
class BankReceiptSection extends StatefulWidget {
  final int orderId;
  final String? receiptUrl;
  final String? uploadedAt;
  final bool canUpload;

  /// The order changed: a receipt was uploaded, or the API says it can't
  /// take one any more (paid, cancelled...).
  final VoidCallback? onChanged;

  const BankReceiptSection({
    super.key,
    required this.orderId,
    this.receiptUrl,
    this.uploadedAt,
    this.canUpload = true,
    this.onChanged,
  });

  static const int maxBytes = 5 * 1024 * 1024;

  /// The API sends ISO 8601 or `Y-m-d H:i`, both UTC. Shown in Saudi time.
  static String? formatUploadedAt(String? value) {
    if (value == null || value.isEmpty) return null;
    final hasZone = value.endsWith('Z') || value.contains('+');
    final utc = DateTime.tryParse(hasZone ? value : '${value}Z');
    if (utc == null) return null;
    final saudi = utc.toUtc().add(const Duration(hours: 3));
    String two(int n) => n.toString().padLeft(2, '0');
    return '${saudi.year}-${two(saudi.month)}-${two(saudi.day)} '
        '${two(saudi.hour)}:${two(saudi.minute)}';
  }

  @override
  State<BankReceiptSection> createState() => _BankReceiptSectionState();
}

class _BankReceiptSectionState extends State<BankReceiptSection> {
  late String? _url = widget.receiptUrl;
  late String? _uploadedAt = widget.uploadedAt;
  late bool _canUpload = widget.canUpload;
  bool _uploading = false;
  double _progress = 0;
  bool _triedRefresh = false;

  DistributorRepository get _repo => sl<DistributorRepository>();

  bool get _hasReceipt => _url?.isNotEmpty ?? false;

  @override
  void didUpdateWidget(BankReceiptSection old) {
    super.didUpdateWidget(old);
    if (old.receiptUrl != widget.receiptUrl) {
      _url = widget.receiptUrl;
      _uploadedAt = widget.uploadedAt;
      _triedRefresh = false;
    }
    if (old.canUpload != widget.canUpload) _canUpload = widget.canUpload;
  }

  Future<void> _pick() async {
    final source = await showModalBottomSheet<_ReceiptSource>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

    final path = await source.pick();
    if (path == null || !mounted) return;

    if (await File(path).length() > BankReceiptSection.maxBytes) {
      if (mounted) CustomSnackBar.error(context, 'receipt_too_large'.tr());
      return;
    }
    await _upload(path);
  }

  Future<void> _upload(String path) async {
    setState(() {
      _uploading = true;
      _progress = 0;
    });
    try {
      final receipt = await _repo.uploadBankReceipt(
        widget.orderId,
        path,
        onProgress: (sent, total) {
          if (mounted && total > 0) setState(() => _progress = sent / total);
        },
      );
      if (!mounted) return;
      setState(() {
        _url = receipt.url;
        _uploadedAt = receipt.uploadedAt;
        _triedRefresh = false;
      });
      CustomSnackBar.success(context, 'receipt_uploaded_toast'.tr());
      widget.onChanged?.call();
    } on DistributorApiException catch (e) {
      if (!mounted) return;
      CustomSnackBar.error(context, e.message);
      final m = e.message.toLowerCase();
      final closed = m.contains('already paid') ||
          m.contains('cancelled') ||
          m.contains('rejected') ||
          m.contains('not paid by bank');
      if (closed) {
        setState(() => _canUpload = false);
        widget.onChanged?.call();
      }
    } catch (e) {
      if (mounted) CustomSnackBar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  /// The signed link lasts 60 minutes.
  Future<String?> _freshUrl() async {
    try {
      final url = await _repo.getBankReceiptUrl(widget.orderId);
      if (mounted && url != null) setState(() => _url = url);
      return url;
    } catch (_) {
      return null;
    }
  }

  void _onThumbnailFailed() {
    if (_triedRefresh) return;
    _triedRefresh = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _freshUrl());
  }

  Future<void> _view() async {
    final url = await _freshUrl() ?? _url;
    if (url == null || !mounted) return;
    if (BankReceiptModel.isPdf(url)) {
      final opened =
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        CustomSnackBar.error(context, 'receipt_open_failed'.tr());
      }
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) => BankReceiptViewerPage(url: url, refreshUrl: _freshUrl),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_canUpload && !_hasReceipt) return const SizedBox.shrink();
    final uploadedAt = BankReceiptSection.formatUploadedAt(_uploadedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: DistributorStyle.card(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_hasReceipt)
            Text('receipt_hint'.tr(),
                style: DistributorStyle.style(
                    size: 13, color: DistributorStyle.textSecondary))
          else ...[
            Row(
              children: [
                Icon(
                  _canUpload ? Icons.hourglass_top : Icons.check_circle,
                  size: 18,
                  color: _canUpload
                      ? const Color(0xFFE0A800)
                      : DistributorStyle.green,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (_canUpload ? 'receipt_under_review' : 'Paid').tr(),
                    style: DistributorStyle.style(
                        size: 14, weight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (uploadedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(uploadedAt,
                    style: DistributorStyle.style(
                        size: 12, color: DistributorStyle.priceGrey)),
              ),
            const SizedBox(height: 10),
            _ReceiptPreview(
              url: _url!,
              onTap: _view,
              onImageFailed: _onThumbnailFailed,
            ),
          ],
          if (_uploading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _progress > 0 ? _progress : null,
              color: DistributorStyle.green,
              backgroundColor: DistributorStyle.greenTint,
            ),
          ] else if (_canUpload) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: _hasReceipt
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DistributorStyle.green,
                        side: const BorderSide(color: DistributorStyle.green),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                      ),
                      onPressed: _pick,
                      child: Text('replace_receipt'.tr(),
                          style: DistributorStyle.style(
                              size: 14, color: DistributorStyle.green)),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DistributorStyle.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                      ),
                      onPressed: _pick,
                      icon: const Icon(Icons.upload_file, size: 20),
                      label: Text('upload_receipt'.tr(),
                          style: DistributorStyle.style(
                              size: 14, color: Colors.white)),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Thumbnail for an image, a file tile for a PDF.
class _ReceiptPreview extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
  final VoidCallback onImageFailed;

  const _ReceiptPreview({
    required this.url,
    required this.onTap,
    required this.onImageFailed,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = BankReceiptModel.isPdf(url);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DistributorStyle.greenTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 52,
                height: 52,
                child: isPdf
                    ? const Icon(Icons.picture_as_pdf,
                        color: DistributorStyle.error, size: 34)
                    : Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          onImageFailed();
                          return const Icon(Icons.receipt_long,
                              color: DistributorStyle.green);
                        },
                      ),
              ),
            ),
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

enum _ReceiptSource {
  camera('receipt_camera', Icons.photo_camera_outlined),
  gallery('receipt_gallery', Icons.photo_library_outlined),
  files('receipt_files', Icons.description_outlined);

  final String label;
  final IconData icon;

  const _ReceiptSource(this.label, this.icon);

  Future<String?> pick() async {
    if (this == _ReceiptSource.files) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'webp',
          'heic',
        ],
      );
      return result?.files.single.path;
    }
    // Compressed to stay well under the 5 MB limit.
    final photo = await ImagePicker().pickImage(
      source:
          this == _ReceiptSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 80,
    );
    return photo?.path;
  }
}
