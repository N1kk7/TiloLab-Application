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

  Future<_StartDestination> _resolve() async {
    final session = Supabase.instance.client.auth.currentSession;

    // supabase_flutter відновлює збережену сесію (і сам оновлює токен,
    // якщо він протух, але refresh token ще живий) вже до завершення
    // Supabase.initialize() в main() — тож на цьому етапі currentSession
    // вже відображає актуальний стан з диска.
    final hasValidSession = session != null && !session.isExpired;

    if (hasValidSession) {
      return _StartDestination.home;
    }

    final onboardingCompleted = await OnboardingStore.instance.isCompleted();

    return onboardingCompleted
        ? _StartDestination.authOnly
        : _StartDestination.onboarding;
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