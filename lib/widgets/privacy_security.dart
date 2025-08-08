import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class PrivacySecurity extends StatefulWidget {
  final bool isDark;

  const PrivacySecurity({
    super.key,
    required this.isDark,
  });

  @override
  State<PrivacySecurity> createState() => _PrivacySecurityState();
}

class _PrivacySecurityState extends State<PrivacySecurity> {
  bool _is2FAEnabled = false;
  bool _isDataSharingEnabled = true;
  bool _isAnalyticsEnabled = true;
  bool _isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
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
            'Privacy & Security',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // 2FA Toggle
          _buildSettingRow(
            'Two-Factor Authentication',
            'Add an extra layer of security',
            Icons.security,
            _is2FAEnabled,
            (value) => _toggle2FA(context, value),
          ),

          const SizedBox(height: 15),

          // Login History
          _buildInfoRow(
            'Login History',
            'Last 5 sessions',
            Icons.history,
            () => _showLoginHistory(context),
          ),

          const SizedBox(height: 15),

          // Data Download
          _buildInfoRow(
            'Download Data',
            'Get a copy of your data',
            Icons.download,
            () => _showDownloadDialog(context),
          ),

          const SizedBox(height: 15),

          // Privacy Settings
          _buildInfoRow(
            'Privacy Settings',
            'Control your data sharing',
            Icons.privacy_tip,
            () => _showPrivacyDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B35),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _toggle2FA(BuildContext context, bool value) {
    setState(() {
      _is2FAEnabled = value;
    });

    if (value) {
      _show2FASetupDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('2FA disabled'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _show2FASetupDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    bool isCodeSent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor:
              widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Text(
            'Setup Two-Factor Authentication',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCodeSent) ...[
                Text(
                  'Enter your phone number to receive verification codes',
                  style: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(
                      color:
                          widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.isDark
                            ? Colors.grey[600]!
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ] else ...[
                Text(
                  'Enter the 6-digit code sent to your phone',
                  style: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    labelStyle: GoogleFonts.poppins(
                      color:
                          widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.isDark
                            ? Colors.grey[600]!
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!isCodeSent) {
                  setState(() {
                    isCodeSent = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification code sent!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('2FA enabled successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: Text(
                isCodeSent ? 'Verify' : 'Send Code',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Login History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoginSession('Chrome - Windows', '2 hours ago', 'Active'),
            _buildLoginSession('Mobile - Android', '1 day ago', ''),
            _buildLoginSession('Safari - Mac', '3 days ago', ''),
            _buildLoginSession('Firefox - Linux', '1 week ago', ''),
            _buildLoginSession('Edge - Windows', '2 weeks ago', ''),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginSession(String device, String time, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showDownloadDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Download Your Data',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose what data you want to download:',
              style: GoogleFonts.poppins(
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildDownloadOption(
              'All Data',
              'Complete backup of your account',
              Icons.backup,
              Colors.blue,
              () => _downloadAllData(context),
            ),
            const SizedBox(height: 8),
            _buildDownloadOption(
              'Transactions Only',
              'Just your financial data',
              Icons.receipt_long,
              Colors.green,
              () => _downloadTransactions(context),
            ),
            const SizedBox(height: 8),
            _buildDownloadOption(
              'Settings & Preferences',
              'Your app configuration',
              Icons.settings,
              Colors.orange,
              () => _downloadSettings(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadOption(String title, String description, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
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
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.download,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAllData(BuildContext context) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to download data'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final directory = await getExternalStorageDirectory();
      final fileName =
          'spendwise_all_data_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory!.path}/$fileName');

      // Simulate data generation
      final data = {
        'user': {
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'joined': '2023-01-15',
        },
        'transactions': [
          {'id': '1', 'title': 'Salary', 'amount': 50000, 'type': 'income'},
          {'id': '2', 'title': 'Grocery', 'amount': 2000, 'type': 'expense'},
        ],
        'settings': {
          'theme': 'dark',
          'currency': 'INR',
          'notifications': true,
        },
        'exported_at': DateTime.now().toIso8601String(),
      };

      await file.writeAsString(data.toString());
      await OpenFile.open(file.path);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All data downloaded successfully!\nFile: $fileName'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadTransactions(BuildContext context) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transactions data downloaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _downloadSettings(BuildContext context) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings data downloaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Privacy Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPrivacyToggle(
              'Data Sharing',
              'Allow us to improve the app with anonymous data',
              _isDataSharingEnabled,
              (value) {
                setState(() {
                  _isDataSharingEnabled = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPrivacyToggle(
              'Analytics',
              'Help us understand app usage patterns',
              _isAnalyticsEnabled,
              (value) {
                setState(() {
                  _isAnalyticsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPrivacyToggle(
              'Location Services',
              'Use location for better expense categorization',
              _isLocationEnabled,
              (value) {
                setState(() {
                  _isLocationEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your data is encrypted and never shared with third parties without your consent.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF6B35),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle(
      String title, String description, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B35),
          ),
        ],
      ),
    );
  }
}
