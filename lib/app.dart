import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'features/image_manager/bloc/image_manager_bloc.dart';
import 'features/image_manager/data/repos/image_manager_repository.dart';
import 'core/theme/theme_bloc.dart';

class App extends StatelessWidget {
  final Talker talker;
  final GoRouter router;
  final ImageManagerRepository repository;
  const App({super.key, required this.talker, required this.router, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImageManagerBloc>(
          create: (_) => ImageManagerBloc(repository: repository, talker: talker)..add(FetchItems()),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            themeMode: mode,
            theme: ThemeData(colorSchemeSeed: Colors.green, brightness: Brightness.light, useMaterial3: true),
            darkTheme: ThemeData(colorSchemeSeed: Colors.green, brightness: Brightness.dark, useMaterial3: true),
          );
        },
      ),
    );
  }
}
