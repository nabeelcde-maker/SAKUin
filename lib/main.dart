import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SakuiinApp());
}

class SakuiinApp extends StatelessWidget {
  const SakuiinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAKUin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const OnboardingScreen(),
    );
  }
}

/// Convenience used by the onboarding "Log in" link until an auth flow exists.
class AppShellRoute extends PageRouteBuilder {
  AppShellRoute()
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondary) => const AppShell(),
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}
