import 'package:flutter/material.dart';
import '../../data/models/image_item.dart';
class ItemTile extends StatelessWidget {
  final ImageItem item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const ItemTile({super.key, required this.item, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
   
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Hero(
                tag: 'imageItem-${item.id}',
                // Flight should keep a solid background to avoid flicker on transparent images
                flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                  // Use a FadeTransition on flight for subtle effect
                  return FadeTransition(
                    opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
                    child: toHeroContext.widget,
                  );
                },
                child: Image.network(
                  item.url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                   
                        PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'edit') onEdit?.call();
                            if (v == 'delete') onDelete?.call();
                          },
                          itemBuilder: (_) => [
                            if (onEdit != null)
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            if (onDelete != null)
                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                    ],
                  ),
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
