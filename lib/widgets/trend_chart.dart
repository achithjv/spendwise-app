import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final bool isDark;
  final bool showComparison;

  const TrendChart({
    super.key,
    required this.data,
    required this.isDark,
    required this.showComparison,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    final sortedData = List<Map<String, dynamic>>.from(widget.data)
      ..sort(
          (a, b) => _parseMonth(a['month']).compareTo(_parseMonth(b['month'])));

    return Column(
      children: [
        // Interactive Chart
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
                    'Financial Trends',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      _buildLegendItem('Income', Colors.green),
                      const SizedBox(width: 16),
                      _buildLegendItem('Expense', Colors.red),
                      if (widget.showComparison) ...[
                        const SizedBox(width: 16),
                        _buildLegendItem('Balance', Colors.blue),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 1000,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: widget.isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: widget.isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < sortedData.length) {
                              final month =
                                  sortedData[value.toInt()]['month'] as String;
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  month.split(' ')[0],
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: widget.isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1000,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              '₹${(value / 1000).toStringAsFixed(0)}k',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: widget.isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            );
                          },
                          reservedSize: 42,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: widget.isDark
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                      ),
                    ),
                    minX: 0,
                    maxX: (sortedData.length - 1).toDouble(),
                    minY: 0,
                    maxY: _getMaxValue(sortedData),
                    lineBarsData: [
                      // Income Line
                      LineChartBarData(
                        spots: _getSpots(sortedData, 'income'),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.green.withValues(alpha: 0.5)
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.green,
                              strokeWidth: 2,
                              strokeColor:
                                  widget.isDark ? Colors.black : Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withValues(alpha: 0.3),
                              Colors.green.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                      // Expense Line
                      LineChartBarData(
                        spots: _getSpots(sortedData, 'expense'),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.red.withValues(alpha: 0.5)
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.red,
                              strokeWidth: 2,
                              strokeColor:
                                  widget.isDark ? Colors.black : Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withValues(alpha: 0.3),
                              Colors.red.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                      // Balance Line (if showComparison is true)
                      if (widget.showComparison)
                        LineChartBarData(
                          spots: _getSpots(sortedData, 'balance'),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.withValues(alpha: 0.5)
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.blue,
                                strokeWidth: 2,
                                strokeColor:
                                    widget.isDark ? Colors.black : Colors.white,
                              );
                            },
                          ),
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor:
                            widget.isDark ? Colors.grey[800]! : Colors.white,
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final index = barSpot.x.toInt();
                            if (index >= 0 && index < sortedData.length) {
                              final monthData = sortedData[index];
                              final month = monthData['month'] as String;
                              final income = monthData['income'] as double;
                              final expense = monthData['expense'] as double;
                              final balance = income - expense;

                              return LineTooltipItem(
                                '$month\n',
                                GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Income: ₹${income.toStringAsFixed(2)}\n',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Expense: ₹${expense.toStringAsFixed(2)}\n',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Balance: ₹${balance.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: balance >= 0
                                          ? Colors.blue
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return null;
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Monthly Data List
        ...sortedData.map((monthData) {
          final month = monthData['month'] as String;
          final income = monthData['income'] as double;
          final expense = monthData['expense'] as double;
          final balance = income - expense;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: balance >= 0
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      month,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: balance >= 0
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        balance >= 0 ? 'Surplus' : 'Deficit',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: balance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTrendItem(
                        'Income',
                        '₹${income.toStringAsFixed(2)}',
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrendItem(
                        'Expense',
                        '₹${expense.toStringAsFixed(2)}',
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrendItem(
                        'Balance',
                        '₹${balance.toStringAsFixed(2)}',
                        balance >= 0 ? Colors.blue : Colors.red,
                        Icons.account_balance_wallet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots(List<Map<String, dynamic>> data, String type) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final monthData = entry.value;

      double value;
      if (type == 'balance') {
        final income = monthData['income'] as double;
        final expense = monthData['expense'] as double;
        value = income - expense;
      } else {
        value = monthData[type] as double;
      }

      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  double _getMaxValue(List<Map<String, dynamic>> data) {
    double maxValue = 0;
    for (final monthData in data) {
      final income = monthData['income'] as double;
      final expense = monthData['expense'] as double;
      maxValue = maxValue < income ? income : maxValue;
      maxValue = maxValue < expense ? expense : maxValue;
    }
    return maxValue * 1.2; // Add 20% padding
  }

  Widget _buildTrendItem(
      String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
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
              Icons.show_chart,
              size: 48,
              color: widget.isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No trend data',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            Text(
              'Add transactions to see trends',
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

  DateTime _parseMonth(String monthStr) {
    // Simple parsing for "MMM yyyy" format
    final parts = monthStr.split(' ');
    if (parts.length == 2) {
      final month = parts[0];
      final year = int.tryParse(parts[1]) ?? DateTime.now().year;

      final monthMap = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };

      final monthNum = monthMap[month] ?? 1;
      return DateTime(year, monthNum);
    }
    return DateTime.now();
  }
}
