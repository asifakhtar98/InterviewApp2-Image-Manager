import 'package:equatable/equatable.dart';

class ImageItem extends Equatable {
  final int id;
  final String title;
  final String description;
  final String url; 
  const ImageItem({required this.id, required this.title, required this.description, required this.url});

  ImageItem copyWith({int? id, String? title, String? description, String? url}) => ImageItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
      );

  factory ImageItem.fromJson(Map<String, dynamic> json) {

    final image = json['image'] as String? ?? json['url'] as String? ?? '';
    return ImageItem(
      id: (json['id'] is String) ? int.tryParse(json['id']) ?? 0 : (json['id'] as int? ?? 0),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: image,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': url,
      };

  @override
  List<Object?> get props => [id, title, description, url];
}
