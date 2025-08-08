import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/goals_and_achievements_screen.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool isDark;

  const AchievementBadge({
    super.key,
    required this.achievement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: achievement.isUnlocked 
                  ? achievement.color.withValues(alpha: 0.1)
                  : (isDark ? Colors.grey[700] : Colors.grey[200]),
              shape: BoxShape.circle,
              border: Border.all(
                color: achievement.isUnlocked 
                    ? achievement.color.withValues(alpha: 0.3)
                    : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                width: 2,
              ),
            ),
            child: Icon(
              achievement.icon,
              size: 32,
              color: achievement.isUnlocked 
                  ? achievement.color
                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Badge Title
          Text(
            achievement.title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: achievement.isUnlocked 
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? Colors.grey[400] : Colors.grey[500]),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // Badge Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              achievement.description,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: achievement.isUnlocked 
                    ? (isDark ? Colors.grey[300] : Colors.grey[600])
                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Progress Indicator (for locked badges)
          if (!achievement.isUnlocked) ...[
            Container(
              width: double.infinity,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (achievement.progress / achievement.target).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: achievement.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${achievement.progress.round()}/${achievement.target.round()}',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ] else ...[
            // Unlocked indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: achievement.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'UNLOCKED',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: achievement.color,
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8));
  }
}
