import 'package:dio/dio.dart';
import '../models/image_item.dart';

class ImageManagerApiService {
  final Dio dio;
  ImageManagerApiService(this.dio) {
    dio.options = dio.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  static const _baseImageApiUrl = 'https://fakestoreapi.com';

  Future<List<ImageItem>> getImageItems({int? limit}) async {
    final query = limit != null ? '?limit=$limit' : '';
    final res = await dio.get('$_baseImageApiUrl/products$query');
    final data = res.data as List<dynamic>;
    return data.map((e) => ImageItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ImageItem> createImageItem(ImageItem draft) async {
    final payload = {
      'title': draft.title,
      'price': 0.0,
      'description': draft.description.isNotEmpty ? draft.description : draft.title,
      'image': draft.url,
      'category': 'general',
    };
    final res = await dio.post('$_baseImageApiUrl/products', data: payload);
    final json = res.data as Map<String, dynamic>;
    return draft.copyWith(id: (json['id'] is int) ? json['id'] as int : draft.id);
  }

  Future<ImageItem> updateImageItem(ImageItem item) async {
    final payload = {
      'id': item.id,
      'title': item.title,
      'price': 0.0,
      'description': item.description.isNotEmpty ? item.description : item.title,
      'image': item.url,
      'category': 'general',
    };
    await dio.put('$_baseImageApiUrl/products/${item.id}', data: payload);
    return item;
  }

  Future<void> deleteImageItem(int id) async {
    await dio.delete('$_baseImageApiUrl/products/$id');
  }
}
