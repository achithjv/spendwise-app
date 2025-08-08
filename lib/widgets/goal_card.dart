import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';

class GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddFunds;
  final bool isDark;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFunds,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = goal.progressPercentage;
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    final isOverdue = daysRemaining < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
        children: [
          // Goal Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: goal.color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: goal.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(goal.category),
                    color: goal.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: isDark ? Colors.white : Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.poppins(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Goal Progress
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${progressPercentage.round()}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: goal.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progressPercentage / 100,
                            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Amount and Date Info
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Current',
                        '₹${goal.currentAmount.toStringAsFixed(2)}',
                        Icons.account_balance_wallet,
                        goal.color,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInfoCard(
                        'Target',
                        '₹${goal.targetAmount.toStringAsFixed(2)}',
                        Icons.flag,
                        goal.color,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInfoCard(
                        isOverdue ? 'Overdue' : 'Days Left',
                        isOverdue ? '${daysRemaining.abs()}' : '$daysRemaining',
                        isOverdue ? Icons.warning : Icons.calendar_today,
                        isOverdue ? Colors.red : goal.color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // AI Insights
                if (progressPercentage < 100) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
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
                            _getAIInsight(goal),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAddFunds,
                        icon: const Icon(Icons.add),
                        label: Text(
                          'Add Funds',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goal.color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getAIInsight(SavingsGoal goal) {
    final progress = goal.progressPercentage;
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    final remainingAmount = goal.targetAmount - goal.currentAmount;
    final dailyRequired = remainingAmount / daysRemaining;

    if (progress < 25) {
      return 'Start strong! Consider setting up auto-save to reach your goal faster.';
    } else if (progress < 50) {
      return 'Great progress! You\'re ${(50 - progress).round()}% away from halfway.';
    } else if (progress < 75) {
      return 'You\'re more than halfway there! Keep up the momentum.';
    } else {
      return 'Almost there! Just ₹${remainingAmount.toStringAsFixed(0)} more to go.';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.flight;
      case 'gadgets':
      case 'tech':
        return Icons.phone_android;
      case 'education':
        return Icons.school;
      case 'debt':
        return Icons.credit_card;
      case 'home':
        return Icons.home;
      case 'car':
        return Icons.directions_car;
      case 'wedding':
        return Icons.favorite;
      case 'business':
        return Icons.business;
      default:
        return Icons.flag;
    }
  }
}
