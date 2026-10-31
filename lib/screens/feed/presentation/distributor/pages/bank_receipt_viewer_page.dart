import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/distributor_style.dart';

/// Full-screen receipt image with zoom. If the signed link has expired it
/// asks for a fresh one once.
class BankReceiptViewerPage extends StatefulWidget {
  final String url;
  final Future<String?> Function() refreshUrl;

  const BankReceiptViewerPage({
    super.key,
    required this.url,
    required this.refreshUrl,
  });

  @override
  State<BankReceiptViewerPage> createState() => _BankReceiptViewerPageState();
}

class _BankReceiptViewerPageState extends State<BankReceiptViewerPage> {
  late String _url = widget.url;
  bool _refreshed = false;

  void _refresh() {
    if (_refreshed) return;
    _refreshed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final url = await widget.refreshUrl();
      if (mounted && url != null) setState(() => _url = url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('view_receipt'.tr(),
            style: DistributorStyle.style(size: 16, color: Colors.white)),
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: Image.network(
            _url,
            key: ValueKey(_url),
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : const CircularProgressIndicator(
                    color: DistributorStyle.green),
            errorBuilder: (_, __, ___) {
              _refresh();
              return Text('receipt_open_failed'.tr(),
                  style: DistributorStyle.style(color: Colors.white));
            },
          ),
        ),
      ),
    );
  }
}
