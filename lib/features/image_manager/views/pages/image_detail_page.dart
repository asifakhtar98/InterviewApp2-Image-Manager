import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/image_manager_bloc.dart';

class ImageItemDetailPage extends StatelessWidget {
  final int id;
  const ImageItemDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final item = context.select((ImageManagerBloc b) => b.state.items.firstWhere((e) => e.id == id));
    return Scaffold(
      appBar: AppBar(title: Text('Item ${item.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Hero(
              tag: 'imageItem-${item.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.url,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 120),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(item.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
