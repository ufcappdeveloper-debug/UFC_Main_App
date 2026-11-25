import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Where downloaded invoices are saved before being opened.
///
/// Android 10+ (scoped storage) refuses to create files directly in the
/// public `/storage/emulated/0/Download` folder ("Permission denied,
/// errno = 13") even though the folder exists. The app's own storage needs
/// no permission and `OpenFilex` can still open files from it.
class InvoiceFile {
  InvoiceFile._();

  static Future<String> pathFor(Object orderId) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    }
    dir ??= await getApplicationDocumentsDirectory();
    return '${dir.path}/$orderId-invoice.pdf';
  }
}
