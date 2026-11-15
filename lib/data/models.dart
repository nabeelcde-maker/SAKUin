import 'package:flutter/material.dart';

class Wallet {
  const Wallet({
    required this.name,
    required this.balance,
    required this.accent,
    required this.mask,
    required this.icon,
  });

  final String name;
  final double balance;
  final Color accent;
  final String mask;
  final IconData icon;
}

class Txn {
  const Txn({
    required this.title,
    required this.category,
    required this.when,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String category;
  final DateTime when;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final Color iconColor;
}

class SavingsTarget {
  const SavingsTarget({
    required this.title,
    required this.deadline,
    required this.raised,
    required this.goal,
    required this.tags,
    required this.gradient,
    required this.icon,
    this.reached = false,
  });

  final String title;
  final DateTime deadline;
  final double raised;
  final double goal;
  final List<String> tags;
  final Gradient gradient;
  final IconData icon;
  final bool reached;

  double get progress => (raised / goal).clamp(0.0, 1.0);
  int get percent => (progress * 100).round();
}

class CategoryBudget {
  const CategoryBudget({
    required this.name,
    required this.spent,
    required this.limit,
    required this.color,
    required this.icon,
  });

  final String name;
  final double spent;
  final double limit;
  final Color color;
  final IconData icon;

  double get progress => (spent / limit).clamp(0.0, 1.0);
  bool get overBudget => spent > limit;
  double get remaining => limit - spent;
}

class AiSuggestion {
  const AiSuggestion({
    required this.title,
    required this.body,
    required this.gradient,
    required this.icon,
  });

  final String title;
  final String body;
  final Gradient gradient;
  final IconData icon;
}
