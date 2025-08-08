import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/expense_provider.dart';

class InsightsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isDark;

  const InsightsWidget({
    super.key,
    required this.transactions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();

    if (insights.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb,
              color: const Color(0xFFFF6B35),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Add more transactions to get personalized insights',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smart Insights',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...insights
            .map((insight) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: insight.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: insight.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        insight.icon,
                        color: insight.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight.title,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              insight.description,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  List<Insight> _generateInsights() {
    final insights = <Insight>[];

    if (transactions.isEmpty) return insights;

    // Calculate basic metrics
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = totalIncome - totalExpenses;
    final savingsRate = totalIncome > 0 ? (balance / totalIncome * 100) : 0;

    // Category analysis
    final categoryExpenses = <String, double>{};
    for (final transaction in transactions.where((t) => t.type == 'expense')) {
      categoryExpenses[transaction.category] =
          (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }

    // Generate insights based on data
    if (savingsRate < 0) {
      insights.add(Insight(
        title: 'Overspending Alert',
        description:
            'Your expenses exceed your income. Consider reducing non-essential spending.',
        color: Colors.red,
        icon: Icons.warning,
      ));
    } else if (savingsRate < 10) {
      insights.add(Insight(
        title: 'Low Savings Rate',
        description:
            'Your savings rate is ${savingsRate.toStringAsFixed(1)}%. Aim for at least 20% for better financial health.',
        color: Colors.orange,
        icon: Icons.trending_down,
      ));
    } else if (savingsRate >= 20) {
      insights.add(Insight(
        title: 'Excellent Savings',
        description:
            'Great job! You\'re saving ${savingsRate.toStringAsFixed(1)}% of your income.',
        color: Colors.green,
        icon: Icons.trending_up,
      ));
    }

    // Category insights
    if (categoryExpenses.isNotEmpty) {
      final highestCategory =
          categoryExpenses.entries.reduce((a, b) => a.value > b.value ? a : b);
      final highestPercentage = (highestCategory.value / totalExpenses * 100);

      if (highestPercentage > 50) {
        insights.add(Insight(
          title: 'High Category Spending',
          description:
              '${highestCategory.key} accounts for ${highestPercentage.toStringAsFixed(1)}% of your expenses. Consider diversifying.',
          color: Colors.orange,
          icon: Icons.pie_chart,
        ));
      }
    }

    // Spending pattern insights
    final recentTransactions = transactions
        .where((t) =>
            t.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();

    if (recentTransactions.isNotEmpty) {
      final recentExpenses = recentTransactions
          .where((t) => t.type == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);

      if (recentExpenses > totalExpenses / 4) {
        insights.add(Insight(
          title: 'High Recent Spending',
          description:
              'You\'ve spent ₹${recentExpenses.toStringAsFixed(0)} in the last 7 days. Monitor your daily expenses.',
          color: Colors.red,
          icon: Icons.schedule,
        ));
      }
    }

    // Positive insights
    if (balance > 0 && insights.length < 3) {
      insights.add(Insight(
        title: 'Positive Cash Flow',
        description:
            'You have a positive balance of ₹${balance.toStringAsFixed(0)}. Keep up the good work!',
        color: Colors.green,
        icon: Icons.check_circle,
      ));
    }

    // Savings opportunity
    if (categoryExpenses.isNotEmpty && insights.length < 3) {
      final entertainmentExpense = categoryExpenses['Entertainment'] ?? 0;
      if (entertainmentExpense > totalExpenses * 0.2) {
        insights.add(Insight(
          title: 'Savings Opportunity',
          description:
              'Consider reducing entertainment expenses to increase your savings rate.',
          color: const Color(0xFFFF6B35),
          icon: Icons.lightbulb,
        ));
      }
    }

    return insights.take(3).toList(); // Limit to 3 insights
  }
}

class Insight {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  Insight({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
}
