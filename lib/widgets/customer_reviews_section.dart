import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerReviewsSection extends StatelessWidget {
  const CustomerReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final reviews = [
      {
        'name': 'Sarah Johnson',
        'rating': 5,
        'comment':
            'This expense tracker has completely transformed how I manage my finances. The interface is intuitive and the features are exactly what I needed.',
        'avatar': '👩‍💼',
      },
      {
        'name': 'Michael Chen',
        'rating': 5,
        'comment':
            'Best expense tracking app I\'ve ever used. The dark mode feature is fantastic and the reports are very detailed.',
        'avatar': '👨‍💻',
      },
      {
        'name': 'Emily Rodriguez',
        'rating': 5,
        'comment':
            'Love the simplicity and powerful features. It helps me stay on top of my budget effortlessly.',
        'avatar': '👩‍🎨',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Text(
            'What Our Customers Say',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 40),
          ...reviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        review['avatar'] as String,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['name'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: List.generate(5, (i) {
                                final rating = review['rating'] as int;
                                return Icon(
                                  i < rating ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    review['comment'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (index * 200).ms, duration: 600.ms)
                .slideX(begin: 0.3);
          }),
        ],
      ),
    );
  }
}
