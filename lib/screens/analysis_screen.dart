import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';
import '../widgets/donut_chart.dart';
import 'home_screen.dart' show TargetCard;

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String _mode = 'Spending';
  bool _sortHighest = true;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final spent = state.totalSpent;
    final categories = List<CategoryBudget>.from(state.budgets)
      ..sort((a, b) => _sortHighest
          ? b.spent.compareTo(a.spent)
          : a.spent.compareTo(b.spent));
    final visible = categories.where((c) => c.spent > 0).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...['Spending', 'Income', 'Outcome'].map(
                (mode) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: PillChip(
                    label: mode,
                    dense: true,
                    selected: _mode == mode,
                    onTap: () => setState(() => _mode = mode),
                  ),
                ),
              ),
              PillChip(
                label: 'Add',
                dense: true,
                leading: Icons.add,
                onTap: () => AppState.instance.selectTab(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SoftCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Spend',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  PillChip(
                    label: monthYear(DateTime(2026, 1, 1)),
                    dense: true,
                    leading: Icons.expand_more_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DonutChart(
                size: 176,
                stroke: 26,
                segments: visible
                    .map(
                      (c) => DonutSegment(value: c.spent, color: c.color),
                    )
                    .toList(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rupiah(spent),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: visible
                    .map(
                      (c) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${c.name} - ${percent(c.spent / spent * 100)}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            const Expanded(
              child: Text(
                'History by Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _sortHighest = !_sortHighest),
              child: Row(
                children: [
                  Text(
                    _sortHighest ? 'Sort by Highest' : 'Sort by Lowest',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const Icon(
                    Icons.swap_vert_rounded,
                    size: 16,
                    color: AppColors.inkMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...visible.map((category) => _CategoryRow(
              category: category,
              share: category.spent / spent,
            )),
        const SizedBox(height: 22),
        SectionHeader(
          title: 'Target Section',
          actionLabel: 'Add Target',
          onAction: () => AppState.instance.selectTab(0),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 196,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.targets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) =>
                TargetCard(target: state.targets[index]),
          ),
        ),
        const SizedBox(height: 18),
        SoftCard(
          color: AppColors.surfaceMuted,
          child: Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                size: 18,
                color: AppColors.inkSoft,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'You spent ${rupiah(430000)} less than last month. '
                  'Keep it up to reach your Trip to Bali goal sooner.',
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: AppColors.inkSoft,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.share});

  final CategoryBudget category;
  final double share;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SoftCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleIcon(
              icon: category.icon,
              color: category.color,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    percent(share * 100),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              rupiah(category.spent),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
