import 'package:go_router/go_router.dart';


class NavigationService {
  NavigationService._internal();
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;

  late GoRouter _router;
  bool _initialized = false;

  void init(GoRouter router) {
    if (_initialized) return; 
    _router = router;
    _initialized = true;
  }

  GoRouter get router => _router;

  void go(String location, {Object? extra}) => _router.go(location, extra: extra);
  Future<T?> push<T>(String location, {Object? extra}) => _router.push<T>(location, extra: extra);
  void pop<T extends Object?>([T? result]) => _router.pop(result);
}
