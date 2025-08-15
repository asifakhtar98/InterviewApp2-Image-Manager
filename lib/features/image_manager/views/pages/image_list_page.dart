import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/navigation_service.dart';
import '../../bloc/image_manager_bloc.dart';
import '../../../../core/theme/theme_bloc.dart';
import '../../data/models/image_item.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';
import '../widgets/image_tile.dart';
// Removed pagination ScrollNotifier usage; using limit-based fetch instead.

class ImageItemListPage extends StatelessWidget {
  const ImageItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:  44,
        title: const Text('Interview: Image Crud',
        style: TextStyle(fontSize: 14),
        ),
        actions: [
          InkWell(
            onTap: () => context.read<ImageManagerBloc>().add(RefreshItems()),
           
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.refresh, size: 20),
            ),
          ),
          InkWell(
            onTap: () => NavigationService().push('/debug-logs'),
           
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.code, size: 20),
            ),
          ),
          BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
              return InkWell(
                onTap: () => context.read<ThemeBloc>().add(ToggleTheme()),
               
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 20),
                ),
              );
            },
          ),
        ],
      ),
  bottomNavigationBar: _NoOfItemsUi(),
      body: BlocConsumer<ImageManagerBloc, ImageManagerState>(
          listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage || prev.successMessage != curr.successMessage,
          listener: (ctx, state) {
            final scheme = Theme.of(ctx).colorScheme;
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: scheme.error,
                
                ),
              );
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: scheme.primary,
                
                ),
              );
            }
          },
          builder: (ctx, state) {
            // Trigger initial fetch only once when we have no items and status is initial
            if (state.status == ItemsStatus.initial) {
              ctx.read<ImageManagerBloc>().add(FetchItems());
              return const LoadingIndicator(label: 'Loading');
            }
            if (state.isLoading) return const LoadingIndicator(label: 'Loading');
            if (state.isFailure) {
              return ErrorView(
                message: state.errorMessage,
                onRetry: () => ctx.read<ImageManagerBloc>().add(FetchItems()),
              );
            }
            if (state.isSuccess) return _List(items: state.items);
            return const SizedBox.shrink();
          }),
    );
  }
}

class _List extends StatelessWidget {
  final List<ImageItem> items;
  const _List({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (c, i) {
        final item = items[i];
        return ItemTile(
          item: item,
          onTap: () => NavigationService().push('/image-item-detail/${item.id}'),
          onEdit: () => NavigationService().push('/edit-image-item/${item.id}'),
          onDelete: () => _confirmDelete(context, item.id),
        );
      },
      separatorBuilder: (_, __) => const SizedBox.shrink(),
      itemCount: items.length,
    );
  }

  void _confirmDelete(BuildContext context, int id) async {
    final res = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Delete this item?', style: TextStyle(fontSize: 16)),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (res == true && context.mounted) {
      context.read<ImageManagerBloc>().add(DeleteItem(id));
    }
  }
}

class _NoOfItemsUi extends StatelessWidget {
  static const List<int> _limits = [5, 10, 20, 30, 50];
  const _NoOfItemsUi();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageManagerBloc, ImageManagerState>(
      buildWhen: (p, c) => p.limit != c.limit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
           
              const Text('Total items'),
              const SizedBox(width: 8),
              DropdownButton<int?>(
                isDense: true,
                value: state.limit,
                hint: const Text('All'),
                onChanged: (val) => context.read<ImageManagerBloc>().add(UpdateLimit(val)),
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('All')),
                  ..._limits.map((l) => DropdownMenuItem<int?>(value: l, child: Text('$l'))),
                ],
              ),
              Spacer(),
              InkWell(
              
                onTap: () => NavigationService().push('/create-image-item'),
                child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
