import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/di/injection.dart';
import 'package:ecommerce_el7out/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_el7out/features/category/domain/repository/category_repository.dart';
import 'package:ecommerce_el7out/features/admin/presentation/cubit/admin_category_cubit.dart';

class AdminCategoryFormPage extends StatefulWidget {
  final String? categoryId;
  const AdminCategoryFormPage({super.key, this.categoryId});

  @override
  State<AdminCategoryFormPage> createState() => _AdminCategoryFormPageState();
}

class _AdminCategoryFormPageState extends State<AdminCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController();
  String? _imageUrl;
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  bool _isEditing = false;
  String _id = '';
  bool isLoading = false;

  AdminCategoryCubit get _cubit => context.read<AdminCategoryCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _isEditing = true;
      _loadCategory(widget.categoryId!);
    }
  }

  Future<void> _loadCategory(String id) async {
    final result = await getIt<CategoryRepository>().getCategoryById(id);
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (category) {
        setState(() {
          _id = category.id;
          _nameController.text = category.name;
          _slugController.text = category.slug;
          _descriptionController.text = category.description ?? '';
          _orderController.text = category.order.toString();
          _imageUrl = category.imageUrl;
        });
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() {
      _pickedImage = image;
      _pickedImageBytes = bytes;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final slug = _slugController.text.trim();
      final description = _descriptionController.text.trim();
      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      String imageUrl = _imageUrl ?? '';
      if (_pickedImage != null) {
        final bytes = _pickedImageBytes ?? await _pickedImage!.readAsBytes();
        imageUrl = await _cubit.uploadImage(_id.isEmpty ? slug : _id, bytes);
      }

      final category = CategoryEntity(
        id: _id,
        slug: slug,
        name: name,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        description: description.isEmpty ? null : description,
        order: order,
      );

      if (_isEditing) {
        await _cubit.updateCategory(category);
      } else {
        await _cubit.addCategory(category);
      }

      if (mounted) {
        context.pop(true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'تحديث القسم' : 'إضافة قسم'),
        automaticallyImplyLeading: true,
      ),
      body: AnimatedPageWrapper(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: AppSpacing.xl),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    alignment: Alignment.center,
                    child: _pickedImageBytes != null
                        ? Image.memory(_pickedImageBytes!, fit: BoxFit.cover)
                        : _imageUrl != null
                        ? Image.network(_imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.photo_camera_outlined, size: 48),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'الاسم مطلوب' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _slugController,
                  decoration: const InputDecoration(labelText: 'الرابط'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'الرابط مطلوب' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _save,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? 'تحديث القسم' : 'إضافة قسم'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
