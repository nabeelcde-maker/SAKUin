import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';
import '../widgets/donut_chart.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final spent = state.totalSpent;
        final total = state.totalBudget;
        final remaining = (total - spent).clamp(0, double.infinity);
        final ratio = total == 0 ? 0.0 : (spent / total).clamp(0.0, 1.0);

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Budget',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ),
                PillChip(
                  label: monthYear(DateTime(2026, 1, 1)),
                  leading: Icons.calendar_today_rounded,
                  dense: true,
                ),
              ],
            ),
            const SizedBox(height: 18),
            SoftCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  DonutChart(
                    size: 172,
                    stroke: 22,
                    segments: [
                      DonutSegment(value: spent, color: AppColors.primary),
                      DonutSegment(
                        value: remaining.toDouble(),
                        color: AppColors.surfaceMuted,
                      ),
                    ],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(ratio * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'of budget used',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          label: 'Budget',
                          value: rupiah(total),
                          color: AppColors.ink,
                        ),
                      ),
                      Expanded(
                        child: _MiniStat(
                          label: 'Spent',
                          value: rupiah(spent),
                          color: AppColors.danger,
                        ),
                      ),
                      Expanded(
                        child: _MiniStat(
                          label: 'Left',
                          value: rupiah(remaining),
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SoftCard(
              color: AppColors.primary,
              child: Row(
                children: [
                  const CircleIcon(
                    icon: Icons.lightbulb_outline_rounded,
                    color: Colors.white,
                    size: 40,
                    filled: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transport is over budget',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'You spent ${rupiah(190000)} more than planned. '
                          'Move ${rupiah(190000)} from Shopping to stay on track.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: 'Categories',
              actionLabel: 'Add category',
              onAction: () => _showAddCategory(context, state),
            ),
            const SizedBox(height: 12),
            ...state.budgetsBySpend.map(
              (budget) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _BudgetRow(budget: budget),
              ),
            ),
            const SizedBox(height: 8),
            SoftCard(
              color: AppColors.surfaceMuted,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.inkSoft,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Budgets reset on the 1st of each month. '
                      'Unused amounts can roll over if you enable it in Settings.',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.inkSoft.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategory(BuildContext context, AppState state) {
    final name = TextEditingController();
    final limit = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New budget category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: name,
                decoration: const InputDecoration(hintText: 'Category name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limit,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Monthly limit'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final value = double.tryParse(limit.text.trim()) ?? 0;
                  if (name.text.trim().isEmpty || value <= 0) return;
                  state.budgets.add(
                    CategoryBudget(
                      name: name.text.trim(),
                      spent: 0,
                      limit: value,
                      color: AppColors.catBills,
                      icon: Icons.category_outlined,
                    ),
                  );
                  Navigator.pop(context);
                  state.notifyListeners();
                },
                child: const Text('Save category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.budget});

  final CategoryBudget budget;

  @override
  Widget build(BuildContext context) {
    final color = budget.overBudget ? AppColors.danger : budget.color;
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleIcon(icon: budget.icon, color: color, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      budget.overBudget
                          ? 'Over by ${rupiah(-budget.remaining)}'
                          : '${rupiah(budget.remaining)} left',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: budget.overBudget
                            ? AppColors.danger
                            : AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${rupiah(budget.spent)} / ${rupiah(budget.limit)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProgressBar(value: budget.progress, color: color, height: 7),
        ],
      ),
    );
  }
}
