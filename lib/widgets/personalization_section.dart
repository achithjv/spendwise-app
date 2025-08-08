import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PersonalizationSection extends StatelessWidget {
  final bool isDark;

  const PersonalizationSection({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
            'Personalization',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Currency Setting
          _buildSettingRow(
            'Currency',
            '₹ (INR)',
            Icons.attach_money,
            () => _showCurrencyDialog(context),
          ),

          const SizedBox(height: 15),

          // Theme Setting
          _buildSettingRow(
            'Theme',
            'Auto',
            Icons.palette,
            () => _showThemeDialog(context),
          ),

          const SizedBox(height: 15),

          // Dashboard Layout
          _buildSettingRow(
            'Dashboard Layout',
            'Grid',
            Icons.dashboard,
            () => _showLayoutDialog(context),
          ),

          const SizedBox(height: 15),

          // Quote of the Day
          _buildQuoteSection(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildSettingRow(
      String title, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF6B35), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    value,
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

  Widget _buildQuoteSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: const Color(0xFFFF6B35),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quote of the Day',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showQuoteDialog(),
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFFFF6B35),
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"The best investment you can make is in yourself."',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Currency',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption('₹ (INR)', 'Indian Rupee'),
            _buildCurrencyOption('\$ (USD)', 'US Dollar'),
            _buildCurrencyOption('€ (EUR)', 'Euro'),
            _buildCurrencyOption('£ (GBP)', 'British Pound'),
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

  Widget _buildCurrencyOption(String symbol, String name) {
    return ListTile(
      leading: Text(
        symbol,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(),
      ),
      onTap: () {
        // TODO: Implement currency change
        // Note: context is not available in this method
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Theme',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Light', Icons.wb_sunny),
            _buildThemeOption('Dark', Icons.nightlight),
            _buildThemeOption('Auto', Icons.brightness_auto),
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

  Widget _buildThemeOption(String theme, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        theme,
        style: GoogleFonts.poppins(),
      ),
      onTap: () {
        // TODO: Implement theme change
        // Note: context is not available in this method
      },
    );
  }

  void _showLayoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Dashboard Layout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLayoutOption('Grid', Icons.grid_view),
            _buildLayoutOption('List', Icons.list),
            _buildLayoutOption('Compact', Icons.view_compact),
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

  Widget _buildLayoutOption(String layout, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        layout,
        style: GoogleFonts.poppins(),
      ),
      onTap: () {
        // TODO: Implement layout change
        // Note: context is not available in this method
      },
    );
  }

  void _showQuoteDialog() {
    // TODO: Implement quote customization
    // Note: context is not available in this method, would need to be passed as parameter
    // For now, this is a placeholder
  }
}
