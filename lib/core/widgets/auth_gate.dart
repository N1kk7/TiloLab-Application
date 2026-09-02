import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../layouts/index_layout.dart';
import '../../store/onboarding_store.dart';
import '../theme/app_colors.dart';

enum _StartDestination { home, authOnly, onboarding }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<_StartDestination> _resolution = _resolve();

  StreamSubscription<AuthState>? _authSubscription;

  Future<_StartDestination> _resolve() async {
    final auth = Supabase.instance.client.auth;

    // Ждём, пока supabase_flutter завершит попытку відновити/оновити
    // сесію з диска. Це асинхронний процес: initialize() кладе стару
    // сесію в currentSession одразу, але реальне оновлення токена
    // через refresh token приходить трохи пізніше, окремим event'ом.
    final initialState = await auth.onAuthStateChange.first.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('[AuthGate] auth state timeout — treating as signed out');
        return AuthState(AuthChangeEvent.signedOut, null);
      },
    );

    debugPrint(
      '[AuthGate] initial auth event: ${initialState.event}, '
      'session=${initialState.session != null}',
    );

    // Тепер підписуємось на подальші зміни (наприклад, якщо сесія
    // "помре" вже під час роботи застосунку — токен не вдалось оновити,
    // refresh token теж протух і т.д.) і одразу викидаємо на логін.
    _authSubscription = auth.onAuthStateChange.listen((state) {
      debugPrint('[AuthGate] auth state changed: ${state.event}');

      if (state.event == AuthChangeEvent.signedOut && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const OnboardingPage(startAtAuthStep: true),
          ),
          (route) => false,
        );
      }
    });

    final hasValidSession = auth.currentSession != null;

    if (hasValidSession) {
      return _StartDestination.home;
    }

    final onboardingCompleted = await OnboardingStore.instance.isCompleted();

    return onboardingCompleted
        ? _StartDestination.authOnly
        : _StartDestination.onboarding;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StartDestination>(
      future: _resolution,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          );
        }

        switch (snapshot.data!) {
          case _StartDestination.home:
            return const IndexLayout();
          case _StartDestination.authOnly:
            return const OnboardingPage(startAtAuthStep: true);
          case _StartDestination.onboarding:
            return const OnboardingPage();
        }
      },
    );
  }
}