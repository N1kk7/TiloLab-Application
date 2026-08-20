import 'package:flutter/material.dart';

import '../widgets/animated_gradient_background.dart';
import '../widgets/age_step.dart';
import '../widgets/auth_step.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_stepper.dart';
import '../widgets/welcome_step.dart';
import '../../../../layouts/index_layout.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentStep = 0;

  void nextStep() {
    if (currentStep >= 2) return;

    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    if (currentStep <= 0) return;

    setState(() {
      currentStep--;
    });
  }

  void openHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const IndexLayout(),
      ),
    );
  }

  Widget buildStep() {
    switch (currentStep) {
      case 0:
        return WelcomeStep(
          onContinue: nextStep,
        );

      case 1:
        return AgeVerificationStep(
            onVerified: nextStep,
        );

      case 2:
        return AuthStep(
          onAuthenticated: openHome,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  OnboardingStepper(
                    currentStep: currentStep,
                  ),

                  Expanded(
                    child: buildStep(),
                  ),
                ],
              ),

              if (currentStep > 0)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 62,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: OnboardingNavigation(
                      onPrevious: previousStep,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}