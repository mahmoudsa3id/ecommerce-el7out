import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../presentation/cubit/admin_category_cubit.dart';
import '../../presentation/cubit/admin_category_state.dart';

class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCategoryCubit()..loadCategories(),
      child: const _AdminCategoriesView(),
    );
  }
}

class _AdminCategoriesView extends StatefulWidget {
  const _AdminCategoriesView();

  @override
  State<_AdminCategoriesView> createState() => _AdminCategoriesViewState();
}

class _AdminCategoriesViewState extends State<_AdminCategoriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاقسام'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push(RoutePaths.adminCategoryAdd);

              if (result == true && context.mounted) {
                context.read<AdminCategoryCubit>().loadCategories();
              }
            },
          ),
        ],
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }
            if (state.categories.isEmpty) {
              return const Center(child: Text('لا توجد اقسام'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              itemCount: state.categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Card(
                  child: ListTile(
                    leading: category.imageUrl != null
                        ? Image.network(
                            category.imageUrl!,
                            width: 56,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.category_outlined),
                    title: Text(category.name),
                    subtitle: Text(category.description ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push(
                            RoutePaths.adminCategoryEditPath(category.id),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, category.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    final cubit = context.read<AdminCategoryCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف القسم'),
        content: const Text('هل أنت متأكد؟'),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteCategory(id);
              dialogContext.pop();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
