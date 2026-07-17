// ============================================================
// features/payment/presentation/pages/cash_transfer_page.dart
// Works for BOTH partial and full payment
// ============================================================
import 'dart:typed_data';
import 'package:ecommerce_el7out/core/constants/app_constants.dart';
import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/core/service/image_picker_service.dart';
import 'package:ecommerce_el7out/core/theme/app_colors.dart';
import 'package:ecommerce_el7out/core/theme/app_spacing.dart';
import 'package:ecommerce_el7out/core/widgets/animation_premitives.dart';
import 'package:ecommerce_el7out/core/widgets/app_button.dart';
import 'package:ecommerce_el7out/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_el7out/features/payment/domain/entities/pending_order_draft.dart';
import 'package:ecommerce_el7out/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:ecommerce_el7out/features/payment/presentation/cubit/payment_state.dart';
import 'package:ecommerce_el7out/features/payment/presentation/pages/order_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashTransferPage extends StatefulWidget {
  final PendingOrderDraft draft;
  const CashTransferPage({super.key, required this.draft});

  @override
  State<CashTransferPage> createState() => _CashTransferPageState();
}

class _CashTransferPageState extends State<CashTransferPage> {
  Uint8List? _proofBytes;
  String _proofExt = 'jpg';

  bool get _isPartial => widget.draft.paymentType == PaymentType.partial;

  Future<void> _pickProof() async {
    final result = await getIt<ImagePickerService>().pickImage();
    if (result != null && mounted) {
      setState(() {
        _proofBytes = result.bytes;
        _proofExt = result.ext;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (order) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => OrderSuccessPage(order: order)),
            (r) => r.isFirst,
          ),
          error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          ),
        );
      },
      builder: (context, state) {
        final isBusy =
            state is PaymentUploadingProof || state is PaymentCreatingOrder;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _isPartial ? 'الدفع الجزئي (30٪)' : 'الدفع الكامل (100٪)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Amount breakdown ─────────────────────────
                FadeSlideIn(
                  child: _isPartial
                      ? _PartialBreakdown(draft: widget.draft)
                      : _FullBreakdown(draft: widget.draft),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Upload area ──────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    'رفع صورة إثبات الدفع',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: _ProofUploadArea(
                    proofBytes: _proofBytes,
                    onTap: _pickProof,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Instructions ─────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: _InstructionCard(isPartial: _isPartial),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Submit ───────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: AppButton(
                    label: isBusy
                        ? state is PaymentCreatingOrder
                              ? 'جارٍ إنشاء الطلب...'
                              : 'جارٍ رفع إثبات الدفع...'
                        : 'تأكيد وإرسال الطلب',
                    isLoading: isBusy,
                    onPressed: _proofBytes == null || isBusy
                        ? null
                        : () => context
                              .read<PaymentCubit>()
                              .submitCashProofAndCreateOrder(
                                proofBytes: _proofBytes!,
                                proofExt: _proofExt,
                              ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Breakdown widgets ─────────────────────────────────────────
class _PartialBreakdown extends StatelessWidget {
  final PendingOrderDraft draft;
  const _PartialBreakdown({required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B0B0A), Color(0xFF1A1200)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BreakdownCol(
                'ادفع الآن (30٪)',
                '${draft.upfrontAmount.toStringAsFixed(2)} ج.م',
                AppColors.gold,
              ),
              Container(width: 1, height: 44, color: Colors.white12),
              _BreakdownCol(
                'عند الاستلام (70٪)',
                '${draft.pendingAmount.toStringAsFixed(2)} ج.م',
                Colors.white60,
              ),
            ],
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 0.30),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 6,
                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                backgroundColor: Colors.white12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullBreakdown extends StatelessWidget {
  final PendingOrderDraft draft;
  const _FullBreakdown({required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B0B0A), Color(0xFF0A1A0A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_outlined,
            color: AppColors.success,
            size: 44,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الدفع الكامل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${draft.upfrontAmount.toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'سيتم تأكيد الطلب بعد التحقق من عملية الدفع',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _BreakdownCol(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

// ── Proof upload area ─────────────────────────────────────────
class _ProofUploadArea extends StatelessWidget {
  final Uint8List? proofBytes;
  final VoidCallback onTap;
  const _ProofUploadArea({required this.proofBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 220,
        decoration: BoxDecoration(
          color: proofBytes != null
              ? Colors.transparent
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: proofBytes != null
                ? AppColors.gold
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: proofBytes != null ? 2.0 : 1.0,
          ),
          boxShadow: proofBytes != null
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.15),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: proofBytes != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(proofBytes!, fit: BoxFit.cover),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.black.withOpacity(0.55),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.gold,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'تم رفع صورة الدفع',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 52),
                  const SizedBox(height: 12),
                  Text(
                    'اضغط لرفع صورة إثبات الدفع',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG أو PNG - يجب أن تكون الصورة واضحة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'CHOOSE FILE',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Instructions card ─────────────────────────────────────────
class _InstructionCard extends StatelessWidget {
  final bool isPartial;
  const _InstructionCard({required this.isPartial});

  @override
  Widget build(BuildContext context) {
    final steps = isPartial
        ? [
            'حوّل 30٪ من إجمالي الطلب إلى الرقم الموضح.',
            'التقط صورة واضحة لإثبات التحويل.',
            'ارفع صورة التحويل من الأعلى.',
            'سيتم مراجعة عملية الدفع خلال ساعة إلى ساعتين.',
            'يتم سداد الـ70٪ المتبقية عند الاستلام.',
          ]
        : [
            'حوّل إجمالي مبلغ الطلب إلى الرقم الموضح.',
            'التقط صورة واضحة لإثبات التحويل.',
            'ارفع صورة التحويل من الأعلى.',
            'سيتم مراجعة عملية الدفع خلال ساعة إلى ساعتين.',
            'سيتم تأكيد الطلب بعد التحقق من الدفع.',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Text(
                'طريقة الدفع',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...steps.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 8, top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: const TextStyle(
                          color: AppColors.info,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
