import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/common.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.isIncome});

  final bool isIncome;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  int _amount = 0;
  String _category = 'Food';
  String _wallet = 'GoPay';
  String _when = 'Today';

  static const _categories = ['Food', 'Transport', 'Health', 'Entertainment'];

  void _press(String key) {
    setState(() {
      if (key == 'Del') {
        _amount = _amount ~/ 10;
      } else if (key == '.000') {
        _amount = (_amount * 1000).clamp(0, 999999999999);
      } else {
        final next = _amount * 10 + int.parse(key);
        if (next <= 999999999999) _amount = next;
      }
    });
  }

  void _save() {
    if (_amount <= 0) return;
    final state = AppState.instance;
    state.addTransaction(
      Txn(
        title: _category,
        category: _category,
        when: DateTime.now(),
        amount: _amount.toDouble(),
        isIncome: widget.isIncome,
        icon: widget.isIncome
            ? Icons.south_west_rounded
            : Icons.north_east_rounded,
        iconColor: widget.isIncome ? AppColors.success : AppColors.danger,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${widget.isIncome ? 'Income' : 'Expense'} '
          '${rupiah(_amount)} saved to $_wallet',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final accent = widget.isIncome ? AppColors.success : AppColors.danger;
    final projected = widget.isIncome
        ? state.monthlyIncome + _amount
        : state.monthlyExpenses + _amount;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.inkSoft),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.isIncome ? 'New Income' : 'New Expense',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 64),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                rupiah(_amount),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isIncome
                    ? 'This month\'s income becomes ${rupiah(projected)}'
                    : 'This month\'s spending becomes ${rupiah(projected)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ..._categories.map(
                      (category) => PillChip(
                        label: category,
                        selected: _category == category,
                        onTap: () => setState(() => _category = category),
                      ),
                    ),
                    PillChip(
                      label: 'Add',
                      leading: Icons.add,
                      dense: true,
                      onTap: () => _showNewCategory(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.calendar_today_rounded,
                        label: _when,
                        onTap: () => _pickDate(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.account_balance_wallet_outlined,
                        label: _wallet,
                        onTap: () => _pickWallet(context),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    for (final row in const [
                      ['1', '2', '3'],
                      ['4', '5', '6'],
                      ['7', '8', '9'],
                      ['.000', '0', 'Del'],
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: row
                              .map(
                                (key) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: _KeypadKey(
                                      label: key,
                                      onTap: () => _press(key),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _amount > 0 ? _save : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.isIncome
                          ? AppColors.primary
                          : AppColors.primary,
                      disabledBackgroundColor: AppColors.inkMuted
                          .withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      widget.isIncome ? 'Save income' : 'Save expense',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 3,
                width: 60,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickWallet(BuildContext context) {
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
            const Text(
              'Pay from',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...AppState.instance.wallets.map(
              (wallet) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleIcon(icon: wallet.icon, color: wallet.accent),
                title: Text(
                  wallet.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(rupiah(wallet.balance)),
                trailing: _wallet == wallet.name
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _wallet = wallet.name);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() => _when = shortDate(picked));
  }

  void _showNewCategory(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('New category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() => _category = controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: AppColors.inkSoft),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            const Icon(
              Icons.expand_more_rounded,
              size: 16,
              color: AppColors.inkMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  const _KeypadKey({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.72),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
