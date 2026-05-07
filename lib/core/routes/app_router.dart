import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dynamic_screen/dynamic_page.dart';
import '../services/auth_service.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
    redirect: (context, state) {
      final isAuthenticated = supabase.auth.currentUser != null;
      final isLoginRoute = state.uri.path == '/login';
      final isSplashRoute = state.uri.path == '/splash';

      if (!isAuthenticated && !isLoginRoute && !isSplashRoute) {
        return '/login';
      }
      
      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const DynamicPage(screenId: 'splash'),
      ),
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
