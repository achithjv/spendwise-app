import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/expense_provider.dart';

class FinancialSnapshot extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isDark;

  const FinancialSnapshot({
    super.key,
    required this.transactions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalSavings = totalIncome - totalExpenses;
    final healthScore =
        _calculateHealthScore(totalIncome, totalExpenses, totalSavings);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Snapshot',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Financial Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Income',
                  '₹${totalIncome.toStringAsFixed(2)}',
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildMetricCard(
                  'Total Expenses',
                  '₹${totalExpenses.toStringAsFixed(2)}',
                  Colors.red,
                  Icons.trending_down,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Savings',
                  '₹${totalSavings.toStringAsFixed(2)}',
                  totalSavings >= 0 ? Colors.blue : Colors.red,
                  Icons.savings,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildHealthScoreCard(healthScore),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Financial Health Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getHealthColor(healthScore).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getHealthIcon(healthScore),
                  color: _getHealthColor(healthScore),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getHealthTitle(healthScore),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        _getHealthDescription(healthScore),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getHealthColor(healthScore).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${healthScore.round()}/100',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getHealthColor(healthScore),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildMetricCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(double score) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getHealthColor(score).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: score / 100,
                  backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getHealthColor(score)),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '${score.round()}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getHealthColor(score),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Health Score',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateHealthScore(double income, double expenses, double savings) {
    if (income == 0) return 0;

    final savingsRate = (savings / income) * 100;
    final expenseRatio = expenses / income;

    double score = 0;

    // Savings rate component (40% weight)
    if (savingsRate >= 20) {
      score += 40;
    } else if (savingsRate >= 10) {
      score += 30;
    } else if (savingsRate >= 0) {
      score += 20;
    } else {
      score += 10;
    }

    // Expense ratio component (30% weight)
    if (expenseRatio <= 0.7) {
      score += 30;
    } else if (expenseRatio <= 0.9) {
      score += 20;
    } else if (expenseRatio <= 1.0) {
      score += 10;
    }

    // Transaction consistency (30% weight)
    final recentTransactions = transactions
        .where((t) =>
            t.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .length;

    if (recentTransactions >= 20) {
      score += 30;
    } else if (recentTransactions >= 10) {
      score += 20;
    } else if (recentTransactions >= 5) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  Color _getHealthColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.yellow;
    return Colors.red;
  }

  IconData _getHealthIcon(double score) {
    if (score >= 80) return Icons.emoji_events;
    if (score >= 60) return Icons.trending_up;
    if (score >= 40) return Icons.warning;
    return Icons.trending_down;
  }

  String _getHealthTitle(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  String _getHealthDescription(double score) {
    if (score >= 80) return 'Your financial health is excellent!';
    if (score >= 60) return 'You\'re on the right track.';
    if (score >= 40) return 'Consider reducing expenses.';
    return 'Focus on increasing income or reducing expenses.';
  }
}
