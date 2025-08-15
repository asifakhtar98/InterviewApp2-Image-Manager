part of 'image_manager_bloc.dart';

sealed class ImageManagerEvent {}

class FetchItems extends ImageManagerEvent {}
class RefreshItems extends ImageManagerEvent {}

class UpdateLimit extends ImageManagerEvent {
  final int? limit; 
  UpdateLimit(this.limit);
}

class CreateItem extends ImageManagerEvent {
  final String title;
  final String description;
  final String url;
  CreateItem({required this.title, required this.description, required this.url});
}

class UpdateItem extends ImageManagerEvent {
  final ImageItem item;
  UpdateItem(this.item);
}

class DeleteItem extends ImageManagerEvent {
  final int id;
  DeleteItem(this.id);
}
