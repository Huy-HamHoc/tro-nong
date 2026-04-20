import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, 'Trang chủ'),
            _buildNavItem(1, Icons.auto_stories_outlined, Icons.auto_stories, 'Dự án'),
            _buildNavItem(2, Icons.storefront_outlined, Icons.storefront, 'Cửa hàng'),
            _buildNavItem(3, Icons.language_outlined, Icons.language, 'Diễn đàn'),
            _buildNavItem(4, Icons.person_outline, Icons.person, 'Hồ sơ'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.white : AppColors.navInactive,
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
