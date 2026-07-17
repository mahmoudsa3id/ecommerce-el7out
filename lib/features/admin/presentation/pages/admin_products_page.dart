import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../presentation/cubit/admin_product_cubit.dart';
import '../../presentation/cubit/admin_product_state.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProductCubit()..loadProducts(),
      child: const _AdminProductsView(),
    );
  }
}

class _AdminProductsView extends StatefulWidget {
  const _AdminProductsView();

  @override
  State<_AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<_AdminProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await context.push(RoutePaths.adminProductAdd);

              if (result == true && context.mounted) {
                context.read<AdminProductCubit>().loadProducts();
              }
            },
          ),
        ],
      ),
      body: AnimatedPageWrapper(
        child: BlocBuilder<AdminProductCubit, AdminProductState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }
            if (state.products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              itemCount: state.products.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Card(
                  child: ListTile(
                    leading: product.imageUrls.isNotEmpty
                        ? Image.network(
                            product.imageUrls.first,
                            width: 56,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.shopping_bag_outlined),
                    title: Text(product.name),
                    subtitle: Text(
                      '${product.category} • ${product.price.toStringAsFixed(2)} ج.م',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push(
                            RoutePaths.adminProductEditPath(product.id),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, product.id),
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
    final productCubit = context.read<AdminProductCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف منتج'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا المنتج؟'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('الغاء'),
          ),
          TextButton(
            onPressed: () {
              productCubit.deleteProduct(id);
              context.pop();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
