import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
//     debugPrint('''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "prevValue": "$previousValue",
//   "newValue": "$newValue"
// }''');
  }
}
