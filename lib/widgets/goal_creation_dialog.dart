import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';

class GoalCreationDialog extends StatefulWidget {
  const GoalCreationDialog({super.key});

  @override
  State<GoalCreationDialog> createState() => _GoalCreationDialogState();
}

class _GoalCreationDialogState extends State<GoalCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  
  String _selectedCategory = 'Travel';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  Color _selectedColor = Colors.blue;
  bool _isPrivate = true;

  final List<String> _categories = [
    'Travel',
    'Gadgets',
    'Education',
    'Debt Payoff',
    'Home',
    'Car',
    'Wedding',
    'Business',
    'Other',
  ];

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    color: _selectedColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Goal',
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
              
              const SizedBox(height: 24),
              
              // Goal Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  hintText: 'e.g., Trip to Europe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category and Color
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _colors.length,
                            itemBuilder: (context, index) {
                              final color = _colors[index];
                              final isSelected = color == _selectedColor;
                              
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = color),
                                child: Container(
                                  width: 40,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ] : null,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Amount Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _targetAmountController,
                      decoration: InputDecoration(
                        labelText: 'Target Amount',
                        prefixText: '₹',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentAmountController,
                      decoration: InputDecoration(
                        labelText: 'Current Amount',
                        prefixText: '₹',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Target Date
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (selectedDate != null) {
                    setState(() => _selectedDate = selectedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Target Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                        style: GoogleFonts.poppins(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Privacy Toggle
              Row(
                children: [
                  Switch(
                    value: _isPrivate,
                    onChanged: (value) => setState(() => _isPrivate = value),
                    activeColor: _selectedColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Private Goal (only you can see)',
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
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
                      onPressed: _createGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Create Goal',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createGoal() {
    if (_formKey.currentState!.validate()) {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      
      expenseProvider.addSavingsGoal(
        title: _titleController.text,
        targetAmount: double.parse(_targetAmountController.text),
        targetDate: _selectedDate,
        category: _selectedCategory,
        color: _selectedColor,
      );
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal "${_titleController.text}" created successfully!'),
          backgroundColor: _selectedColor,
        ),
      );
    }
  }
}
