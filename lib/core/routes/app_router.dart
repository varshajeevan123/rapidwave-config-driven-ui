import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dynamic_screen/dynamic_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const DynamicPage(screenId: 'login'),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DynamicPage(screenId: 'dashboard'),
      ),
    ],
  );
});
