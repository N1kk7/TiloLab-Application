import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStore {
  OnboardingStore._();
  static final OnboardingStore instance = OnboardingStore._();

  static const _stepKey = 'onboarding_step';
  static const _completedKey = 'onboarding_completed';

  Future<int> getStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_stepKey) ?? 0;
  }

  Future<void> saveStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_stepKey, step);
  }

  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
    await prefs.remove(_stepKey);
  }
}