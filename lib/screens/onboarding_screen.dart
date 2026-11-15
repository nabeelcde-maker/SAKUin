import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static const _steps = [
    (
      title: 'Welcome to',
      brand: 'SAKUin',
      subtitle: 'Where your financial goals begin!',
    ),
    (
      title: 'All your money',
      brand: 'in one place',
      subtitle: 'Wallets, spending and savings — tracked automatically.',
    ),
    (
      title: 'Plan, save,',
      brand: 'then achieve',
      subtitle: 'Set targets and let your budget do the heavy lifting.',
    ),
  ];

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      Navigator.of(context).pushReplacement(AppShellRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(AppShellRoute()),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(flex: 6, child: _TiltedCards()),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < _steps.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == _step ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i == _step
                                    ? AppColors.amber
                                    : const Color(0x33000000),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: Column(
                          key: ValueKey(_step),
                          children: [
                            Text(
                              step.title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            Text(
                              step.brand,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: AppColors.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _next,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.inkSoft,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushReplacement(AppShellRoute()),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
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

/// The stack of rotated "category" cards from the onboarding design.
class _TiltedCards extends StatelessWidget {
  const _TiltedCards();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 0.95,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 6,
                left: 34,
                child: Transform.rotate(
                  angle: -10 * math.pi / 180,
                  child: const _MoneyCard(
                    label: 'Transport',
                    amount: 'Rp 500.000',
                    date: '1 Oct 2026',
                    color: Color(0xFF4A7BA8),
                    icon: Icons.directions_car_filled,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 14,
                child: Transform.rotate(
                  angle: 12 * math.pi / 180,
                  child: const _MoneyCard(
                    label: 'Shopping',
                    amount: 'Rp 1.250.000',
                    date: '12 Oct 2026',
                    color: Color(0xFF276B4C),
                    icon: Icons.shopping_bag,
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 12,
                child: Transform.rotate(
                  angle: -4 * math.pi / 180,
                  child: const _MoneyCard(
                    label: 'Education',
                    amount: 'Rp 800.000',
                    date: '20 Oct 2026',
                    color: Color(0xFF2B2B2B),
                    icon: Icons.school,
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 96,
                child: Transform.rotate(
                  angle: 8 * math.pi / 180,
                  child: const _MoneyCard(
                    label: 'Entertainment',
                    amount: 'Rp 450.000',
                    date: '28 Oct 2026',
                    color: Color(0xFF4B3A78),
                    icon: Icons.sports_esports,
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

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({
    required this.label,
    required this.amount,
    required this.date,
    required this.color,
    required this.icon,
  });

  final String label;
  final String amount;
  final String date;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      height: 128,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.95), color.withOpacity(0.75)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(icon, size: 16, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Amount',
            style: TextStyle(fontSize: 9, color: Colors.white70),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 10,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 9, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
