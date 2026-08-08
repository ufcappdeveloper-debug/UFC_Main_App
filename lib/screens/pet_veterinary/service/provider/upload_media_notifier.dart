import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_service.dart';

final uploadMediaProvider =
    StateNotifierProvider<UploadMediaNotifier, AsyncValue<String?>>(
  (ref) => UploadMediaNotifier(),
);

class UploadMediaNotifier extends StateNotifier<AsyncValue<String?>> {
  UploadMediaNotifier() : super(const AsyncValue.data(null));

  Future<void> upload(File mediaFile) async {
    state = const AsyncValue.loading();

    try {
      final url = await ChatService().uploadMedia(mediaFile);
      state = AsyncValue.data(url);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
