import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../features/image_manager/views/pages/image_list_page.dart';
import '../../features/image_manager/views/pages/image_detail_page.dart';
import '../../features/image_manager/views/pages/image_form_page.dart';

class AppRouter {
  final Talker talker;
  AppRouter(this.talker);
  
  GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const ImageItemListPage()),
        GoRoute(path: '/create-image-item', builder: (_, __) => const ImageItemFormView()),
        GoRoute(path: '/image-item-detail/:id', builder: (ctx, st) => ImageItemDetailPage(id: int.parse(st.pathParameters['id']!))),
        GoRoute(path: '/edit-image-item/:id', builder: (ctx, st) => ImageItemFormView(editableImageId: int.parse(st.pathParameters['id']!))),
        GoRoute(path: '/debug-logs', builder: (_, __) => TalkerScreen(
          appBarTitle: 'Logs',
          talker: talker)),
      ],
    );
  }
}
