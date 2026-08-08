import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PreviewPdfScreen extends StatefulWidget {
  const PreviewPdfScreen({
    super.key,
    required this.tag,
    required this.pdfUrl,
  });

  final Object tag;
  final String pdfUrl;

  @override
  State<PreviewPdfScreen> createState() => _PreviewPdfScreenState();
}

class _PreviewPdfScreenState extends State<PreviewPdfScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes, flush: true);
      setState(() => localPath = file.path);
    } catch (e) {
      debugPrint('Failed to download PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: _buildPreviewPdfAppBar,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Hero(
                    tag: widget.tag,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: localPath == null
                          ? Center(child: CircularProgressIndicator())
                          : PDFView(
                              filePath: localPath!,
                              enableSwipe: true,
                              swipeHorizontal: false,
                              autoSpacing: true,
                              pageFling: true,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar get _buildPreviewPdfAppBar => AppBar(
        centerTitle: true,
        toolbarHeight: 78,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackButton(),
            const SizedBox(width: 48, height: 48),
            _buildDownloadButton(),
          ],
        ),
      );

  Widget _buildBackButton() {
    return Container(
      width: 48,
      height: 48,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          splashColor: Colors.grey.withOpacity(0.11),
          highlightColor: Colors.grey.withOpacity(0.11),
          borderRadius: BorderRadius.circular(111),
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      width: 48,
      height: 48,
      child: InkResponse(
        onTap: () async {
          try {
            final response = await http.get(Uri.parse(widget.pdfUrl));
            final dir = await getExternalStorageDirectory();
            final file = File('${dir!.path}/downloaded_file.pdf');
            await file.writeAsBytes(response.bodyBytes, flush: true);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Downloaded successfully")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Download failed")),
            );
          }
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.grey.withOpacity(0.11),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: const Icon(Icons.download_rounded),
        ),
      ),
    );
  }
}
