import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/distributor/bank_transfer_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/distributor_repo.dart';
import 'package:ufc_mobile/screens/feed/presentation/distributor/widgets/bank_receipt_section.dart';

class _ReceiptRepository extends Fake implements DistributorRepository {
  int uploads = 0;
  final String url;

  _ReceiptRepository(this.url);

  @override
  Future<BankReceiptModel> uploadBankReceipt(int orderId, String filePath,
      {void Function(int sent, int total)? onProgress}) async {
    uploads++;
    expect(orderId, 30577);
    return BankReceiptModel(
      url: url,
      uploadedAt: '2026-11-03T16:31:00Z',
    );
  }

  @override
  Future<String?> getBankReceiptUrl(int orderId) async => url;
}

class _ReceiptPicker extends FilePicker {
  final String path;

  _ReceiptPicker(this.path);

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async =>
      FilePickerResult([PlatformFile(name: 'receipt', path: path, size: 1)]);
}

void main() {
  for (final extension in ['pdf', 'jpg']) {
    testWidgets('uploaded $extension receipt survives scrolling off screen',
        (tester) async {
      final directory = Directory.systemTemp.createTempSync('receipt-scroll-');
      final file = File('${directory.path}/receipt.$extension')
        ..writeAsBytesSync([0]);
      final repository =
          _ReceiptRepository('https://example.com/receipt.$extension');
      sl.registerSingleton<DistributorRepository>(repository);
      FilePicker.platform = _ReceiptPicker(file.path);
      final controller = ScrollController();
      addTearDown(() async {
        controller.dispose();
        await sl.unregister<DistributorRepository>();
        directory.deleteSync(recursive: true);
      });
      var changes = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            controller: controller,
            cacheExtent: 0,
            children: [
              const SizedBox(height: 1500),
              BankReceiptSection(
                orderId: 30577,
                onChanged: () => changes++,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ));
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      await tester.tap(find.text('upload_receipt'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('receipt_files'));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        // File.length() uses real asynchronous IO before the upload starts.
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(find.text('view_receipt'), findsOneWidget);
      expect(find.text('2026-11-03 19:31'), findsOneWidget);

      controller.jumpTo(0);
      await tester.pumpAndSettle();
      expect(find.text('view_receipt').hitTestable(), findsNothing);
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();

      expect(find.text('view_receipt').hitTestable(), findsOneWidget);
      expect(find.text('replace_receipt'), findsOneWidget);
      expect(find.text('upload_receipt'), findsNothing);
      expect(find.text('2026-11-03 19:31'), findsOneWidget);
      expect(repository.uploads, 1);
      expect(changes, 1);
      if (extension == 'jpg') {
        final image = tester.widget<Image>(find.byType(Image));
        expect((image.image as NetworkImage).url, repository.url);
      } else {
        expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
