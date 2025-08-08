import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../providers/expense_provider.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final transactions = expenseProvider.transactions;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Export Data',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_download,
                    size: 80,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No data to export',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add some transactions to export your data',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Your Data',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ).animate().fadeIn(duration: 600.ms),

                  const SizedBox(height: 20),

                  Text(
                    'Choose the format and date range for your data export:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Export Options
                  _buildExportOption(
                    context,
                    'CSV Export',
                    'Export all transactions as a CSV file',
                    Icons.table_chart,
                    Colors.green,
                    () => _exportToCSV(context, transactions),
                  ),

                  const SizedBox(height: 15),

                  _buildExportOption(
                    context,
                    'PDF Report',
                    'Generate a detailed PDF report',
                    Icons.picture_as_pdf,
                    Colors.red,
                    () => _exportToPDF(context, transactions, expenseProvider),
                  ),

                  const SizedBox(height: 15),

                  _buildExportOption(
                    context,
                    'Summary Report',
                    'Export financial summary only',
                    Icons.summarize,
                    Colors.blue,
                    () => _exportSummary(context, expenseProvider),
                  ),

                  const SizedBox(height: 30),

                  // Data Preview
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Preview',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPreviewCard(
                                context,
                                'Total Transactions',
                                transactions.length.toString(),
                                Icons.receipt_long,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildPreviewCard(
                                context,
                                'Total Income',
                                '₹${expenseProvider.totalIncome.toStringAsFixed(2)}',
                                Icons.trending_up,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPreviewCard(
                                context,
                                'Total Expenses',
                                '₹${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                                Icons.trending_down,
                                Colors.red,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildPreviewCard(
                                context,
                                'Balance',
                                '₹${expenseProvider.balance.toStringAsFixed(2)}',
                                Icons.account_balance_wallet,
                                expenseProvider.balance >= 0
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildExportOption(BuildContext context, String title,
      String description, IconData icon, Color color, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3);
  }

  Widget _buildPreviewCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
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
            size: 24,
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToCSV(
      BuildContext context, List<Transaction> transactions) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showErrorDialog(context, 'Permission Denied',
            'Storage permission is required to export files.');
        return;
      }

      // Generate CSV data
      final csvData = _generateCSVData(transactions);

      // Get directory and create file
      final directory = await getExternalStorageDirectory();
      final fileName =
          'spendwise_transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory!.path}/$fileName');

      await file.writeAsString(csvData);

      // Open the file
      await OpenFile.open(file.path);

      _showExportSuccess(context, 'CSV Export',
          'Your data has been exported as CSV!\nFile saved as: $fileName');
    } catch (e) {
      _showErrorDialog(context, 'Export Failed', 'Failed to export CSV: $e');
    }
  }

  Future<void> _exportToPDF(BuildContext context,
      List<Transaction> transactions, ExpenseProvider expenseProvider) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showErrorDialog(context, 'Permission Denied',
            'Storage permission is required to export files.');
        return;
      }

      // Generate PDF
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SpendWise Financial Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Generated on: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 30),
              _buildPDFSummary(expenseProvider),
            ],
          ),
        ),
      );

      // Add transactions page
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Transaction Details',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              _buildPDFTransactionsTable(transactions),
            ],
          ),
        ),
      );

      // Save PDF
      final directory = await getExternalStorageDirectory();
      final fileName =
          'spendwise_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${directory!.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Open the file
      await OpenFile.open(file.path);

      _showExportSuccess(context, 'PDF Export',
          'Your PDF report has been generated!\nFile saved as: $fileName');
    } catch (e) {
      _showErrorDialog(context, 'Export Failed', 'Failed to generate PDF: $e');
    }
  }

  pw.Widget _buildPDFSummary(ExpenseProvider expenseProvider) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Financial Summary',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
            'Total Income: ₹${expenseProvider.totalIncome.toStringAsFixed(2)}'),
        pw.Text(
            'Total Expenses: ₹${expenseProvider.totalExpenses.toStringAsFixed(2)}'),
        pw.Text('Balance: ₹${expenseProvider.balance.toStringAsFixed(2)}'),
        pw.Text('Total Transactions: ${expenseProvider.transactions.length}'),
      ],
    );
  }

  pw.Widget _buildPDFTransactionsTable(List<Transaction> transactions) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('Date',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Title',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Amount',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Category',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Type',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
        ...transactions.map((transaction) => pw.TableRow(
              children: [
                pw.Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
                pw.Text(transaction.title),
                pw.Text('₹${transaction.amount.toStringAsFixed(2)}'),
                pw.Text(transaction.category),
                pw.Text(transaction.type),
              ],
            )),
      ],
    );
  }

  Future<void> _exportSummary(
      BuildContext context, ExpenseProvider expenseProvider) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showErrorDialog(context, 'Permission Denied',
            'Storage permission is required to export files.');
        return;
      }

      // Generate summary CSV
      final summaryData = _generateSummaryData(expenseProvider);

      // Get directory and create file
      final directory = await getExternalStorageDirectory();
      final fileName =
          'spendwise_summary_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory!.path}/$fileName');

      await file.writeAsString(summaryData);

      // Open the file
      await OpenFile.open(file.path);

      _showExportSuccess(context, 'Summary Export',
          'Your financial summary has been exported!\nFile saved as: $fileName');
    } catch (e) {
      _showErrorDialog(
          context, 'Export Failed', 'Failed to export summary: $e');
    }
  }

  String _generateCSVData(List<Transaction> transactions) {
    final csvBuffer = StringBuffer();
    csvBuffer
        .writeln('Date,Title,Amount,Category,Type,Payment Method,Description');

    for (final transaction in transactions) {
      csvBuffer.writeln(
          '${DateFormat('yyyy-MM-dd').format(transaction.date)},${transaction.title},${transaction.amount},${transaction.category},${transaction.type},${transaction.paymentMethod},${transaction.description ?? ""}');
    }

    return csvBuffer.toString();
  }

  String _generateSummaryData(ExpenseProvider expenseProvider) {
    final csvBuffer = StringBuffer();
    csvBuffer.writeln('Metric,Value');
    csvBuffer.writeln('Total Income,${expenseProvider.totalIncome}');
    csvBuffer.writeln('Total Expenses,${expenseProvider.totalExpenses}');
    csvBuffer.writeln('Balance,${expenseProvider.balance}');
    csvBuffer
        .writeln('Total Transactions,${expenseProvider.transactions.length}');
    csvBuffer.writeln('Savings Streak,${expenseProvider.savingsStreak}');
    csvBuffer.writeln('Total Badges,${expenseProvider.totalBadges}');

    // Add category breakdown
    final categoryExpenses = <String, double>{};
    for (final transaction
        in expenseProvider.transactions.where((t) => t.type == 'expense')) {
      categoryExpenses[transaction.category] =
          (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }

    csvBuffer.writeln(',');
    csvBuffer.writeln('Category Breakdown,');
    for (final entry in categoryExpenses.entries) {
      csvBuffer.writeln('${entry.key},${entry.value}');
    }

    return csvBuffer.toString();
  }

  void _showExportSuccess(BuildContext context, String title, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
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
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
  }
}
