import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TrialPeriodBanner extends StatefulWidget {
  const TrialPeriodBanner({super.key});

  @override
  State<TrialPeriodBanner> createState() => _TrialPeriodBannerState();
}

class _TrialPeriodBannerState extends State<TrialPeriodBanner>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange
                    .withValues(alpha: 0.8 + _blinkController.value * 0.2),
                Colors.orange
                    .withValues(alpha: 0.6 + _blinkController.value * 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '30 Days Free Trial Available',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3);
  }
}
