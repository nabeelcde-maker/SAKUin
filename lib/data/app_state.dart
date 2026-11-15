import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'models.dart';

/// Single source of truth for the demo build.
/// Intentionally dependency-free (no provider/riverpod) so the project
/// runs on a clean `flutter pub get`.
class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  bool hideBalance = false;
  String walletFilter = 'All Wallets';
  int tabIndex = 0;
  DateTime activeMonth = DateTime(2026, 1, 1);

  final List<Wallet> wallets = [
    const Wallet(
      name: 'GoPay',
      balance: 1500000,
      accent: Color(0xFF00A6C0),
      mask: '**** 3375',
      icon: Icons.account_balance_wallet_outlined,
    ),
    const Wallet(
      name: 'BNI',
      balance: 12500000,
      accent: Color(0xFFE07A1F),
      mask: '**** 7890',
      icon: Icons.account_balance_outlined,
    ),
    const Wallet(
      name: 'DANA',
      balance: 2350000,
      accent: Color(0xFF108EE9),
      mask: '**** 1122',
      icon: Icons.savings_outlined,
    ),
    const Wallet(
      name: 'BCA',
      balance: 8000000,
      accent: Color(0xFF1B4B8F),
      mask: '**** 4455',
      icon: Icons.credit_card_outlined,
    ),
  ];

  final List<Txn> transactions = [
    Txn(
      title: 'BNI Payout',
      category: 'Income',
      when: DateTime.now().subtract(const Duration(hours: 3)),
      amount: 150000,
      isIncome: true,
      icon: Icons.account_balance_outlined,
      iconColor: AppColors.primary,
    ),
    Txn(
      title: 'Food',
      category: 'Food & Beverage',
      when: DateTime.now().subtract(const Duration(hours: 5)),
      amount: 150000,
      isIncome: false,
      icon: Icons.fastfood_outlined,
      iconColor: AppColors.catFood,
    ),
    Txn(
      title: 'BNI Payout',
      category: 'Income',
      when: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      amount: 100000,
      isIncome: true,
      icon: Icons.account_balance_outlined,
      iconColor: AppColors.primary,
    ),
    Txn(
      title: 'Entertainment',
      category: 'Entertainment',
      when: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      amount: 100000,
      isIncome: false,
      icon: Icons.sports_esports_outlined,
      iconColor: AppColors.catBills,
    ),
    Txn(
      title: 'Transport',
      category: 'Transport',
      when: DateTime.now().subtract(const Duration(days: 2)),
      amount: 65000,
      isIncome: false,
      icon: Icons.directions_bus_outlined,
      iconColor: AppColors.catTransport,
    ),
    Txn(
      title: 'Shopping',
      category: 'Shopping',
      when: DateTime.now().subtract(const Duration(days: 3)),
      amount: 899000,
      isIncome: false,
      icon: Icons.shopping_bag_outlined,
      iconColor: AppColors.catShopping,
    ),
  ];

  final List<SavingsTarget> targets = [
    SavingsTarget(
      title: 'Trip to Bali',
      deadline: DateTime(2026, 6, 30),
      raised: 20000000,
      goal: 26000000,
      tags: const ['Traveling', 'Long term'],
      gradient: AppColors.tripGradient,
      icon: Icons.flight_takeoff,
    ),
    SavingsTarget(
      title: 'New Gadget',
      deadline: DateTime(2025, 12, 31),
      raised: 10000000,
      goal: 10000000,
      tags: const ['Devices', 'Short term'],
      gradient: AppColors.gadgetGradient,
      icon: Icons.laptop_mac,
      reached: true,
    ),
  ];

  final List<CategoryBudget> budgets = [
    const CategoryBudget(
      name: 'Shopping',
      spent: 1645000,
      limit: 1800000,
      color: AppColors.catShopping,
      icon: Icons.shopping_bag_outlined,
    ),
    const CategoryBudget(
      name: 'Transport',
      spent: 1390000,
      limit: 1200000,
      color: AppColors.catTransport,
      icon: Icons.directions_bus_outlined,
    ),
    const CategoryBudget(
      name: 'Food & Beverage',
      spent: 1105000,
      limit: 1500000,
      color: AppColors.catFood,
      icon: Icons.restaurant_outlined,
    ),
    const CategoryBudget(
      name: 'Sport',
      spent: 160000,
      limit: 300000,
      color: AppColors.catSport,
      icon: Icons.directions_run_outlined,
    ),
    const CategoryBudget(
      name: 'Bills',
      spent: 0,
      limit: 800000,
      color: AppColors.catBills,
      icon: Icons.receipt_long_outlined,
    ),
    const CategoryBudget(
      name: 'Health',
      spent: 0,
      limit: 400000,
      color: AppColors.catHealth,
      icon: Icons.health_and_safety_outlined,
    ),
  ];

  final List<AiSuggestion> aiSuggestions = [
    const AiSuggestion(
      title: 'Shop smart',
      body: 'Keep your wallet safe and still get what you need.',
      gradient: LinearGradient(
        colors: [Color(0xFF8FB8A0), Color(0xFF5E8F76)],
      ),
      icon: Icons.shopping_bag_outlined,
    ),
    const AiSuggestion(
      title: 'Upgrade tech',
      body: 'A plan to buy that new laptop without breaking the budget.',
      gradient: LinearGradient(
        colors: [Color(0xFFF2C08A), Color(0xFFD98327)],
      ),
      icon: Icons.laptop_mac,
    ),
  ];

  // ---------------------------------------------------------------- derived
  double get totalBalance =>
      wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);

  double get monthlyIncome => 8500000;

  double get monthlyExpenses => 4300000;

  double get totalBudget => budgets.fold(0.0, (sum, b) => sum + b.limit);

  double get totalSpent => budgets.fold(0.0, (sum, b) => sum + b.spent);

  double get totalRaised =>
      targets.fold(0.0, (sum, target) => sum + target.raised);

  List<CategoryBudget> get budgetsBySpend {
    final sorted = List<CategoryBudget>.from(budgets)
      ..sort((a, b) => b.spent.compareTo(a.spent));
    return sorted;
  }

  List<Txn> get visibleTransactions {
    var list = transactions;
    if (walletFilter != 'All Wallets') {
      // Demo build keeps a single ledger; the filter only narrows by category
      // when a wallet name matches nothing it still returns the full ledger.
      final byWallet =
          transactions.where((t) => t.title == walletFilter).toList();
      if (byWallet.isNotEmpty) list = byWallet;
    }
    return list;
  }

  // ---------------------------------------------------------------- actions
  void toggleBalance() {
    hideBalance = !hideBalance;
    notifyListeners();
  }

  void selectWallet(String wallet) {
    walletFilter = wallet;
    notifyListeners();
  }

  void selectTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void addTransaction(Txn txn) {
    transactions.insert(0, txn);
    notifyListeners();
  }

  void addWallet(Wallet wallet) {
    wallets.add(wallet);
    notifyListeners();
  }
}
