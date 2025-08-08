import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';

class ProfileHeader extends StatefulWidget {
  final bool isDark;
  final AuthProvider authProvider;

  const ProfileHeader({
    super.key,
    required this.isDark,
    required this.authProvider,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _usernameController.text = '@johndoe';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
        children: [
          // Profile Picture and Basic Info
          Row(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () => _showProfilePictureDialog(context),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            _profileImage!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _nameController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'Verified',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _usernameController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: widget.isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _emailController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: widget.isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Member since ${_getMemberSince()}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Edit Button
              IconButton(
                onPressed: () => _showEditProfileDialog(context),
                icon: Icon(
                  Icons.edit,
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Account Type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: const Color(0xFFFF6B35),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Free Account',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _showUpgradeDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Upgrade',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  String _getMemberSince() {
    final now = DateTime.now();
    final memberSince = DateTime(now.year - 1, now.month, now.day);
    return DateFormat('MMM yyyy').format(memberSince);
  }

  Future<void> _showProfilePictureDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Change Profile Picture',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFF6B35)),
              title: Text(
                'Take Photo',
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFF6B35)),
              title: Text(
                'Choose from Gallery',
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Color(0xFFFF6B35)),
              title: Text(
                'Choose from Files',
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _pickFile();
              },
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        setState(() {
          _profileImage = file;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: GoogleFonts.poppins(
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
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
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Upgrade to Premium',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Features:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Advanced Analytics & Insights'),
            _buildFeatureItem('Unlimited Savings Goals'),
            _buildFeatureItem('Priority Customer Support'),
            _buildFeatureItem('Export to All Formats (PDF, CSV, Excel)'),
            _buildFeatureItem('Custom Categories & Tags'),
            _buildFeatureItem('Advanced Budget Planning'),
            _buildFeatureItem('Data Backup & Sync'),
            _buildFeatureItem('Ad-Free Experience'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '₹299/month',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                  Text(
                    'or ₹2,999/year (Save 17%)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
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
              'Cancel',
              style: GoogleFonts.poppins(
                color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processUpgrade(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Upgrade Now',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _processUpgrade(BuildContext context) {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
            ),
            const SizedBox(height: 16),
            Text(
              'Processing Payment...',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate payment delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: widget.isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Upgrade Successful!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            'Welcome to SpendWise Premium! You now have access to all premium features.',
            style: GoogleFonts.poppins(
              color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh UI to show premium status
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
