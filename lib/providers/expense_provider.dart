import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String type; // 'income' or 'expense'
  final String? currency;
  final bool isRecurring;
  final String? recurringId;
  final String paymentMethod; // 'Cash', 'Card', 'UPI', 'Bank Transfer', etc.
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.currency = 'INR',
    this.isRecurring = false,
    this.recurringId,
    this.paymentMethod = 'Cash',
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type,
      'currency': currency,
      'isRecurring': isRecurring,
      'recurringId': recurringId,
      'paymentMethod': paymentMethod,
      'description': description,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      type: json['type'],
      currency: json['currency'] ?? 'INR',
      isRecurring: json['isRecurring'] ?? false,
      recurringId: json['recurringId'],
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      description: json['description'],
    );
  }
}

class SavingsGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String category;
  final Color color;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.category,
    required this.color,
  });

  double get progressPercentage =>
      (currentAmount / targetAmount * 100).clamp(0, 100);
  bool get isCompleted => currentAmount >= targetAmount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'category': category,
      'color': color.value,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      title: json['title'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount'].toDouble(),
      targetDate: DateTime.parse(json['targetDate']),
      category: json['category'],
      color: Color(json['color']),
    );
  }
}

class SpendingInsight {
  final String title;
  final String description;
  final String type; // 'warning', 'suggestion', 'achievement'
  final Color color;
  final IconData icon;

  SpendingInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    required this.icon,
  });
}

class ExpenseProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<SavingsGoal> _savingsGoals = [];
  int _savingsStreak = 0;
  int _totalBadges = 0;

  List<Transaction> get transactions => _transactions;
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  int get savingsStreak => _savingsStreak;
  int get totalBadges => _totalBadges;

  double get totalIncome {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpenses;

  // Smart spending insights
  List<SpendingInsight> get spendingInsights {
    List<SpendingInsight> insights = [];

    // Check for overspending in categories
    final categoryExpenses = _getCategoryExpenses();
    final totalExpenses = this.totalExpenses;

    categoryExpenses.forEach((category, amount) {
      final percentage = (amount / totalExpenses * 100);
      if (percentage > 40) {
        insights.add(SpendingInsight(
          title: 'High Spending Alert',
          description:
              'You\'ve spent ${percentage.toStringAsFixed(1)}% of your total expenses on $category this month.',
          type: 'warning',
          color: Colors.orange,
          icon: Icons.warning,
        ));
      }
    });

    // Check for savings streak
    if (_savingsStreak > 0) {
      insights.add(SpendingInsight(
        title: 'Savings Streak!',
        description:
            'You\'ve maintained a savings streak for $_savingsStreak weeks!',
        type: 'achievement',
        color: Colors.green,
        icon: Icons.emoji_events,
      ));
    }

    // Check for budget overruns
    if (balance < 0) {
      insights.add(SpendingInsight(
        title: 'Budget Overrun',
        description:
            'You\'ve exceeded your income by ₹${balance.abs().toStringAsFixed(2)} this month.',
        type: 'warning',
        color: Colors.red,
        icon: Icons.trending_down,
      ));
    }

    return insights;
  }

  // Recurring expenses detection
  List<Transaction> get recurringExpenses {
    final Map<String, List<Transaction>> groupedTransactions = {};

    for (final transaction in _transactions.where((t) => t.type == 'expense')) {
      final key = '${transaction.title}_${transaction.amount}';
      if (!groupedTransactions.containsKey(key)) {
        groupedTransactions[key] = [];
      }
      groupedTransactions[key]!.add(transaction);
    }

    List<Transaction> recurring = [];
    groupedTransactions.forEach((key, transactions) {
      if (transactions.length >= 2) {
        // Check if transactions are roughly monthly apart
        final sortedTransactions = transactions
          ..sort((a, b) => a.date.compareTo(b.date));
        bool isRecurring = true;

        for (int i = 1; i < sortedTransactions.length; i++) {
          final daysDiff = sortedTransactions[i]
              .date
              .difference(sortedTransactions[i - 1].date)
              .inDays;
          if (daysDiff < 25 || daysDiff > 35) {
            isRecurring = false;
            break;
          }
        }

        if (isRecurring) {
          final latestTransaction = sortedTransactions.last;
          recurring.add(Transaction(
            id: latestTransaction.id,
            title: latestTransaction.title,
            amount: latestTransaction.amount,
            date: latestTransaction.date,
            category: latestTransaction.category,
            type: latestTransaction.type,
            isRecurring: true,
            recurringId: key,
          ));
        }
      }
    });

    return recurring;
  }

  ExpenseProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load transactions
    final transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      _transactions =
          decoded.map((item) => Transaction.fromJson(item)).toList();
    }

    // Load savings goals
    final goalsJson = prefs.getString('savingsGoals');
    if (goalsJson != null) {
      final List<dynamic> decoded = jsonDecode(goalsJson);
      _savingsGoals =
          decoded.map((item) => SavingsGoal.fromJson(item)).toList();
    }

    // Load gamification data
    _savingsStreak = prefs.getInt('savingsStreak') ?? 0;
    _totalBadges = prefs.getInt('totalBadges') ?? 0;

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save transactions
    final transactionsJson =
        jsonEncode(_transactions.map((t) => t.toJson()).toList());
    await prefs.setString('transactions', transactionsJson);

    // Save savings goals
    final goalsJson = jsonEncode(_savingsGoals.map((g) => g.toJson()).toList());
    await prefs.setString('savingsGoals', goalsJson);

    // Save gamification data
    await prefs.setInt('savingsStreak', _savingsStreak);
    await prefs.setInt('totalBadges', _totalBadges);
  }

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
    required String type,
    DateTime? date,
    String? description,
    String? paymentMethod,
    String currency = 'INR',
  }) async {
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: date ?? DateTime.now(),
      category: category,
      type: type,
      currency: currency,
      paymentMethod: paymentMethod ?? 'Cash',
      description: description,
    );

    _transactions.add(transaction);
    await _saveData();
    _updateGamification();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveData();
    notifyListeners();
  }

  Future<void> addSavingsGoal({
    required String title,
    required double targetAmount,
    required DateTime targetDate,
    required String category,
    required Color color,
  }) async {
    final goal = SavingsGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      targetAmount: targetAmount,
      currentAmount: 0,
      targetDate: targetDate,
      category: category,
      color: color,
    );

    _savingsGoals.add(goal);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateSavingsGoal(String goalId, double amount) async {
    final goalIndex = _savingsGoals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final goal = _savingsGoals[goalIndex];
      _savingsGoals[goalIndex] = SavingsGoal(
        id: goal.id,
        title: goal.title,
        targetAmount: goal.targetAmount,
        currentAmount: goal.currentAmount + amount,
        targetDate: goal.targetDate,
        category: goal.category,
        color: goal.color,
      );
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    _savingsGoals.removeWhere((g) => g.id == goalId);
    await _saveData();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    _transactions.clear();
    _savingsGoals.clear();
    _savingsStreak = 0;
    _totalBadges = 0;
    await _saveData();
    notifyListeners();
  }

  void _updateGamification() {
    // Update savings streak
    if (balance > 0) {
      _savingsStreak++;
    } else {
      _savingsStreak = 0;
    }

    // Award badges
    if (_savingsStreak >= 7 && _totalBadges < 1) {
      _totalBadges++;
    }
    if (_savingsStreak >= 30 && _totalBadges < 2) {
      _totalBadges++;
    }
    if (balance > 10000 && _totalBadges < 3) {
      _totalBadges++;
    }
  }

  Map<String, double> _getCategoryExpenses() {
    final Map<String, double> categoryExpenses = {};
    for (final transaction in _transactions.where((t) => t.type == 'expense')) {
      categoryExpenses[transaction.category] =
          (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryExpenses;
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  // AI Budget Assistant
  String getBudgetAdvice(String category, double amount) {
    final categoryExpenses = _getCategoryExpenses();
    final currentCategorySpending = categoryExpenses[category] ?? 0;
    final totalExpenses = this.totalExpenses;
    final categoryPercentage =
        totalExpenses > 0 ? (currentCategorySpending / totalExpenses * 100) : 0;

    if (categoryPercentage > 50) {
      return "⚠️ You've already spent ${categoryPercentage.toStringAsFixed(1)}% of your total expenses on $category. Consider reducing this expense.";
    } else if (categoryPercentage > 30) {
      return "⚠️ $category spending is at ${categoryPercentage.toStringAsFixed(1)}% of total expenses. Proceed with caution.";
    } else {
      return "✅ Your $category spending is well within budget at ${categoryPercentage.toStringAsFixed(1)}% of total expenses.";
    }
  }
}
