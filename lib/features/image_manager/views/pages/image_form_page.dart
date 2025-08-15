import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/navigation_service.dart';
import '../../bloc/image_manager_bloc.dart';

class ImageItemFormView extends StatefulWidget {
  final int? editableImageId;
  const ImageItemFormView({super.key, this.editableImageId});

  @override
  State<ImageItemFormView> createState() => _ImageItemFormViewState();
}

class _ImageItemFormViewState extends State<ImageItemFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _url;

  @override
  void initState() {
    super.initState();
    if (widget.editableImageId != null) {
      final item = context.read<ImageManagerBloc>().state.items.firstWhere((e) => e.id == widget.editableImageId);
      _title = TextEditingController(text: item.title);
      _description = TextEditingController(text: item.description);
      _url = TextEditingController(text: item.url);
    } else {
      _title = TextEditingController();
      _description = TextEditingController();
      _url = TextEditingController(text: 'https://dxvbdpxfzdpgiscphujy.supabase.co/storage/v1/object/public/assets/team/asif_akhtar_flutter.jpg');
    }
  }

  @override
  void dispose() {
  _title.dispose();
  _description.dispose();
  _url.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (widget.editableImageId == null) {
      context.read<ImageManagerBloc>().add(CreateItem(title: _title.text.trim(), description: _description.text.trim(), url: _url.text.trim()));
    } else {
      final bloc = context.read<ImageManagerBloc>();
      final item = bloc.state.items.firstWhere((e) => e.id == widget.editableImageId);
      bloc.add(UpdateItem(item.copyWith(title: _title.text.trim(), description: _description.text.trim(), url: _url.text.trim())));
    }
  NavigationService().pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editableImageId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit' : 'Create')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _url,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text(isEdit ? 'Save' : 'Create')),
            ],
          ),
        ),
      ),
    );
  }
}
