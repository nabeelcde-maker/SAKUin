import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common.dart';
import 'ai_screen.dart';
import 'analysis_screen.dart';
import 'budget_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          extendBody: true,
          body: GradientBackground(
            child: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: state.tabIndex,
                children: const [
                  HomeScreen(),
                  BudgetScreen(),
                  AiScreen(),
                  AnalysisScreen(),
                  ProfileScreen(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNav(),
        );
      },
    );
  }
}
