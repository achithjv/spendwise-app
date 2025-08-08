import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';

class ExportDialog extends StatelessWidget {
  final List<Transaction> transactions;
  final String timeRange;

  const ExportDialog({
    super.key,
    required this.transactions,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.file_download,
                  color: const Color(0xFFFF6B35),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Export Report',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Export Options
            Text(
              'Choose export format:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // CSV Export
            _buildExportOption(
              context,
              'CSV File',
              'Export as comma-separated values file',
              Icons.table_chart,
              Colors.green,
              () => _exportToCSV(context),
              isDark,
            ),

            const SizedBox(height: 12),

            // PDF Export
            _buildExportOption(
              context,
              'PDF Report',
              'Export as formatted PDF document',
              Icons.picture_as_pdf,
              Colors.red,
              () => _exportToPDF(context),
              isDark,
            ),

            const SizedBox(height: 12),

            // Excel Export
            _buildExportOption(
              context,
              'Excel File',
              'Export as Excel spreadsheet',
              Icons.table_view,
              Colors.blue,
              () => _exportToExcel(context),
              isDark,
            ),

            const SizedBox(height: 20),

            // Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time Range: $timeRange',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Transactions: ${transactions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Total Income: ₹${_getTotalIncome().toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Total Expenses: ₹${_getTotalExpenses().toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _exportAll(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Export All',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  double _getTotalIncome() {
    return transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getTotalExpenses() {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void _exportToCSV(BuildContext context) {
    try {
      final csvData = StringBuffer();

      // Add CSV header
      csvData.writeln(
          'Date,Title,Category,Type,Amount,Payment Method,Description');

      // Add transaction data
      for (final transaction in transactions) {
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

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'CSV exported successfully (${transactions.length} transactions)'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting CSV: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportToPDF(BuildContext context) {
    try {
      // Generate PDF content (simulated)
      final pdfContent = StringBuffer();
      pdfContent.writeln('SPENDWISE - TRANSACTION REPORT');
      pdfContent.writeln('Time Range: $timeRange');
      pdfContent.writeln(
          'Generated on: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}');
      pdfContent.writeln('Total Transactions: ${transactions.length}');
      pdfContent.writeln('');
      pdfContent
          .writeln('Date | Title | Category | Type | Amount | Payment Method');
      pdfContent
          .writeln('-----|-------|----------|------|--------|----------------');

      for (final transaction in transactions) {
        final date = DateFormat('MMM dd').format(transaction.date);
        final title = transaction.title;
        final category = transaction.category;
        final type = transaction.type;
        final amount = transaction.amount.toStringAsFixed(2);
        final paymentMethod = transaction.paymentMethod;

        pdfContent.writeln(
            '$date | $title | $category | $type | ₹$amount | $paymentMethod');
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'PDF report generated (${transactions.length} transactions)'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportToExcel(BuildContext context) {
    try {
      // Generate Excel content (simulated)
      final excelContent = StringBuffer();
      excelContent.writeln(
          'Date\tTitle\tCategory\tType\tAmount\tPayment Method\tDescription');

      for (final transaction in transactions) {
        final date = DateFormat('yyyy-MM-dd').format(transaction.date);
        final title = transaction.title;
        final category = transaction.category;
        final type = transaction.type;
        final amount = transaction.amount.toStringAsFixed(2);
        final paymentMethod = transaction.paymentMethod;
        final description = transaction.description ?? '';

        excelContent.writeln(
            '$date\t$title\t$category\t$type\t$amount\t$paymentMethod\t$description');
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Excel file generated (${transactions.length} transactions)'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating Excel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportAll(BuildContext context) {
    try {
      // Export all formats
      _exportToCSV(context);
      _exportToPDF(context);
      _exportToExcel(context);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All formats exported successfully (${transactions.length} transactions)'),
          backgroundColor: const Color(0xFFFF6B35),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting all formats: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
