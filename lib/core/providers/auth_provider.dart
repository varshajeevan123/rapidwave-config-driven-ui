import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? user;

  AuthState({required this.isLoggedIn, this.user});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initial state: Not logged in
    return AuthState(isLoggedIn: false);
  }

  void login(String username) {
    state = AuthState(isLoggedIn: true, user: username);
  }

  void logout() {
    state = AuthState(isLoggedIn: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
