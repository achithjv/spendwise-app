import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_chart.dart';
import '../widgets/trend_chart.dart';
import '../widgets/insights_widget.dart';
import '../widgets/export_dialog.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedTimeRange = 'This Month';
  String _selectedView = 'Amount';
  String? _selectedCategory;
  bool _showComparison = false;
  DateTime? _comparisonDate;

  final List<String> _timeRanges = [
    'This Month',
    'Last Month',
    'Last 3 Months',
    'Year-to-Date',
    'Custom Range',
  ];

  final List<String> _viewOptions = [
    'Amount',
    'Percentage',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final transactions = expenseProvider.transactions;

    // Filter transactions based on selected time range
    final filteredTransactions = _getFilteredTransactions(transactions);
    final categoryData = _getCategoryData(filteredTransactions);
    final monthlyData = _getMonthlyData(transactions);

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
                      'Reports & Analytics',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // Export Button
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showExportDialog(context, filteredTransactions),
                      icon: const Icon(Icons.file_download),
                      label: Text(
                        'Export',
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

                // Filters Row
                Row(
                  children: [
                    // Time Range Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedTimeRange,
                        decoration: InputDecoration(
                          labelText: 'Time Range',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.grey[50],
                        ),
                        items: _timeRanges.map((range) {
                          return DropdownMenuItem(
                            value: range,
                            child: Text(range, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedTimeRange = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),

                    // View Type Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedView,
                        decoration: InputDecoration(
                          labelText: 'View',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.grey[50],
                        ),
                        items: _viewOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedView = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Comparison Toggle
                    Switch(
                      value: _showComparison,
                      onChanged: (value) =>
                          setState(() => _showComparison = value),
                      activeColor: const Color(0xFFFF6B35),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Compare',
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary & Highlights Section
                  _buildSummarySection(isDark, filteredTransactions),

                  const SizedBox(height: 30),

                  // Visual Analysis Section
                  _buildVisualAnalysisSection(
                      isDark, categoryData, monthlyData),

                  const SizedBox(height: 30),

                  // Details & Actions Section
                  _buildDetailsSection(isDark, filteredTransactions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(bool isDark, List<Transaction> transactions) {
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = totalIncome - totalExpenses;
    final savingsRate = totalIncome > 0 ? (balance / totalIncome * 100) : 0;

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
            'Summary & Highlights',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Income',
                  '₹${totalIncome.toStringAsFixed(2)}',
                  Colors.green,
                  Icons.trending_up,
                  isDark,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryCard(
                  'Total Expenses',
                  '₹${totalExpenses.toStringAsFixed(2)}',
                  Colors.red,
                  Icons.trending_down,
                  isDark,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryCard(
                  'Net Balance',
                  '₹${balance.toStringAsFixed(2)}',
                  balance >= 0 ? Colors.blue : Colors.red,
                  Icons.account_balance_wallet,
                  isDark,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryCard(
                  'Savings Rate',
                  '${savingsRate.toStringAsFixed(1)}%',
                  savingsRate >= 20
                      ? Colors.green
                      : savingsRate >= 10
                          ? Colors.orange
                          : Colors.red,
                  Icons.savings,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Insights
          InsightsWidget(
            transactions: transactions,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildVisualAnalysisSection(
      bool isDark,
      Map<String, double> categoryData,
      List<Map<String, dynamic>> monthlyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visual Analysis',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        // Charts Row
        Row(
          children: [
            // Expense Breakdown Chart
            Expanded(
              child: Container(
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
                      'Expense Breakdown',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ExpenseChart(
                      data: categoryData,
                      viewType: _selectedView,
                      isDark: isDark,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Monthly Trends Chart
            Expanded(
              child: Container(
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
                      'Monthly Trends',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TrendChart(
                      data: monthlyData,
                      isDark: isDark,
                      showComparison: _showComparison,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection(bool isDark, List<Transaction> transactions) {
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
            'Details & Actions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showExportDialog(context, transactions),
                  icon: const Icon(Icons.file_download),
                  label: Text(
                    'Export Report',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
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
                child: ElevatedButton.icon(
                  onPressed: () => _showCustomReportDialog(context),
                  icon: const Icon(Icons.build),
                  label: Text(
                    'Custom Report',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                child: ElevatedButton.icon(
                  onPressed: () => _showComparisonDialog(context),
                  icon: const Icon(Icons.compare),
                  label: Text(
                    'Compare',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Transaction List (if category is selected)
          if (_selectedCategory != null) ...[
            Text(
              'Transactions in $_selectedCategory',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: transactions
                    .where((t) => t.category == _selectedCategory)
                    .length,
                itemBuilder: (context, index) {
                  final categoryTransactions = transactions
                      .where((t) => t.category == _selectedCategory)
                      .toList();
                  final transaction = categoryTransactions[index];

                  return ListTile(
                    leading: Icon(
                      transaction.type == 'income'
                          ? Icons.add_circle
                          : Icons.remove_circle,
                      color: transaction.type == 'income'
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(
                      transaction.title,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(transaction.date),
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      '${transaction.type == 'income' ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: transaction.type == 'income'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color color, IconData icon, bool isDark) {
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

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedTimeRange) {
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Last Month':
        startDate = DateTime(now.year, now.month - 1, 1);
        break;
      case 'Last 3 Months':
        startDate = DateTime(now.year, now.month - 3, 1);
        break;
      case 'Year-to-Date':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month - 1, 1);
    }

    return transactions.where((t) => t.date.isAfter(startDate)).toList();
  }

  Map<String, double> _getCategoryData(List<Transaction> transactions) {
    final Map<String, double> categoryData = {};

    for (final transaction in transactions.where((t) => t.type == 'expense')) {
      categoryData[transaction.category] =
          (categoryData[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryData;
  }

  List<Map<String, dynamic>> _getMonthlyData(List<Transaction> transactions) {
    final Map<String, Map<String, double>> monthlyData = {};

    for (final transaction in transactions) {
      final monthKey = DateFormat('MMM yyyy').format(transaction.date);
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = {'income': 0, 'expense': 0};
      }

      if (transaction.type == 'income') {
        monthlyData[monthKey]!['income'] =
            (monthlyData[monthKey]!['income'] ?? 0) + transaction.amount;
      } else {
        monthlyData[monthKey]!['expense'] =
            (monthlyData[monthKey]!['expense'] ?? 0) + transaction.amount;
      }
    }

    return monthlyData.entries.map((entry) {
      return {
        'month': entry.key,
        'income': entry.value['income'] ?? 0,
        'expense': entry.value['expense'] ?? 0,
      };
    }).toList();
  }

  void _showExportDialog(BuildContext context, List<Transaction> transactions) {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(
        transactions: transactions,
        timeRange: _selectedTimeRange,
      ),
    );
  }

  void _showCustomReportDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _reportTitle = 'Custom Report';
    List<String> _selectedCategories = [];
    DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime _endDate = DateTime.now();
    String _reportType = 'summary';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create Custom Report',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Report Title
                  TextFormField(
                    initialValue: _reportTitle,
                    decoration: InputDecoration(
                      labelText: 'Report Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a report title';
                      }
                      return null;
                    },
                    onChanged: (value) => _reportTitle = value,
                  ),

                  const SizedBox(height: 16),

                  // Report Type
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Report Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.analytics),
                    ),
                    value: _reportType,
                    items: [
                      'summary',
                      'detailed',
                      'category-breakdown',
                      'trend-analysis'
                    ]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                  type.replaceAll('-', ' ').toUpperCase(),
                                  style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) => _reportType = value!,
                  ),

                  const SizedBox(height: 16),

                  // Date Range
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _startDate = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_startDate),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _endDate = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_endDate),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Categories (Optional)
                  Text(
                    'Categories (Optional)',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      'Food',
                      'Transport',
                      'Shopping',
                      'Bills',
                      'Entertainment',
                      'Health',
                      'Education'
                    ]
                        .map((category) => FilterChip(
                              label:
                                  Text(category, style: GoogleFonts.poppins()),
                              selected: _selectedCategories.contains(category),
                              onSelected: (selected) {
                                if (selected) {
                                  _selectedCategories.add(category);
                                } else {
                                  _selectedCategories.remove(category);
                                }
                                (context as Element).markNeedsBuild();
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Custom report "$_reportTitle" generated successfully'),
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
              'Generate Report',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showComparisonDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    DateTime _period1Start = DateTime.now().subtract(const Duration(days: 30));
    DateTime _period1End = DateTime.now();
    DateTime _period2Start = DateTime.now().subtract(const Duration(days: 60));
    DateTime _period2End = DateTime.now().subtract(const Duration(days: 31));
    String _comparisonType = 'month-over-month';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Compare Spending Periods',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 450,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Comparison Type
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Comparison Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.compare_arrows),
                    ),
                    value: _comparisonType,
                    items: [
                      'month-over-month',
                      'quarter-over-quarter',
                      'year-over-year',
                      'custom'
                    ]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                  type.replaceAll('-', ' ').toUpperCase(),
                                  style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) => _comparisonType = value!,
                  ),

                  const SizedBox(height: 20),

                  // Period 1
                  Text(
                    'Current Period',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _period1Start,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _period1Start = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_period1Start),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _period1End,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _period1End = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_period1End),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Period 2
                  Text(
                    'Previous Period',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _period2Start,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _period2Start = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_period2Start),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _period2End,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _period2End = date;
                              (context as Element).markNeedsBuild();
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_period2End),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Comparison Preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comparison Preview:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current: ${DateFormat('MMM dd').format(_period1Start)} - ${DateFormat('MMM dd').format(_period1End)}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        Text(
                          'Previous: ${DateFormat('MMM dd').format(_period2Start)} - ${DateFormat('MMM dd').format(_period2End)}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Comparison report generated successfully'),
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
              'Generate Comparison',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
