// features/auth/presentation/pages/auth_gate_page.dart
import 'package:ecommerce_el7out/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Premium checkout-first auth gate.
/// Shown when a guest tries to access a protected route.
/// Preserves cart, wishlist, and redirects back after login.
class AuthGatePage extends StatefulWidget {
  final String redirectPath;
  final int initialTabIndex;
  const AuthGatePage({
    super.key,
    required this.redirectPath,
    this.initialTabIndex = 0,
  });

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final _siEmail = TextEditingController();
  final _siPassword = TextEditingController();
  final _suName = TextEditingController();
  final _suEmail = TextEditingController();
  final _suPassword = TextEditingController();
  bool _siObscure = true;
  bool _suObscure = true;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    )..addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _siEmail.dispose();
    _siPassword.dispose();
    _suName.dispose();
    _suEmail.dispose();
    _suPassword.dispose();
    super.dispose();
  }

  Future<void> _onAuthenticated() async {
    if (_redirecting) return;
    _redirecting = true;
    try {
      await getIt<CartCubit>().mergeGuestCart();
    } catch (_) {
      // Do not block checkout navigation if local cart merge fails.
    }
    if (!mounted) return;
    context.go(widget.redirectPath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              authenticated: (_) => _onAuthenticated(),
            );
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final cubit = context.read<AuthCubit>();
            final pagePadding = ResponsiveLayout.horizontalPadding(context);

            return SafeArea(
              child: AnimatedPageWrapper(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: pagePadding,
                              vertical: AppSpacing.md,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _AuthGateHeader(),
                                const SizedBox(height: AppSpacing.xl),
                                _StyledTabBar(controller: _tabController),
                                const SizedBox(height: AppSpacing.xl),
                                _AnimatedTabView(
                                  controller: _tabController,
                                  signInChild: _SignInForm(
                                    formKey: _signInFormKey,
                                    emailController: _siEmail,
                                    passwordController: _siPassword,
                                    obscure: _siObscure,
                                    isLoading: isLoading,
                                    onToggleObscure: () => setState(
                                      () => _siObscure = !_siObscure,
                                    ),
                                    onSubmit: () {
                                      if (_signInFormKey.currentState
                                              ?.validate() ??
                                          false) {
                                        cubit.signIn(
                                          email: _siEmail.text,
                                          password: _siPassword.text,
                                        );
                                      }
                                    },
                                  ),
                                  signUpChild: _SignUpForm(
                                    formKey: _signUpFormKey,
                                    nameController: _suName,
                                    emailController: _suEmail,
                                    passwordController: _suPassword,
                                    obscure: _suObscure,
                                    isLoading: isLoading,
                                    onToggleObscure: () => setState(
                                      () => _suObscure = !_suObscure,
                                    ),
                                    onSubmit: () {
                                      if (_signUpFormKey.currentState
                                              ?.validate() ??
                                          false) {
                                        cubit.signUp(
                                          email: _suEmail.text,
                                          password: _suPassword.text,
                                          fullName: _suName.text,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xxl),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthGateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            l10n.completeYourOrder.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.signInToContinue,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.signInSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _StyledTabBar extends StatelessWidget {
  final TabController controller;
  const _StyledTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(7),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.surface,
        unselectedLabelColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.5),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
        tabs: [
          Tab(text: context.l10n.signIn.toUpperCase()),
          Tab(text: context.l10n.register.toUpperCase()),
        ],
      ),
    );
  }
}

class _AnimatedTabView extends StatelessWidget {
  final TabController controller;
  final Widget signInChild;
  final Widget signUpChild;

  const _AnimatedTabView({
    required this.controller,
    required this.signInChild,
    required this.signUpChild,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: KeyedSubtree(
          key: ValueKey(controller.index),
          child: controller.index == 0 ? signInChild : signUpChild,
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            label: l10n.email,
            hint: 'you@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline,
            validator: (v) =>
                (v == null || !v.contains('@')) ? l10n.validEmail : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.password,
            controller: passwordController,
            obscureText: obscure,
            prefixIcon: Icons.lock_outline,
            textInputAction: TextInputAction.done,
            suffix: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggleObscure,
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? l10n.passwordLength : null,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: l10n.signInAndContinue.toUpperCase(),
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _SignUpForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            label: l10n.fullName,
            controller: nameController,
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().length < 2) ? l10n.nameLength : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.email,
            hint: 'you@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline,
            validator: (v) =>
                (v == null || !v.contains('@')) ? l10n.validEmail : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.password,
            controller: passwordController,
            obscureText: obscure,
            prefixIcon: Icons.lock_outline,
            textInputAction: TextInputAction.done,
            suffix: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggleObscure,
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? l10n.passwordLength : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.createAccountAction.toUpperCase(),
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
