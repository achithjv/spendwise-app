import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/transaction_table.dart';
import '../widgets/transaction_filters.dart';
import '../widgets/quick_stats_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory;
  String? _selectedPaymentMethod;
  double? _minAmount;
  double? _maxAmount;
  String _sortBy = 'date';
  bool _sortAscending = false;
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final allTransactions = expenseProvider.transactions;

    // Apply filters
    final filteredTransactions = _applyFilters(allTransactions);

    // Apply sorting
    final sortedTransactions = _applySorting(filteredTransactions);

    // Apply pagination
    final paginatedTransactions = _applyPagination(sortedTransactions);

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
                      'Transactions',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // Export Button
                    ElevatedButton.icon(
                      onPressed: () => _showExportDialog(context),
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

                // Quick Stats
                QuickStatsWidget(
                  transactions: filteredTransactions,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // Filters Section
          TransactionFiltersWidget(
            searchController: _searchController,
            startDate: _startDate,
            endDate: _endDate,
            selectedCategory: _selectedCategory,
            selectedPaymentMethod: _selectedPaymentMethod,
            minAmount: _minAmount,
            maxAmount: _maxAmount,
            sortBy: _sortBy,
            sortAscending: _sortAscending,
            onFiltersChanged: _onFiltersChanged,
            isDark: isDark,
          ),

          // Transactions Table
          Expanded(
            child: paginatedTransactions.isEmpty
                ? _buildEmptyState(isDark)
                : TransactionTableWidget(
                    transactions: paginatedTransactions,
                    onEdit: _editTransaction,
                    onDelete: _deleteTransaction,
                    isDark: isDark,
                  ),
          ),

          // Pagination
          if (sortedTransactions.length > _itemsPerPage)
            _buildPagination(sortedTransactions.length, isDark),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Transaction> _applyFilters(List<Transaction> transactions) {
    return transactions.where((transaction) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        if (!transaction.title.toLowerCase().contains(searchTerm) &&
            !transaction.category.toLowerCase().contains(searchTerm)) {
          return false;
        }
      }

      // Date range filter
      if (_startDate != null && transaction.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.date.isAfter(_endDate!)) {
        return false;
      }

      // Category filter
      if (_selectedCategory != null &&
          transaction.category != _selectedCategory) {
        return false;
      }

      // Payment method filter
      if (_selectedPaymentMethod != null &&
          transaction.paymentMethod != _selectedPaymentMethod) {
        return false;
      }

      // Amount range filter
      if (_minAmount != null && transaction.amount < _minAmount!) {
        return false;
      }
      if (_maxAmount != null && transaction.amount > _maxAmount!) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Transaction> _applySorting(List<Transaction> transactions) {
    final sorted = List<Transaction>.from(transactions);

    switch (_sortBy) {
      case 'date':
        sorted.sort((a, b) => _sortAscending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
        break;
      case 'amount':
        sorted.sort((a, b) => _sortAscending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount));
        break;
      case 'category':
        sorted.sort((a, b) => _sortAscending
            ? a.category.compareTo(b.category)
            : b.category.compareTo(a.category));
        break;
      case 'title':
        sorted.sort((a, b) => _sortAscending
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
    }

    return sorted;
  }

  List<Transaction> _applyPagination(List<Transaction> transactions) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= transactions.length) {
      return [];
    }

    return transactions.sublist(
      startIndex,
      endIndex > transactions.length ? transactions.length : endIndex,
    );
  }

  void _onFiltersChanged({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? paymentMethod,
    double? minAmount,
    double? maxAmount,
    String? sortBy,
    bool? sortAscending,
  }) {
    setState(() {
      _startDate = startDate ?? _startDate;
      _endDate = endDate ?? _endDate;
      _selectedCategory = category ?? _selectedCategory;
      _selectedPaymentMethod = paymentMethod ?? _selectedPaymentMethod;
      _minAmount = minAmount ?? _minAmount;
      _maxAmount = maxAmount ?? _maxAmount;
      _sortBy = sortBy ?? _sortBy;
      _sortAscending = sortAscending ?? _sortAscending;
      _currentPage = 1; // Reset to first page when filters change
    });
  }

  void _editTransaction(Transaction transaction) {
    final _formKey = GlobalKey<FormState>();
    String _title = transaction.title;
    double _amount = transaction.amount;
    String _category = transaction.category;
    String _type = transaction.type;
    String _paymentMethod = transaction.paymentMethod;
    DateTime _date = transaction.date;
    String _description = transaction.description ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Transaction',
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
                  // Transaction Type
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Expense', style: GoogleFonts.poppins()),
                          value: 'expense',
                          groupValue: _type,
                          onChanged: (value) {
                            _type = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Income', style: GoogleFonts.poppins()),
                          value: 'income',
                          groupValue: _type,
                          onChanged: (value) {
                            _type = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) => _title = value,
                  ),

                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    initialValue: _amount.toString(),
                    decoration: InputDecoration(
                      labelText: 'Amount',
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
                    onChanged: (value) =>
                        _amount = double.tryParse(value) ?? 0.0,
                  ),

                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    value: _category,
                    items: _type == 'expense'
                        ? [
                            'Food',
                            'Transport',
                            'Shopping',
                            'Bills',
                            'Entertainment',
                            'Health',
                            'Education',
                            'Other'
                          ]
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category,
                                      style: GoogleFonts.poppins()),
                                ))
                            .toList()
                        : ['Salary', 'Freelance', 'Investment', 'Gift', 'Other']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category,
                                      style: GoogleFonts.poppins()),
                                ))
                            .toList(),
                    onChanged: (value) => _category = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Payment Method
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.payment),
                    ),
                    value: _paymentMethod,
                    items: [
                      'Cash',
                      'Credit Card',
                      'Debit Card',
                      'UPI',
                      'Bank Transfer',
                      'Digital Wallet'
                    ]
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method, style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) => _paymentMethod = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a payment method';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Date
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        _date = date;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(_date),
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _description = value,
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
                // For now, we'll delete the old transaction and add a new one
                // In a real app, you would have an updateTransaction method
                final expenseProvider =
                    Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.deleteTransaction(transaction.id);
                expenseProvider.addTransaction(
                  title: _title,
                  amount: _amount,
                  type: _type,
                  category: _category,
                  date: _date,
                  description: _description,
                  paymentMethod: _paymentMethod,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Transaction updated: $_title'),
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
              'Update Transaction',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Transaction',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${transaction.title}"?',
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
              expenseProvider.deleteTransaction(transaction.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transaction deleted: ${transaction.title}'),
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

  void _showAddTransactionDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _title = '';
    double _amount = 0.0;
    String _category = 'Food';
    String _type = 'expense';
    String _paymentMethod = 'Cash';
    DateTime _date = DateTime.now();
    String _description = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Transaction',
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
                  // Transaction Type
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Expense', style: GoogleFonts.poppins()),
                          value: 'expense',
                          groupValue: _type,
                          onChanged: (value) {
                            _type = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Income', style: GoogleFonts.poppins()),
                          value: 'income',
                          groupValue: _type,
                          onChanged: (value) {
                            _type = value!;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) => _title = value,
                  ),

                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
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
                    onChanged: (value) =>
                        _amount = double.tryParse(value) ?? 0.0,
                  ),

                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    value: _category,
                    items: _type == 'expense'
                        ? [
                            'Food',
                            'Transport',
                            'Shopping',
                            'Bills',
                            'Entertainment',
                            'Health',
                            'Education',
                            'Other'
                          ]
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category,
                                      style: GoogleFonts.poppins()),
                                ))
                            .toList()
                        : ['Salary', 'Freelance', 'Investment', 'Gift', 'Other']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category,
                                      style: GoogleFonts.poppins()),
                                ))
                            .toList(),
                    onChanged: (value) => _category = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Payment Method
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.payment),
                    ),
                    value: _paymentMethod,
                    items: [
                      'Cash',
                      'Credit Card',
                      'Debit Card',
                      'UPI',
                      'Bank Transfer',
                      'Digital Wallet'
                    ]
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method, style: GoogleFonts.poppins()),
                            ))
                        .toList(),
                    onChanged: (value) => _paymentMethod = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a payment method';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Date
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        _date = date;
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(_date),
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _description = value,
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
                final expenseProvider =
                    Provider.of<ExpenseProvider>(context, listen: false);
                expenseProvider.addTransaction(
                  title: _title,
                  amount: _amount,
                  type: _type,
                  category: _category,
                  date: _date,
                  description: _description,
                  paymentMethod: _paymentMethod,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Transaction added: $_title'),
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
              'Add Transaction',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Export Transactions',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text('Export as CSV', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _exportToCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('Export as PDF', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _exportToPDF();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _exportToCSV() {
    try {
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      final allTransactions = expenseProvider.transactions;
      final filteredTransactions = _applyFilters(allTransactions);

      final csvData = StringBuffer();

      // Add CSV header
      csvData.writeln(
          'Date,Title,Category,Type,Amount,Payment Method,Description');

      // Add transaction data
      for (final transaction in filteredTransactions) {
        final date = DateFormat('yyyy-MM-dd').format(transaction.date);
        final title = transaction.title.replaceAll(',', ';'); // Escape commas
        final category = transaction.category.replaceAll(',', ';');
        final type = transaction.type;
        final amount = transaction.amount.toStringAsFixed(2);
        final paymentMethod = transaction.paymentMethod.replaceAll(',', ';');
        final description = (transaction.description ?? '')
            .replaceAll(',', ';')
            .replaceAll('\n', ' ');

        csvData.writeln(
            '$date,$title,$category,$type,$amount,$paymentMethod,$description');
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'CSV data ready for download (${filteredTransactions.length} transactions)'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Copy',
            onPressed: () {
              // In a real app, you would save this to a file
              // For now, we'll just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CSV data copied to clipboard (simulated)'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting CSV: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportToPDF() {
    try {
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      final allTransactions = expenseProvider.transactions;
      final filteredTransactions = _applyFilters(allTransactions);

      // Generate PDF content (simulated)
      final pdfContent = StringBuffer();
      pdfContent.writeln('SPENDWISE - TRANSACTION REPORT');
      pdfContent.writeln(
          'Generated on: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}');
      pdfContent.writeln('Total Transactions: ${filteredTransactions.length}');
      pdfContent.writeln('');
      pdfContent
          .writeln('Date | Title | Category | Type | Amount | Payment Method');
      pdfContent
          .writeln('-----|-------|----------|------|--------|----------------');

      for (final transaction in filteredTransactions) {
        final date = DateFormat('MMM dd').format(transaction.date);
        final title = transaction.title;
        final category = transaction.category;
        final type = transaction.type;
        final amount = transaction.amount.toStringAsFixed(2);
        final paymentMethod = transaction.paymentMethod;

        pdfContent.writeln(
            '$date | $title | $category | $type | ₹$amount | $paymentMethod');
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'PDF report generated (${filteredTransactions.length} transactions)'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              // In a real app, you would open the PDF
              // For now, we'll just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF report opened (simulated)'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No transactions found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try adjusting your filters or add a new transaction',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalItems, bool isDark) {
    final totalPages = (totalItems / _itemsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:
                _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFFFF6B35) : Colors.grey,
          ),
          const SizedBox(width: 20),
          Text(
            'Page $_currentPage of $totalPages',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < totalPages
                ? const Color(0xFFFF6B35)
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}
