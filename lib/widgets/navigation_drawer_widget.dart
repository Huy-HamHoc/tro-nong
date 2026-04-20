import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelectScreen;

  const NavigationDrawerWidget({
    super.key,
    required this.currentIndex,
    required this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Avatar + Close button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with green border
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3B7A57),
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryGreen.withValues(alpha: 0.15),
                            child: const Icon(Icons.person, size: 36, color: AppColors.primaryGreen),
                          );
                        },
                      ),
                    ),
                  ),
                  // Close/back button
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: AppColors.primaryGreen, size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Greeting ──
              Text(
                'Chào Bạn!',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Nông dân tiêu biểu tại An Giang',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 28),

              // ── Menu Items ──
              _buildNavItem(
                icon: Icons.home,
                label: 'Trang chủ',
                isActive: currentIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  onSelectScreen(0);
                },
              ),
              const SizedBox(height: 6),
              _buildNavItem(
                icon: Icons.auto_stories_outlined,
                label: 'Dự án của tôi',
                isActive: currentIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  onSelectScreen(1);
                },
              ),
              const SizedBox(height: 6),
              _buildNavItem(
                icon: Icons.language,
                label: 'Diễn đàn',
                isActive: currentIndex == 3,
                onTap: () {
                  Navigator.pop(context);
                  onSelectScreen(3);
                },
              ),
              const SizedBox(height: 6),
              _buildNavItem(
                icon: Icons.storefront_outlined,
                label: 'Cửa hàng',
                isActive: currentIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  onSelectScreen(2);
                },
              ),

              const SizedBox(height: 12),
              // ── Divider ──
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Divider(color: AppColors.divider, thickness: 1),
              ),
              const SizedBox(height: 12),

              // ── Settings ──
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: 'Cài đặt',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const SizedBox(height: 6),
              // ── Logout ──
              _buildNavItem(
                icon: Icons.logout,
                label: 'Đăng xuất',
                isActive: false,
                isLogout: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.white
                  : isLogout
                      ? AppColors.redAccent
                      : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? AppColors.white
                    : isLogout
                        ? AppColors.redAccent
                        : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
