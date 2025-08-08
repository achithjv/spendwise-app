import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/financial_snapshot.dart';
import '../widgets/personalization_section.dart';
import '../widgets/achievements_summary.dart';
import '../widgets/quick_actions.dart';
import '../widgets/privacy_security.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final transactions = expenseProvider.transactions;
    final goals = expenseProvider.savingsGoals;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            ProfileHeader(
              isDark: isDark,
              authProvider: authProvider,
            ),

            const SizedBox(height: 30),

            // Financial Snapshot Section
            FinancialSnapshot(
              transactions: transactions,
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            // Personalization Section
            PersonalizationSection(
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            // Achievements & Goals Summary
            AchievementsSummary(
              goals: goals,
              transactions: transactions,
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            // Quick Actions Section
            QuickActions(
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            // Privacy & Security Section
            PrivacySecurity(
              isDark: isDark,
            ),

            const SizedBox(height: 30),

            // Logout Button
            _buildLogoutButton(isDark, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isDark, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
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
            'Account Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context, authProvider),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showDeleteAccountDialog(context, authProvider),
                  icon: const Icon(Icons.delete_forever),
                  label: Text(
                    'Delete Account',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
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
              authProvider.logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmTextController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete Account',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What will be deleted:',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDeleteItem('All transactions and financial data'),
                    _buildDeleteItem('Savings goals and progress'),
                    _buildDeleteItem('Account settings and preferences'),
                    _buildDeleteItem('Profile information'),
                    _buildDeleteItem('App usage history'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value != 'password123') {
                    // Demo validation
                    return 'Password is incorrect';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmTextController,
                decoration: InputDecoration(
                  labelText: 'Type "DELETE" to confirm',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type DELETE to confirm';
                  }
                  if (value != 'DELETE') {
                    return 'Please type DELETE exactly';
                  }
                  return null;
                },
              ),
            ],
          ),
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
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _processAccountDeletion(context, authProvider);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete Account',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteItem(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processAccountDeletion(
      BuildContext context, AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'Deleting your account...',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate account deletion process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Account Deleted',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            'Your account has been permanently deleted. All your data has been removed from our servers.',
            style: GoogleFonts.poppins(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Clear all data and logout
                final expenseProvider =
                    Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.clearAllData();
                authProvider.logout();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
