import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/goal_card.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/goal_creation_dialog.dart';

class GoalsAndAchievementsScreen extends StatefulWidget {
  const GoalsAndAchievementsScreen({super.key});

  @override
  State<GoalsAndAchievementsScreen> createState() =>
      _GoalsAndAchievementsScreenState();
}

class _GoalsAndAchievementsScreenState extends State<GoalsAndAchievementsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Goals & Achievements',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // Add Goal Button
                    ElevatedButton.icon(
                      onPressed: () => _showGoalCreationDialog(context),
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add Goal',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        isDark ? Colors.grey[400] : Colors.grey[600],
                    labelStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Goals'),
                      Tab(text: 'Achievements'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Goals Tab
                _buildGoalsTab(isDark, expenseProvider),

                // Achievements Tab
                _buildAchievementsTab(isDark, expenseProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTab(bool isDark, ExpenseProvider expenseProvider) {
    final goals = expenseProvider.savingsGoals;
    final activeGoals = goals.where((goal) => !goal.isCompleted).toList();
    final completedGoals = goals.where((goal) => goal.isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Goals Section
          if (activeGoals.isNotEmpty) ...[
            Text(
              'Active Goals',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            ...activeGoals
                .map((goal) => GoalCard(
                      goal: goal,
                      onEdit: () => _editGoal(goal),
                      onDelete: () => _deleteGoal(goal),
                      onAddFunds: () => _addFundsToGoal(goal),
                      isDark: isDark,
                    ))
                .toList(),
            const SizedBox(height: 30),
          ],

          // Completed Goals Section
          if (completedGoals.isNotEmpty) ...[
            Text(
              'Completed Goals',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            ...completedGoals
                .map((goal) => GoalCard(
                      goal: goal,
                      onEdit: () => _editGoal(goal),
                      onDelete: () => _deleteGoal(goal),
                      onAddFunds: () => _addFundsToGoal(goal),
                      isDark: isDark,
                    ))
                .toList(),
          ],

          // Empty State
          if (goals.isEmpty) _buildEmptyGoalsState(isDark),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(bool isDark, ExpenseProvider expenseProvider) {
    final achievements = _getAchievements(expenseProvider);
    final unlockedAchievements =
        achievements.where((a) => a.isUnlocked).toList();
    final lockedAchievements =
        achievements.where((a) => !a.isUnlocked).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Achievement Stats
          Container(
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
            child: Row(
              children: [
                Expanded(
                  child: _buildAchievementStat(
                    'Unlocked',
                    unlockedAchievements.length.toString(),
                    Colors.green,
                    Icons.emoji_events,
                    isDark,
                  ),
                ),
                Expanded(
                  child: _buildAchievementStat(
                    'Total',
                    achievements.length.toString(),
                    const Color(0xFFFF6B35),
                    Icons.star,
                    isDark,
                  ),
                ),
                Expanded(
                  child: _buildAchievementStat(
                    'Progress',
                    '${((unlockedAchievements.length / achievements.length) * 100).round()}%',
                    Colors.blue,
                    Icons.trending_up,
                    isDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Unlocked Achievements
          if (unlockedAchievements.isNotEmpty) ...[
            Text(
              'Unlocked Achievements',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemCount: unlockedAchievements.length,
              itemBuilder: (context, index) {
                return AchievementBadge(
                  achievement: unlockedAchievements[index],
                  isDark: isDark,
                );
              },
            ),
            const SizedBox(height: 30),
          ],

          // Locked Achievements
          if (lockedAchievements.isNotEmpty) ...[
            Text(
              'Locked Achievements',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemCount: lockedAchievements.length,
              itemBuilder: (context, index) {
                return AchievementBadge(
                  achievement: lockedAchievements[index],
                  isDark: isDark,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementStat(
      String title, String value, Color color, IconData icon, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
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
        ),
      ],
    );
  }

  Widget _buildEmptyGoalsState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag,
            size: 80,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No goals yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start your financial journey by creating your first savings goal',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showGoalCreationDialog(context),
            icon: const Icon(Icons.add),
            label: Text(
              'Create Your First Goal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Achievement> _getAchievements(ExpenseProvider expenseProvider) {
    final goals = expenseProvider.savingsGoals;
    final transactions = expenseProvider.transactions;

    final completedGoals = goals.where((g) => g.isCompleted).length;
    final totalSavings = goals.fold(0.0, (sum, g) => sum + g.currentAmount);
    final activeGoals = goals.where((g) => !g.isCompleted).length;

    return [
      // Progress Badges
      Achievement(
        id: 'first_goal',
        title: 'First Goal Started',
        description: 'Created your first savings goal',
        icon: Icons.flag,
        color: Colors.blue,
        isUnlocked: goals.isNotEmpty,
        progress: goals.isNotEmpty ? 1.0 : 0.0,
        target: 1,
      ),
      Achievement(
        id: 'halfway_hero',
        title: 'Halfway Hero',
        description: 'Reached 50% progress on any goal',
        icon: Icons.trending_up,
        color: Colors.green,
        isUnlocked: goals.any((g) => g.progressPercentage >= 50),
        progress: goals.isNotEmpty
            ? goals
                .map((g) => g.progressPercentage)
                .reduce((a, b) => a > b ? a : b)
            : 0.0,
        target: 50,
      ),
      Achievement(
        id: 'goal_getter',
        title: 'Goal Getter',
        description: 'Completed your first goal',
        icon: Icons.emoji_events,
        color: Colors.orange,
        isUnlocked: completedGoals >= 1,
        progress: completedGoals.toDouble(),
        target: 1,
      ),
      Achievement(
        id: 'triple_threat',
        title: 'Triple Threat',
        description: 'Completed 3 goals',
        icon: Icons.star,
        color: Colors.purple,
        isUnlocked: completedGoals >= 3,
        progress: completedGoals.toDouble(),
        target: 3,
      ),
      Achievement(
        id: 'millionaire_mindset',
        title: 'Millionaire Mindset',
        description: 'Total savings crossed ₹1,00,000',
        icon: Icons.account_balance_wallet,
        color: Colors.amber,
        isUnlocked: totalSavings >= 100000,
        progress: totalSavings,
        target: 100000,
      ),

      // Category Badges
      Achievement(
        id: 'travel_dreamer',
        title: 'Travel Dreamer',
        description: 'Completed a travel goal',
        icon: Icons.flight,
        color: Colors.cyan,
        isUnlocked: goals.any((g) =>
            g.isCompleted && g.category.toLowerCase().contains('travel')),
        progress: goals
            .where((g) =>
                g.isCompleted && g.category.toLowerCase().contains('travel'))
            .length
            .toDouble(),
        target: 1,
      ),
      Achievement(
        id: 'gadget_geek',
        title: 'Gadget Geek',
        description: 'Completed a tech goal',
        icon: Icons.phone_android,
        color: Colors.indigo,
        isUnlocked: goals.any((g) =>
            g.isCompleted && g.category.toLowerCase().contains('gadget')),
        progress: goals
            .where((g) =>
                g.isCompleted && g.category.toLowerCase().contains('gadget'))
            .length
            .toDouble(),
        target: 1,
      ),
    ];
  }

  void _showGoalCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const GoalCreationDialog(),
    );
  }

  void _editGoal(SavingsGoal goal) {
    // TODO: Implement edit goal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit goal: ${goal.title}'),
        backgroundColor: const Color(0xFFFF6B35),
      ),
    );
  }

  void _deleteGoal(SavingsGoal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Goal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${goal.title}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final expenseProvider =
                  Provider.of<ExpenseProvider>(context, listen: false);
              expenseProvider.deleteSavingsGoal(goal.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Goal deleted: ${goal.title}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _addFundsToGoal(SavingsGoal goal) {
    final _formKey = GlobalKey<FormState>();
    double _amount = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Funds to Goal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Goal: ${goal.title}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ₹${goal.currentAmount.toStringAsFixed(2)} / ₹${goal.targetAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount to Add',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
                onChanged: (value) => _amount = double.tryParse(value) ?? 0.0,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final expenseProvider =
                    Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.updateSavingsGoal(goal.id, _amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Added ₹${_amount.toStringAsFixed(2)} to ${goal.title}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Add Funds',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final double progress;
  final double target;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.progress,
    required this.target,
  });
}
