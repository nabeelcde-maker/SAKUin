import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            _Hero(state: state),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _QuickActions(state: state),
                    const SizedBox(height: 16),
                    const _HistoryCard(),
                    const SizedBox(height: 20),
                    const _TargetSection(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF2C08A), Color(0xFFD98327)],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Amanda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Welcome back!',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => AppState.instance.selectTab(4),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                'All Wallets',
                'GoPay',
                'DANA',
                'BNI',
                'BCA',
              ]
                  .map(
                    (wallet) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PillChip(
                        label: wallet,
                        dark: true,
                        dense: true,
                        selected: state.walletFilter == wallet,
                        onTap: () => state.selectWallet(wallet),
                      ),
                    ),
                  )
                  .toList()
                ..add(
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillChip(
                      label: 'Add',
                      dark: true,
                      dense: true,
                      leading: Icons.add,
                      onTap: () => _showAddWalletSheet(context, state),
                    ),
                  ),
                ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Total balance',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                state.hideBalance ? '••••••••' : rupiah(state.totalBalance),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: state.toggleBalance,
                child: Icon(
                  state.hideBalance
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 12,
                color: Colors.white54,
              ),
              const SizedBox(width: 5),
              Text(
                'Last updated 1 min ago',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Monthly Income',
                  value: rupiah(state.monthlyIncome),
                  icon: Icons.south_west_rounded,
                  positive: true,
                  hidden: state.hideBalance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Monthly Expenses',
                  value: rupiah(state.monthlyExpenses),
                  icon: Icons.north_east_rounded,
                  positive: false,
                  hidden: state.hideBalance,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddWalletSheet(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Connect a wallet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Link an e-wallet or bank account to track it automatically.',
              style: TextStyle(fontSize: 13, color: AppColors.inkSoft),
            ),
            const SizedBox(height: 18),
            ...[
              ('GoPay', Icons.account_balance_wallet_outlined, Color(0xFF00A6C0)),
              ('DANA', Icons.savings_outlined, Color(0xFF108EE9)),
              ('BCA', Icons.credit_card_outlined, Color(0xFF1B4B8F)),
            ].map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleIcon(icon: item.$2, color: item.$3),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Tap to connect'),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.inkMuted,
                ),
                onTap: () {
                  state.addWallet(
                    Wallet(
                      name: item.$1,
                      balance: 0,
                      accent: item.$3,
                      mask: '**** 0000',
                      icon: item.$2,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.$1} connected'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Add manually'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.positive,
    required this.hidden,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool positive;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.white.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  hidden ? '••••••' : value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: positive
                    ? const Color(0xFFB8F3C9)
                    : const Color(0xFFFFC7C7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final actions = <({String label, IconData icon, Color color})>[
      (
        label: 'Income',
        icon: Icons.add_circle_outline,
        color: AppColors.success
      ),
      (
        label: 'Expenses',
        icon: Icons.remove_circle_outline,
        color: AppColors.danger
      ),
      (
        label: 'Spend Limit',
        icon: Icons.pie_chart_outline,
        color: AppColors.amber
      ),
      (
        label: 'More',
        icon: Icons.grid_view_rounded,
        color: AppColors.info
      ),
    ];

    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (action.label == 'Expenses') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddExpenseScreen(isIncome: false),
                    ),
                  );
                } else if (action.label == 'Income') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddExpenseScreen(isIncome: true),
                    ),
                  );
                } else if (action.label == 'Spend Limit') {
                  state.selectTab(1);
                } else {
                  state.selectTab(3);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    CircleIcon(icon: action.icon, color: action.color, size: 44),
                    const SizedBox(height: 8),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HistoryCard extends StatefulWidget {
  const _HistoryCard();

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  String _filter = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final items = state.transactions.where((txn) {
      final matchesType = _filter == 'All' ||
          (_filter == 'Income' && txn.isIncome) ||
          (_filter == 'Expenses' && !txn.isIncome);
      final matchesQuery = _query.isEmpty ||
          txn.title.toLowerCase().contains(_query.toLowerCase()) ||
          txn.category.toLowerCase().contains(_query.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              PillChip(
                label: 'All History',
                dense: true,
                onTap: () => _showAllHistory(context, state),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: ['All', 'Income', 'Expenses'].map((tab) {
              final selected = _filter == tab;
              return Padding(
                padding: const EdgeInsets.only(right: 18),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = tab),
                  child: Column(
                    children: [
                      Text(
                        tab,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w500,
                          color:
                              selected ? AppColors.primary : AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 2,
                        width: 22,
                        color: selected ? AppColors.primary : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search transactions',
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppColors.inkMuted,
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              fillColor: AppColors.surfaceMuted,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
                ),
              ),
            )
          else
            ...items.take(5).map((txn) => _TxnRow(txn: txn)),
        ],
      ),
    );
  }

  void _showAllHistory(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, controller) => Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All transactions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    for (final txn in state.transactions) _TxnRow(txn: txn),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.txn});

  final Txn txn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleIcon(icon: txn.icon, color: txn.iconColor, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  txnTime(txn.when),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${txn.isIncome ? '+' : '−'}${rupiah(txn.amount)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: txn.isIncome ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                txn.isIncome ? 'Money in' : 'Money out',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TargetSection extends StatefulWidget {
  const _TargetSection();

  @override
  State<_TargetSection> createState() => _TargetSectionState();
}

class _TargetSectionState extends State<_TargetSection> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final targets = state.targets.where((target) {
      if (_filter == 'Short term') return target.tags.contains('Short term');
      if (_filter == 'Long term') return target.tags.contains('Long term');
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'List Target',
          actionLabel: 'Add Target',
          onAction: () => _showAddTarget(context, state),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['All', 'Short term', 'Long term'].map((tab) {
            final selected = _filter == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => setState(() => _filter = tab),
                child: Column(
                  children: [
                    Text(
                      tab,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w500,
                        color: selected ? AppColors.primary : AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 18,
                      color: selected ? AppColors.primary : Colors.transparent,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 196,
          child: targets.isEmpty
              ? const Center(
                  child: Text(
                    'No targets in this list yet',
                    style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: targets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) =>
                      TargetCard(target: targets[index]),
                ),
        ),
      ],
    );
  }

  void _showAddTarget(BuildContext context, AppState state) {
    final controller = TextEditingController();
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New target',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Give your goal a name and a monthly amount.',
                style: TextStyle(fontSize: 13, color: AppColors.inkSoft),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'e.g. New phone'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;
                  state.targets.insert(
                    0,
                    SavingsTarget(
                      title: name,
                      deadline: DateTime(DateTime.now().year + 1, 6),
                      raised: 0,
                      goal: 5000000,
                      tags: const ['Short term'],
                      gradient: AppColors.tripGradient,
                      icon: Icons.flag_rounded,
                    ),
                  );
                  Navigator.pop(context);
                  state.notifyListeners();
                },
                child: const Text('Create target'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.target});

  final SavingsTarget target;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        gradient: target.gradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -12,
            child: Icon(
              target.icon,
              size: 132,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                if (target.reached)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Goal reached',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Text(
                  target.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: target.tags
                      .map(
                        (tag) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${rupiah(target.raised)} of ${rupiah(target.goal)}',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                    Text(
                      '${target.percent}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ProgressBar(
                  value: target.progress,
                  color: Colors.white,
                  track: Colors.white.withOpacity(0.28),
                  height: 7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
