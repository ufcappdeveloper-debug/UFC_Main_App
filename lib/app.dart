import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/app_widget.dart';
import 'package:ufc_mobile/global/config/provider_observer.dart';
import 'package:ufc_mobile/global/shared/translations/codegen_loader.g.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [Logger()],
      child: EasyLocalization(
        supportedLocales: L10n.all,
        path: 'assets/translations',
        fallbackLocale: L10n.all[0],
        startLocale:
            savedLanguageIndex != null ? L10n.all[savedLanguageIndex!] : null,
        useFallbackTranslations: true,
        assetLoader: const CodegenLoader(),
        child: const App(),
      ),
    );
  }
}
