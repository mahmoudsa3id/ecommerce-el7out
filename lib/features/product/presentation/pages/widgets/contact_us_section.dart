import 'package:ecommerce_el7out/core/helper/helpers.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/features/product/presentation/pages/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';

const String _kWhatsAppNumber = '201031722276';
const String _kFacebookUrl = 'https://www.facebook.com/el7oot01';
const String _kInstagramUrl = 'https://instagram.com/el7ot2024';
const String _kTiktokUrl = 'https://tiktok.com/@el7owt2';
const String _kTelegramUrl = 'https://t.me/el7out22';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF0B0B0A), Color(0xFF201F1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تواصل معنا',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'تابعونا على السوشيال ميديا أو راسلونا على واتساب',
              style: TextStyle(color: Colors.white60, fontSize: 12.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                SocialIconButton(
                  icon: Icons.chat_bubble,
                  color: const Color(0xFF25D366),
                  label: 'واتساب',
                  onTap: () => openUrl('https://wa.me/$_kWhatsAppNumber'),
                ),
                SocialIconButton(
                  icon: Icons.facebook,
                  color: const Color.fromARGB(255, 22, 2, 138),
                  label: 'فيسبوك',
                  onTap: () => openUrl(_kFacebookUrl),
                ),
                SocialIconButton(
                  icon: Icons.telegram,
                  color: const Color(0xFF1897F2),
                  label: 'تليجرام',
                  onTap: () => openUrl(_kTelegramUrl),
                ),
                SocialIconButton(
                  icon: Icons.camera_alt_rounded,
                  color: const Color.fromARGB(255, 161, 14, 112),
                  label: 'انستجرام',
                  onTap: () => openUrl(_kInstagramUrl),
                ),
                SocialIconButton(
                  icon: Icons.music_note_rounded,
                  color: const Color.fromARGB(255, 223, 23, 89),
                  label: 'تيك توك',
                  onTap: () => openUrl(_kTiktokUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Glow Button — الزرار المتوهج المستخدم داخل الكاروسيل المدمج
// ══════════════════════════════════════════════════════════════
