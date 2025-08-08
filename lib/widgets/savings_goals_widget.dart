import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/expense_provider.dart';

class SavingsGoalsWidget extends StatelessWidget {
  const SavingsGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final goals = expenseProvider.savingsGoals;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                color: const Color(0xFFFF6B35),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Savings Goals',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showAddGoalDialog(context),
                icon: const Icon(Icons.add),
                color: const Color(0xFFFF6B35),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms),
          
          const SizedBox(height: 15),
          
          if (goals.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 40,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No Savings Goals Yet',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tap the + button to create your first savings goal!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            ...goals.map((goal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: goal.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            goal.isCompleted ? Icons.check_circle : Icons.flag,
                            color: goal.color,
                            size: 20,
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
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                '₹${goal.currentAmount.toStringAsFixed(2)} / ₹${goal.targetAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${goal.progressPercentage.toStringAsFixed(1)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: goal.color,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    LinearProgressIndicator(
                      value: goal.progressPercentage / 100,
                      backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                      minHeight: 8,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Target: ${goal.targetDate.day}/${goal.targetDate.month}/${goal.targetDate.year}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                        if (!goal.isCompleted)
                          ElevatedButton(
                            onPressed: () => _showUpdateGoalDialog(context, goal),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goal.color,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: 0.3);
            }).toList(),
          ],
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Add Savings Goal',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Target Date: ',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        selectedDate = date;
                      }
                    },
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                final amount = double.tryParse(amountController.text) ?? 0;
                final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.addSavingsGoal(
                  title: titleController.text,
                  targetAmount: amount,
                  targetDate: selectedDate,
                  category: 'Savings',
                  color: selectedColor,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Add Goal',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateGoalDialog(BuildContext context, SavingsGoal goal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Update Savings Goal',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              goal.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount to Add (₹)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                final amount = double.tryParse(amountController.text) ?? 0;
                final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.updateSavingsGoal(goal.id, amount);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Update',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}

class GamificationWidget extends StatelessWidget {
  const GamificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final savingsStreak = expenseProvider.savingsStreak;
    final totalBadges = expenseProvider.totalBadges;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: const Color(0xFFFF6B35),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildAchievementCard(
                  context,
                  'Savings Streak',
                  '$savingsStreak weeks',
                  Icons.local_fire_department,
                  savingsStreak > 0 ? Colors.orange : Colors.grey,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildAchievementCard(
                  context,
                  'Total Badges',
                  '$totalBadges earned',
                  Icons.workspace_premium,
                  totalBadges > 0 ? Colors.amber : Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          if (savingsStreak > 0) ...[
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Congratulations! You\'ve maintained a savings streak for $savingsStreak weeks!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildAchievementCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
