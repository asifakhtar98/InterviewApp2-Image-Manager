import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../data/models/image_item.dart';
import '../data/repos/image_manager_repository.dart';

part 'image_manager_event.dart';
part 'image_manager_state.dart';

class ImageManagerBloc extends HydratedBloc<ImageManagerEvent, ImageManagerState> {
  final ImageManagerRepository repository;
  final Talker talker;
  ImageManagerBloc({required this.repository, required this.talker}) : super(const ImageManagerState()) {
    on<FetchItems>(_onFetch);
    on<RefreshItems>(_onRefresh);
  on<UpdateLimit>(_onUpdateLimit);
    on<CreateItem>(_onCreate);
    on<UpdateItem>(_onUpdate);
    on<DeleteItem>(_onDelete);
  }

  Future<void> _onFetch(FetchItems event, Emitter<ImageManagerState> emit) async {
    if (state.status == ItemsStatus.loading) return;
  
  emit(state.copyWith(status: ItemsStatus.loading, resetSuccessMessage: true, resetErrorMessage: true));
    try {
  final items = await repository.fetchImageItems(limit: state.limit);
  emit(state.copyWith(status: ItemsStatus.success, items: items, successMessage: 'Loaded ${items.length} items', resetErrorMessage: true));
    } catch (e, st) {
      talker.handle(e, st);
      emit(state.copyWith(status: ItemsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshItems event, Emitter<ImageManagerState> emit) async {
    add(FetchItems());
  }

  Future<void> _onUpdateLimit(UpdateLimit event, Emitter<ImageManagerState> emit) async {

  emit(state.copyWith(limit: event.limit, resetSuccessMessage: true, resetErrorMessage: true));
    add(FetchItems());
  }

  Future<void> _onCreate(CreateItem event, Emitter<ImageManagerState> emit) async {
    try {
      final created = await repository.createImageItem(event.title, event.description, event.url);
      final updated = [created, ...state.items];
      emit(state.copyWith(items: updated, successMessage: 'Item created', resetErrorMessage: true));
    } catch (e, st) {
      talker.handle(e, st);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateItem event, Emitter<ImageManagerState> emit) async {
    try {
      final updatedItem = await repository.updateImageItem(event.item);
      final list = state.items.map((i) => i.id == updatedItem.id ? updatedItem : i).toList();
  emit(state.copyWith(items: list, successMessage: 'Item updated', resetErrorMessage: true));
    } catch (e, st) {
      talker.handle(e, st);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(DeleteItem event, Emitter<ImageManagerState> emit) async {
    try {
      await repository.deleteImageItem(event.id);
      final list = state.items.where((i) => i.id != event.id).toList();
  emit(state.copyWith(items: list, successMessage: 'Item deleted', resetErrorMessage: true));
    } catch (e, st) {
      talker.handle(e, st);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  ImageManagerState? fromJson(Map<String, dynamic> json) {
    try {
      final itemsJson = (json['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();
      final items = itemsJson.map(ImageItem.fromJson).toList();
      final limit = json['limit'] as int?;
 
      final status = items.isEmpty ? ItemsStatus.initial : ItemsStatus.success;
      return ImageManagerState(status: status, items: items, limit: limit);
    } catch (_) {
      return const ImageManagerState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ImageManagerState state) {
    return {
      'items': state.items.map((e) => e.toJson()).toList(),
      'limit': state.limit,
    };
  }
}
