part of 'image_manager_bloc.dart';

enum ItemsStatus { initial, loading, success, failure }

class ImageManagerState extends Equatable {
  final ItemsStatus status;
  final List<ImageItem> items;
  final String? errorMessage;
  final String? successMessage;
  final int? limit;
  const ImageManagerState({
    this.status = ItemsStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.successMessage,
    this.limit,
  });

  bool get isLoading => status == ItemsStatus.loading;
  bool get isSuccess => status == ItemsStatus.success;
  bool get isFailure => status == ItemsStatus.failure;

  ImageManagerState copyWith({ItemsStatus? status, List<ImageItem>? items, String? errorMessage, String? successMessage, int? limit, bool resetSuccessMessage = false, bool resetErrorMessage = false}) => ImageManagerState(
        status: status ?? this.status,
        items: items ?? this.items,
        errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
        successMessage: resetSuccessMessage ? null : (successMessage ?? this.successMessage),
        limit: limit ?? this.limit,
      );

  @override
  List<Object?> get props => [status, items, errorMessage, successMessage, limit];
}
