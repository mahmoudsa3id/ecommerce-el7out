// ============================================================
// core/services/image_picker_service.dart
// ============================================================
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<({Uint8List bytes, String ext})?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 80,
  }) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (file == null) return null;
      final bytes = await file.readAsBytes();
      final ext = file.name.split('.').last.toLowerCase();
      return (bytes: bytes, ext: ext);
    } catch (_) {
      return null;
    }
  }
}
