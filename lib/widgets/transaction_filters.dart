import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class TransactionFiltersWidget extends StatefulWidget {
  final TextEditingController searchController;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedCategory;
  final String? selectedPaymentMethod;
  final double? minAmount;
  final double? maxAmount;
  final String sortBy;
  final bool sortAscending;
  final Function({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? paymentMethod,
    double? minAmount,
    double? maxAmount,
    String? sortBy,
    bool? sortAscending,
  }) onFiltersChanged;
  final bool isDark;

  const TransactionFiltersWidget({
    super.key,
    required this.searchController,
    required this.startDate,
    required this.endDate,
    required this.selectedCategory,
    required this.selectedPaymentMethod,
    required this.minAmount,
    required this.maxAmount,
    required this.sortBy,
    required this.sortAscending,
    required this.onFiltersChanged,
    required this.isDark,
  });

  @override
  State<TransactionFiltersWidget> createState() => _TransactionFiltersWidgetState();
}

class _TransactionFiltersWidgetState extends State<TransactionFiltersWidget> {
  bool _showAdvancedFilters = false;

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Shopping',
    'Bills',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other',
    'Salary',
    'Freelance',
    'Investment',
    'Business',
  ];

  final List<String> _paymentMethods = [
    'Cash',
    'Card',
    'UPI',
    'Bank Transfer',
    'Digital Wallet',
    'Other',
  ];

  final List<String> _sortOptions = [
    'date',
    'amount',
    'category',
    'title',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Basic Filters
          Row(
            children: [
              // Search Bar
              Expanded(
                flex: 2,
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  ),
                  onChanged: (value) => widget.onFiltersChanged(),
                ),
              ),
              const SizedBox(width: 15),
              
              // Sort Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  ),
                  items: _sortOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(
                        option.toUpperCase(),
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      widget.onFiltersChanged(sortBy: value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 15),
              
              // Sort Direction
              IconButton(
                onPressed: () => widget.onFiltersChanged(sortAscending: !widget.sortAscending),
                icon: Icon(
                  widget.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: const Color(0xFFFF6B35),
                ),
              ),
              
              // Advanced Filters Toggle
              TextButton.icon(
                onPressed: () => setState(() => _showAdvancedFilters = !_showAdvancedFilters),
                icon: Icon(
                  _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFFFF6B35),
                ),
                label: Text(
                  'Advanced Filters',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFF6B35),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Advanced Filters
          if (_showAdvancedFilters) ...[
            const SizedBox(height: 20),
            _buildAdvancedFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Column(
      children: [
        // Date Range and Category
        Row(
          children: [
            // Start Date
            Expanded(
              child: _buildDateField(
                'Start Date',
                widget.startDate,
                (date) => widget.onFiltersChanged(startDate: date),
              ),
            ),
            const SizedBox(width: 15),
            
            // End Date
            Expanded(
              child: _buildDateField(
                'End Date',
                widget.endDate,
                (date) => widget.onFiltersChanged(endDate: date),
              ),
            ),
            const SizedBox(width: 15),
            
            // Category Filter
            Expanded(
              child: DropdownButtonFormField<String>(
                value: widget.selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ..._categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                ],
                onChanged: (value) => widget.onFiltersChanged(category: value),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Payment Method and Amount Range
        Row(
          children: [
            // Payment Method
            Expanded(
              child: DropdownButtonFormField<String>(
                value: widget.selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Methods'),
                  ),
                  ..._paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                ],
                onChanged: (value) => widget.onFiltersChanged(paymentMethod: value),
              ),
            ),
            const SizedBox(width: 15),
            
            // Min Amount
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Min Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  widget.onFiltersChanged(minAmount: amount);
                },
              ),
            ),
            const SizedBox(width: 15),
            
            // Max Amount
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Max Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  widget.onFiltersChanged(maxAmount: amount);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Clear Filters Button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                widget.searchController.clear();
                widget.onFiltersChanged(
                  startDate: null,
                  endDate: null,
                  category: null,
                  paymentMethod: null,
                  minAmount: null,
                  maxAmount: null,
                  sortBy: 'date',
                  sortAscending: false,
                );
              },
              icon: const Icon(Icons.clear, color: Colors.red),
              label: Text(
                'Clear Filters',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime?) onDateSelected) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: date != null ? DateFormat('MMM dd, yyyy').format(date) : '',
      ),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
        ),
      ),
    );
  }
}
