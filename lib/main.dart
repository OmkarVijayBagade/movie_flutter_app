import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/local_storage.dart';
import 'core/navigation/app_shell.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MovieApp(),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.selectedColor,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.selectedColor,
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.themeMode,
      home: const SplashDecider(),
    );
  }
}

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorage.isOnboardingCompleted(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data! ? const AppShell() : const OnboardingScreen();
      },
    );
  }
}
