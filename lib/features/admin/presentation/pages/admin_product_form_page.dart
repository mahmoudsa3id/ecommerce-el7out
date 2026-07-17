import 'dart:typed_data';

import 'package:ecommerce_el7out/core/di/injection.dart';
import 'package:ecommerce_el7out/features/admin/presentation/cubit/admin_product_cubit.dart';
import 'package:ecommerce_el7out/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_el7out/features/product/domain/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';

class AdminProductFormPage extends StatefulWidget {
  final String? productId;

  const AdminProductFormPage({super.key, this.productId});

  @override
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _compareAtPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  final List<_EditableImage> _gallery = [];
  final List<_EditableVariant> _variants = [];
  final Set<String> _originalImageUrls = {};

  String _id = '';
  bool _isEditing = false;
  bool _isLoading = false;

  AdminProductCubit get _cubit => context.read<AdminProductCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _isEditing = true;
      _loadProduct(widget.productId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _compareAtPriceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct(String id) async {
    final result = await getIt<ProductRepository>().getProductById(id);
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (product) {
        setState(() {
          _id = product.id;
          _nameController.text = product.name;
          _brandController.text = product.brand;
          _priceController.text = product.price.toString();
          _compareAtPriceController.text =
              product.compareAtPrice?.toString() ?? '';
          _categoryController.text = product.category;
          _descriptionController.text = product.description;
          _gallery
            ..clear()
            ..addAll(product.imageUrls.map(_EditableImage.remote));
          _variants
            ..clear()
            ..addAll(
              product.variants.isNotEmpty
                  ? product.variants.map(_EditableVariant.fromEntity)
                  : product.colors.map(
                      (color) => _EditableVariant(
                        colorName: color,
                        colorHex: '#111111',
                        sizes: product.sizes
                            .map(
                              (size) => VariantSizeStockEntity(
                                size: size,
                                stock: product.inStock ? 1 : 0,
                              ),
                            )
                            .toList(),
                      ),
                    ),
            );
          _originalImageUrls
            ..clear()
            ..addAll(product.imageUrls)
            ..addAll(product.variants.expand((variant) => variant.imageUrls));
        });
      },
    );
  }

  Future<void> _pickGalleryImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 82);
    if (images.isEmpty) return;
    final picked = <_EditableImage>[];
    for (final image in images) {
      picked.add(_EditableImage.local(image, await image.readAsBytes()));
    }
    setState(() => _gallery.addAll(picked));
  }

  Future<void> _pickVariantImages(_EditableVariant variant) async {
    final images = await _picker.pickMultiImage(imageQuality: 82);
    if (images.isEmpty) return;
    final picked = <_EditableImage>[];
    for (final image in images) {
      picked.add(_EditableImage.local(image, await image.readAsBytes()));
    }
    setState(() => variant.images.addAll(picked));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final productId = _id.isEmpty ? _storageIdFromName(name) : _id;
      final uploadedGallery = await _uploadImages(productId, _gallery);
      final variants = <ProductVariantEntity>[];

      for (final variant in _variants) {
        final uploadedImages = await _uploadImages(
          productId,
          variant.images,
          colorName: variant.colorName,
        );
        variants.add(
          ProductVariantEntity(
            colorName: variant.colorName.trim(),
            colorHex: _normalizedHex(variant.colorHex),
            imageUrls: uploadedImages,
            sizes: variant.sizes
                .where((item) => item.size.trim().isNotEmpty)
                .map(
                  (item) => VariantSizeStockEntity(
                    size: item.size.trim(),
                    stock: item.stock < 0 ? 0 : item.stock,
                  ),
                )
                .toList(),
          ),
        );
      }

      final orderedImages = uploadedGallery.isNotEmpty
          ? uploadedGallery
          : variants.expand((variant) => variant.imageUrls).toList();
      final flattenedSizes = variants
          .expand((variant) => variant.sizes.map((item) => item.size))
          .toSet()
          .toList();
      final removedUrls = _originalImageUrls.difference({
        ...orderedImages,
        ...variants.expand((variant) => variant.imageUrls),
      });

      final product = ProductEntity(
        id: _id,
        name: name,
        brand: _brandController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        compareAtPrice: double.tryParse(_compareAtPriceController.text.trim()),
        imageUrls: orderedImages,
        variants: variants,
        category: _categoryController.text.trim(),
        sizes: flattenedSizes,
        colors: variants.map((variant) => variant.colorName).toList(),
        rating: 0,
        reviewCount: 0,
        description: _descriptionController.text.trim(),
        isNew: !_isEditing,
        inStock: variants.isEmpty || variants.any((variant) => variant.inStock),
      );

      if (_isEditing) {
        await _cubit.updateProduct(product);
      } else {
        await _cubit.addProduct(product);
      }
      await _cubit.deleteProductImages(removedUrls);

      if (mounted) context.pop(true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<List<String>> _uploadImages(
    String productId,
    List<_EditableImage> images, {
    String? colorName,
  }) async {
    final urls = <String>[];
    for (final image in images) {
      if (image.url != null) {
        urls.add(image.url!);
      } else if (image.bytes != null) {
        final url = colorName == null
            ? await _cubit.uploadProductImage(productId, image.bytes!)
            : await _cubit.uploadVariantImage(
                productId,
                colorName,
                image.bytes!,
              );
        urls.add(url);
      }
    }
    return urls;
  }

  void _addVariant() {
    setState(
      () => _variants.add(
        _EditableVariant(
          colorName: 'لون جديد',
          colorHex: '#111111',
          expanded: true,
        ),
      ),
    );
  }

  String _storageIdFromName(String name) {
    final slug = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : slug;
  }

  String _normalizedHex(String value) {
    final cleaned = value.trim().replaceFirst('#', '').toUpperCase();
    if (RegExp(r'^[0-9A-F]{6}$').hasMatch(cleaned)) return '#$cleaned';
    return '#111111';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'تعديل المنتج' : 'إضافة منتج')),
      body: AnimatedPageWrapper(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(
                title: 'الوسائط',
                actionLabel: 'إضافة صور',
                onAction: _pickGalleryImages,
              ),
              _ImageManager(
                images: _gallery,
                onAdd: _pickGalleryImages,
                onRemove: (image) => setState(() => _gallery.remove(image)),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final image = _gallery.removeAt(oldIndex);
                    _gallery.insert(newIndex, image);
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProductFields(
                nameController: _nameController,
                brandController: _brandController,
                priceController: _priceController,
                compareAtPriceController: _compareAtPriceController,
                categoryController: _categoryController,
                descriptionController: _descriptionController,
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionHeader(
                title: 'المتغيرات',
                actionLabel: 'إضافة لون',
                onAction: _addVariant,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: Column(
                  children: _variants
                      .map(
                        (variant) => _VariantCard(
                          key: ObjectKey(variant),
                          variant: variant,
                          onChanged: () => setState(() {}),
                          onDelete: () =>
                              setState(() => _variants.remove(variant)),
                          onAddImages: () => _pickVariantImages(variant),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isEditing ? 'تحديث المنتج' : 'إنشاء المنتج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController priceController;
  final TextEditingController compareAtPriceController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;

  const _ProductFields({
    required this.nameController,
    required this.brandController,
    required this.priceController,
    required this.compareAtPriceController,
    required this.categoryController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'اسم المنتج'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'مطلوب' : null,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: brandController,
          decoration: const InputDecoration(labelText: 'العلامة التجارية'),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'السعر (ج.م)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'مطلوب' : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                controller: compareAtPriceController,
                decoration: const InputDecoration(
                  labelText: 'السعر قبل الخصم (ج.م)',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: categoryController,
          decoration: const InputDecoration(labelText: 'القسم'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'مطلوب' : null,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: 'الوصف'),
          minLines: 3,
          maxLines: 5,
        ),
      ],
    );
  }
}

class _VariantCard extends StatelessWidget {
  final _EditableVariant variant;
  final VoidCallback onChanged;
  final VoidCallback onDelete;
  final VoidCallback onAddImages;

  const _VariantCard({
    super.key,
    required this.variant,
    required this.onChanged,
    required this.onDelete,
    required this.onAddImages,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: _ColorDot(hex: variant.colorHex),
            title: Text(variant.colorName),
            subtitle: Text(
              '${variant.images.length} صورة • ${variant.sizes.length} مقاس',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    variant.expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    variant.expanded = !variant.expanded;
                    onChanged();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
              ],
            ),
            onTap: () {
              variant.expanded = !variant.expanded;
              onChanged();
            },
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 240),
            crossFadeState: variant.expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: variant.colorName,
                          decoration: const InputDecoration(
                            labelText: 'اسم اللون',
                          ),
                          onChanged: (value) {
                            variant.colorName = value;
                            onChanged();
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          initialValue: variant.colorHex,
                          decoration: const InputDecoration(
                            labelText: 'كود اللون',
                          ),
                          onChanged: (value) {
                            variant.colorHex = value;
                            onChanged();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ImageManager(
                    images: variant.images,
                    onAdd: onAddImages,
                    onRemove: (image) {
                      variant.images.remove(image);
                      onChanged();
                    },
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      final image = variant.images.removeAt(oldIndex);
                      variant.images.insert(newIndex, image);
                      onChanged();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SizeStockEditor(variant: variant, onChanged: onChanged),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeStockEditor extends StatelessWidget {
  final _EditableVariant variant;
  final VoidCallback onChanged;

  const _SizeStockEditor({required this.variant, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...variant.sizes.map(
            (size) => InputChip(
              label: Text('${size.size} (${size.stock})'),
              selected: size.stock > 0,
              onPressed: () => _editSize(context, size),
              onDeleted: () {
                variant.sizes.remove(size);
                onChanged();
              },
            ),
          ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: const Text('إضافة مقاس'),
            onPressed: () => _editSize(context, null),
          ),
        ],
      ),
    );
  }

  Future<void> _editSize(
    BuildContext context,
    VariantSizeStockEntity? current,
  ) async {
    final sizeController = TextEditingController(text: current?.size ?? '');
    final stockController = TextEditingController(
      text: current?.stock.toString() ?? '0',
    );
    final result = await showDialog<VariantSizeStockEntity>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(current == null ? 'إضافة مقاس' : 'تعديل مقاس'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sizeController,
              decoration: const InputDecoration(labelText: 'المقاس'),
              textCapitalization: TextCapitalization.characters,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'الكمية'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: context.pop, child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              final size = sizeController.text.trim();
              if (size.isEmpty) return;
              context.pop(
                VariantSizeStockEntity(
                  size: size,
                  stock: int.tryParse(stockController.text.trim()) ?? 0,
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (result == null) return;
    if (current != null) variant.sizes.remove(current);
    variant.sizes.add(result);
    onChanged();
  }
}

class _ImageManager extends StatelessWidget {
  final List<_EditableImage> images;
  final VoidCallback onAdd;
  final ValueChanged<_EditableImage> onRemove;
  final ReorderCallback onReorder;

  const _ImageManager({
    required this.images,
    required this.onAdd,
    required this.onRemove,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: images.length + 1,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex >= images.length || newIndex > images.length) return;
          onReorder(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          if (index == images.length) {
            return _AddImageCard(
              key: const ValueKey('add-image'),
              onTap: onAdd,
            );
          }
          final image = images[index];
          return _ImageTile(
            key: ObjectKey(image),
            index: index,
            image: image,
            onRemove: () => onRemove(image),
          );
        },
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final int index;
  final _EditableImage image;
  final VoidCallback onRemove;

  const _ImageTile({
    super.key,
    required this.index,
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.bytes != null
                  ? Image.memory(image.bytes!, fit: BoxFit.cover)
                  : Image.network(image.url!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 6,
            top: 6,
            child: ReorderableDragStartListener(
              index: index,
              child: const _RoundIcon(icon: Icons.drag_indicator),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: GestureDetector(
              onTap: onRemove,
              child: const _RoundIcon(icon: Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddImageCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 112,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Icon(Icons.add_photo_alternate_outlined, size: 34),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;

  const _RoundIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final String hex;

  const _ColorDot({required this.hex});

  @override
  Widget build(BuildContext context) {
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return CircleAvatar(
      backgroundColor: Color((value ?? 0x111111) | 0xFF000000),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _EditableImage {
  final String? url;
  final XFile? file;
  final Uint8List? bytes;

  const _EditableImage.remote(this.url) : file = null, bytes = null;

  const _EditableImage.local(this.file, this.bytes) : url = null;
}

class _EditableVariant {
  String colorName;
  String colorHex;
  final List<_EditableImage> images;
  final List<VariantSizeStockEntity> sizes;
  bool expanded;

  _EditableVariant({
    required this.colorName,
    required this.colorHex,
    List<_EditableImage>? images,
    List<VariantSizeStockEntity>? sizes,
    this.expanded = false,
  }) : images = images ?? [],
       sizes = sizes ?? [];

  factory _EditableVariant.fromEntity(ProductVariantEntity entity) {
    return _EditableVariant(
      colorName: entity.colorName,
      colorHex: entity.colorHex,
      images: entity.imageUrls.map(_EditableImage.remote).toList(),
      sizes: [...entity.sizes],
    );
  }
}
