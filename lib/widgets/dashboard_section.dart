import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../screens/add_income_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/export_screen.dart';
import 'smart_insights_widget.dart';
import 'savings_goals_widget.dart';
import 'recurring_expenses_widget.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Text(
            'Dashboard',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 30),

          // (A) Top Summary Cards (Horizontal row of cards)
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Income',
                  '₹${expenseProvider.totalIncome.toStringAsFixed(2)}',
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Expenses',
                  '₹${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                  Colors.red,
                  Icons.trending_down,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Current Balance',
                  '₹${expenseProvider.balance.toStringAsFixed(2)}',
                  expenseProvider.balance >= 0 ? Colors.blue : Colors.red,
                  Icons.account_balance_wallet,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // (B) Smart Insights Section
          Text(
            'Smart Insights',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),
          const SmartInsightsWidget(),

          const SizedBox(height: 30),

          // (C) AI Budget Assistant Section
          Text(
            'AI Budget Assistant',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),
          const AIBudgetAssistantWidget(),

          const SizedBox(height: 30),

          // (D) Savings Goals Section
          Text(
            'Savings Goals',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),
          const SavingsGoalsWidget(),

          const SizedBox(height: 30),

          // (E) Achievements & Badges Section
          Text(
            'Achievements & Badges',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),
          const GamificationWidget(),

          const SizedBox(height: 30),

          // (F) Recurring Expenses Section
          Text(
            'Recurring Expenses',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),
          const RecurringExpensesWidget(),

          const SizedBox(height: 30),

          // (G) Quick Actions Section
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 15),

          // Quick Actions Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5,
            children: [
              _buildQuickActionCard(
                context,
                'Add Income',
                Icons.add_circle,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddIncomeScreen()),
                ),
              ),
              _buildQuickActionCard(
                context,
                'Add Expense',
                Icons.remove_circle,
                Colors.red,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddExpenseScreen()),
                ),
              ),
              _buildQuickActionCard(
                context,
                'View All Transactions',
                Icons.receipt_long,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransactionsScreen()),
                ),
              ),
              _buildQuickActionCard(
                context,
                'View Reports',
                Icons.analytics,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReportsScreen()),
                ),
              ),
              _buildQuickActionCard(
                context,
                'Export Data',
                Icons.file_download,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExportScreen()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount,
      Color color, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildQuickActionCard(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.3);
  }
}
