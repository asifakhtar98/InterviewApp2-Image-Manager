import '../models/image_item.dart';
import '../services/image_manager_api_service.dart';
import 'package:talker_flutter/talker_flutter.dart';


class ImageManagerRepository {
  final ImageManagerApiService api;
  final Talker? talker;
  ImageManagerRepository({required this.api, this.talker});

  Future<List<ImageItem>> fetchImageItems({int? limit}) async {
    try {
      return await api.getImageItems(limit: limit);
    } catch (e, st) {
      talker?.handle(e, st);
      rethrow;
    }
  }

  Future<ImageItem> createImageItem(String title, String description, String url) async {
    final temp = ImageItem(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      url: url,
    );
    try {
      return await api.createImageItem(temp);
    } catch (e, st) {
      talker?.handle(e, st);
      rethrow;
    }
  }

  Future<ImageItem> updateImageItem(ImageItem item) async {
    try {
      return await api.updateImageItem(item);
    } catch (e, st) {
      talker?.handle(e, st);
      rethrow;
    }
  }

  Future<void> deleteImageItem(int id) async {
    try {
      await api.deleteImageItem(id);
    } catch (e, st) {
      talker?.handle(e, st);
      rethrow;
    }
  }
}
