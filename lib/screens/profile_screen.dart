import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final Widget? drawer;
  const ProfileScreen({super.key, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('Hồ sơ của tôi',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar with badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                  child: const Icon(Icons.person, size: 52, color: AppColors.primaryGreen),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 3),
                  ),
                  child: const Icon(Icons.check, color: AppColors.white, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Nguyễn Văn Tèo',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Nông dân tiêu biểu tại An Giang',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            // Stats cards
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Số dự án đã tạo',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('15',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('dự án',
                            style: GoogleFonts.beVietnamPro(fontSize: 15, color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.yellowAccent.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sản phẩm đang bán',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('10',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('loại',
                            style: GoogleFonts.beVietnamPro(fontSize: 15, color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Settings section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Cài đặt & Hỗ trợ',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 14),
            _buildMenuItem(
              icon: Icons.person,
              iconBgColor: AppColors.primaryGreen.withValues(alpha: 0.15),
              iconColor: AppColors.primaryGreen,
              title: 'Thông tin cá nhân',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.mic,
              iconBgColor: AppColors.textSecondary.withValues(alpha: 0.15),
              iconColor: AppColors.textSecondary,
              title: 'Cài đặt giọng nói',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.help_outline,
              iconBgColor: AppColors.primaryGreen.withValues(alpha: 0.15),
              iconColor: AppColors.primaryGreen,
              title: 'Hỗ trợ',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            // Logout
            _buildMenuItem(
              icon: Icons.logout,
              iconBgColor: AppColors.redAccent.withValues(alpha: 0.1),
              iconColor: AppColors.redAccent,
              title: 'Đăng xuất',
              titleColor: AppColors.redAccent,
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? AppColors.textPrimary)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
