import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> passwordVisibility =
    StateProvider<bool>((ref) => false);
final StateProvider<bool> rePasswordVisibility =
    StateProvider<bool>((ref) => false);
