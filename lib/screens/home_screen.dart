import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_rupee_symbol.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/dashboard_section.dart';
import '../screens/transactions_screen.dart';
import '../screens/goals_and_achievements_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Sidebar Navigation (for larger screens)
          if (MediaQuery.of(context).size.width > 768) _buildSidebar(isDark),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                _buildTopNavigationBar(isDark, authProvider),

                // Main Content
                Expanded(
                  child: _buildMainContent(isDark, authProvider),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation (for mobile)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 768
          ? _buildBottomNavigation(isDark)
          : null,
    );
  }

  Widget _buildSidebar(bool isDark) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const AnimatedRupeeSymbol(),
                const SizedBox(width: 12),
                Text(
                  'SpendWise',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildSidebarItem(Icons.dashboard, 'Dashboard', 0, isDark),
                _buildSidebarItem(
                    Icons.receipt_long, 'Transactions', 1, isDark),
                _buildSidebarItem(Icons.flag, 'Goals', 2, isDark),
                _buildSidebarItem(Icons.bar_chart, 'Reports', 3, isDark),
                _buildSidebarItem(Icons.person, 'Profile', 4, isDark),
              ],
            ),
          ),

          // Theme Toggle at Bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: const ThemeToggleButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      IconData icon, String title, int index, bool isDark) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFFF6B35)
              : isDark
                  ? Colors.grey[400]
                  : Colors.grey[600],
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? const Color(0xFFFF6B35)
                : isDark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        tileColor: isSelected
            ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildTopNavigationBar(bool isDark, AuthProvider authProvider) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2D2D2D).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              // Logo and App Name (for mobile)
              if (MediaQuery.of(context).size.width <= 768) ...[
                const SizedBox(width: 20),
                const AnimatedRupeeSymbol(),
                const SizedBox(width: 12),
                Text(
                  'SpendWise',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],

              const Spacer(),

              // Top Navigation Items (for desktop)
              if (MediaQuery.of(context).size.width > 768)
                Row(
                  children: [
                    _buildTopNavItem('Dashboard', 0, isDark),
                    _buildTopNavItem('Transactions', 1, isDark),
                    _buildTopNavItem('Goals', 2, isDark),
                    _buildTopNavItem('Reports', 3, isDark),
                    _buildTopNavItem('Profile', 4, isDark),
                  ],
                ),

              const SizedBox(width: 20),

              // User Profile/Logout
              if (authProvider.isLoggedIn)
                PopupMenuButton<String>(
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFFF6B35),
                    child: Text(
                      'U',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      authProvider.logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: isDark ? Colors.white : Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavItem(String title, int index, bool isDark) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => setState(() => _selectedIndex = index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? const Color(0xFFFF6B35)
                : isDark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isDark, AuthProvider authProvider) {
    if (!authProvider.isLoggedIn) {
      return _buildLoginScreen(isDark);
    }

    switch (_selectedIndex) {
      case 0:
        return const DashboardSection();
      case 1:
        return _buildTransactionsPage(isDark);
      case 2:
        return _buildGoalsPage(isDark);
      case 3:
        return _buildReportsPage(isDark);
      case 4:
        return _buildProfilePage(isDark);
      default:
        return const DashboardSection();
    }
  }

  Widget _buildLoginScreen(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimatedRupeeSymbol(),
            const SizedBox(height: 20),
            Text(
              'Welcome to SpendWise',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Track your expenses, manage your budget, and achieve your financial goals',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.login('demo@spendwise.com', 'password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsPage(bool isDark) {
    return const TransactionsScreen();
  }

  Widget _buildGoalsPage(bool isDark) {
    return const GoalsAndAchievementsScreen();
  }

  Widget _buildReportsPage(bool isDark) {
    return const ReportsScreen();
  }

  Widget _buildProfilePage(bool isDark) {
    return const ProfileScreen();
  }
}
