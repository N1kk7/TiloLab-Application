import 'package:flutter/material.dart';

import '../../../../store/onboarding_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/age_step.dart';
import '../widgets/auth_step.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_stepper.dart';
import '../widgets/welcome_step.dart';
import '../../../../layouts/index_layout.dart';

class OnboardingPage extends StatefulWidget {
  /// true — показать одразу крок автентифікації, минаючи welcome/age-verification.
  /// Використовується, коли онбординг вже пройдений, але сесія втрачена (розлогінило).
  final bool startAtAuthStep;

  const OnboardingPage({
    super.key,
    this.startAtAuthStep = false,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const totalSteps = 3;

  // null — ще завантажуємо збережений крок
  int? currentStep;

  @override
  void initState() {
    super.initState();
    _resolveInitialStep();
  }

  Future<void> _resolveInitialStep() async {
    if (widget.startAtAuthStep) {
      setState(() => currentStep = 2);
      return;
    }

    final savedStep = await OnboardingStore.instance.getStep();

    if (!mounted) return;

    setState(() => currentStep = savedStep.clamp(0, totalSteps - 1));
  }

  Future<void> _goToStep(int step) async {
    setState(() => currentStep = step);

    // якщо це "чистий" прохід онбордингу — зберігаємо прогрес,
    // якщо це режим "тільки автентифікація" — зберігати нема сенсу
    if (!widget.startAtAuthStep) {
      await OnboardingStore.instance.saveStep(step);
    }
  }

  void nextStep() {
    if (currentStep == null || currentStep! >= totalSteps - 1) return;
    _goToStep(currentStep! + 1);
  }

  void previousStep() {
    if (currentStep == null || currentStep! <= 0) return;
    _goToStep(currentStep! - 1);
  }

  Future<void> openHome() async {
    await OnboardingStore.instance.markCompleted();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const IndexLayout(),
      ),
    );
  }

  Widget buildStep() {
    switch (currentStep) {
      case 0:
        return WelcomeStep(onContinue: nextStep);
      case 1:
        return AgeVerificationStep(onVerified: nextStep);
      case 2:
        return AuthStep(onAuthenticated: openHome);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  if (!widget.startAtAuthStep)
                    OnboardingStepper(currentStep: currentStep!),

                  Expanded(child: buildStep()),
                ],
              ),

              if (currentStep! > 0 && !widget.startAtAuthStep)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 62,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: OnboardingNavigation(onPrevious: previousStep),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}