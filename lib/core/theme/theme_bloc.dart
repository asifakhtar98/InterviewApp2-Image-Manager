import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


abstract class ThemeEvent {}
class ToggleTheme extends ThemeEvent {}
class SetThemeMode extends ThemeEvent {
  final ThemeMode mode;
  SetThemeMode(this.mode);
}

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system) {
    on<ToggleTheme>(_onToggle);
    on<SetThemeMode>(_onSetMode);
  }

  void _onToggle(ToggleTheme event, Emitter<ThemeMode> emit) {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void _onSetMode(SetThemeMode event, Emitter<ThemeMode> emit) => emit(event.mode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final value = json['mode'] as String?;
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    final map = {
      ThemeMode.light: 'light',
      ThemeMode.dark: 'dark',
      ThemeMode.system: 'system',
    };
    return {'mode': map[state]};
  }
}
