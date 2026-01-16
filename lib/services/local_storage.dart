import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String onboardingKey = 'onboarding_completed';

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(onboardingKey) ?? false;
    debugPrint('Onboarding completed: $value');
    return value;
  }
}
