import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // تجاهل بهدوء لو التطبيق مش متثبت أو حصل خطأ في الفتح
  }
}

int pseudoReviewCountFor(String id) {
  final hash = id.hashCode.abs();
  return 24 + (hash % 480);
}

double pseudoRatingFor(String id) {
  final hash = id.hashCode.abs();
  // نطاق من 3.6 لـ 5.0 عشان يفضل واقعي
  return 3.6 + (hash % 15) / 10.0;
}
