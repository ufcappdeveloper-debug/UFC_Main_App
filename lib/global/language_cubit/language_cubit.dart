import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void switchLanguage(
      {required BuildContext context, required String? localeString}) async {
    String locale = LanguageManager.normalizeLocale(localeString);
    emit(Locale(locale));
    LanguageManager.update(locale);
    context.setLocale(Locale(locale));
  }
}
