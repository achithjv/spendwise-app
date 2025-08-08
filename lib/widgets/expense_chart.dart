import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatefulWidget {
  final Map<String, double> data;
  final String viewType;
  final bool isDark;
  final Function(String)? onCategorySelected;

  const ExpenseChart({
    super.key,
    required this.data,
    required this.viewType,
    required this.isDark,
    this.onCategorySelected,
  });

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    final total = widget.data.values.fold(0.0, (sum, amount) => sum + amount);
    final sortedData = widget.data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        // Interactive Pie Chart
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense Breakdown',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'Total: ₹${total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse?.touchedSection != null) {
                                  touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _buildPieSections(sortedData, total),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...sortedData.take(5).map((entry) {
                            final percentage = (entry.value / total * 100);
                            final color = _getCategoryColor(entry.key);
                            final isSelected = touchedIndex == sortedData.indexOf(entry);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: widget.isDark ? Colors.white : Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Category List
        ...sortedData.map((entry) {
          final percentage = (entry.value / total * 100);
          final color = _getCategoryColor(entry.key);
          
          return GestureDetector(
            onTap: () => widget.onCategorySelected?.call(entry.key),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    widget.viewType == 'Amount' 
                        ? '₹${entry.value.toStringAsFixed(2)}'
                        : '${percentage.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.3);
        }).toList(),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections(List<MapEntry<String, double>> data, double total) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryData = entry.value;
      final percentage = (categoryData.value / total * 100);
      final color = _getCategoryColor(categoryData.key);
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: color,
        value: categoryData.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 48,
              color: widget.isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No expense data',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            Text(
              'Add some expenses to see the breakdown',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: widget.isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Food': Colors.orange,
      'Transportation': Colors.blue,
      'Shopping': Colors.purple,
      'Bills': Colors.red,
      'Entertainment': Colors.pink,
      'Healthcare': Colors.green,
      'Education': Colors.indigo,
      'Salary': Colors.green,
      'Freelance': Colors.teal,
      'Investment': Colors.amber,
      'Business': Colors.cyan,
      'Other': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
}
