// core/services/supabase_storage_service.dart
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide StorageException;
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

@lazySingleton
class SupabaseStorageService {
  final SupabaseClient _client;
  SupabaseStorageService(this._client);

  Future<String> uploadProductImage(
    String productId,
    Uint8List bytes, {
    String ext = 'jpg',
    String? variantName,
  }) async {
    try {
      final folder = variantName == null || variantName.trim().isEmpty
          ? 'gallery'
          : 'variants/${_slug(variantName)}';
      final path =
          'product/$productId/$folder/${DateTime.now().microsecondsSinceEpoch}.$ext';
      await _client.storage
          .from(AppConstants.supabaseBucketProducts)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      return _client.storage
          .from(AppConstants.supabaseBucketProducts)
          .getPublicUrl(path);
    } catch (e) {
      throw StorageException('Image upload failed: $e');
    }
  }

  Future<String> uploadAvatar(
    String userId,
    Uint8List bytes, {
    String ext = 'jpg',
  }) async {
    try {
      final path = '$userId/avatar.$ext';
      await _client.storage
          .from(AppConstants.supabaseBucketAvatars)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      return _client.storage
          .from(AppConstants.supabaseBucketAvatars)
          .getPublicUrl(path);
    } catch (e) {
      throw StorageException('Avatar upload failed: $e');
    }
  }

  Future<void> deleteFile(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      throw StorageException('File deletion failed: $e');
    }
  }

  Future<void> deleteProductImageByUrl(String url) async {
    final path = pathFromPublicUrl(url, AppConstants.supabaseBucketProducts);
    if (path == null) return;
    await deleteFile(AppConstants.supabaseBucketProducts, path);
  }

  Future<void> deleteProductImagesByUrl(Iterable<String> urls) async {
    final paths = urls
        .map(
          (url) => pathFromPublicUrl(url, AppConstants.supabaseBucketProducts),
        )
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    if (paths.isEmpty) return;
    try {
      await _client.storage
          .from(AppConstants.supabaseBucketProducts)
          .remove(paths);
    } catch (e) {
      throw StorageException('File deletion failed: $e');
    }
  }

  Future<String> uploadPaymentProof({
    required String orderId,
    required Uint8List bytes,
    required String ext,
  }) async {
    final path =
        'proofs/$orderId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _upload(AppConstants.supabaseBucketPaymentProofs, path, bytes);
    return _publicUrl(AppConstants.supabaseBucketPaymentProofs, path);
  }

  Future<void> _upload(
    String bucket,
    String path,
    Uint8List bytes, {
    bool upsert = false,
  }) async {
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(cacheControl: '3600', upsert: upsert),
          );
    } catch (e) {
      throw StorageException('Upload failed [$bucket/$path]: $e');
    }
  }

  String _publicUrl(String bucket, String path) =>
      _client.storage.from(bucket).getPublicUrl(path);

  String? pathFromPublicUrl(String url, String bucket) {
    final marker = '/storage/v1/object/public/$bucket/';
    final index = url.indexOf(marker);
    if (index == -1) return null;
    final raw = url.substring(index + marker.length).split('?').first;
    return Uri.decodeComponent(raw);
  }

  String _slug(String value) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'color' : slug;
  }
}
