import 'package:flutter/material.dart';

class RouteTracker extends NavigatorObserver {
  static final RouteTracker instance = RouteTracker._();
  RouteTracker._();

  final Set<String> _uniquePagesVisited = {};
  String? _currentRoute;
  int _totalRegisteredPages = 0;

  void setTotalRegisteredPages(int count) {
    _totalRegisteredPages = count;
  }

  int get totalRegisteredPages => _totalRegisteredPages;
  int get uniquePagesVisitedCount => _uniquePagesVisited.length;
  String get currentRoute => _currentRoute ?? '-';

  void resetCounters() {
    _uniquePagesVisited.clear();
    if (_currentRoute != null) {
      _uniquePagesVisited.add(_currentRoute!);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateRoute(previousRoute);
    }
  }

  void _updateRoute(Route<dynamic> route) {
    final name = route.settings.name ?? route.settings.arguments?.toString();
    // For GoRouter, names are often in settings.name
    if (name != null && name.isNotEmpty) {
      _currentRoute = name;
      _uniquePagesVisited.add(name);
    } else {
      // Fallback for GoRouter which might not set name in settings directly
      // but usually does if configured.
    }
  }
}
