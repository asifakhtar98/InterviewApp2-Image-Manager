import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'app.dart';
import 'core/router/app_router.dart';
import 'features/image_manager/data/services/image_manager_api_service.dart';
import 'features/image_manager/data/repos/image_manager_repository.dart';
import 'core/router/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = Talker();

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationSupportDirectory()).path),
  );
  HydratedBloc.storage = storage;

  final dioClient = Dio()..interceptors.add(TalkerDioLogger(talker: talker));
  final apiService = ImageManagerApiService(dioClient);
  final imageManagerRepository = ImageManagerRepository(
    api: apiService,
    talker: talker,
  );
  final appRouter = AppRouter(talker).getRouter();
  NavigationService().init(appRouter);
  runApp(App(talker: talker, router: appRouter, repository: imageManagerRepository));
}


