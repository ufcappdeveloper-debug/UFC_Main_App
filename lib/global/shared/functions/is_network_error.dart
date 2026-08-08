import 'package:ufc_mobile/global/util/exception/error_handler.dart';

bool isNetworkError(Object e) {
  String mesg = ErrorHandler.getErrorMessage(e)
    .toLowerCase();
  return mesg.contains('check your network') || mesg.contains('رجى التحقق من الشبكة') || mesg.contains('راہ کرم اپنے نیٹ ورک کو چیک کریں۔');
}