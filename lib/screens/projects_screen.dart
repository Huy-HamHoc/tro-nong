import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProjectsScreen extends StatelessWidget {
  final Widget? drawer;
  const ProjectsScreen({super.key, this.drawer});

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
        title: Text('Dự án',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
              child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Dự án đang thực hiện',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            // Project: Rau muống
            _buildProjectCard(
              context,
              icon: Icons.eco,
              iconBgColor: AppColors.primaryGreen,
              title: 'Rau muống',
              subtitle: 'Đã trồng 15 ngày',
              onTap: () => Navigator.pushNamed(context, '/project-detail'),
            ),
            const SizedBox(height: 12),
            // Project: Lúa
            _buildProjectCard(
              context,
              icon: Icons.grass,
              iconBgColor: AppColors.brownGold,
              title: 'Lúa',
              subtitle: 'Đã trồng 8 ngày',
              onTap: () => Navigator.pushNamed(context, '/project-detail'),
            ),
            const SizedBox(height: 12),
            // Add new project
            _buildProjectCard(
              context,
              icon: Icons.add_circle_outline,
              iconBgColor: AppColors.redAccent,
              title: 'Thêm dự án mới',
              subtitle: '',
              onTap: () => Navigator.pushNamed(context, '/add-project'),
            ),
            const SizedBox(height: 28),
            // Tasks section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Công việc hôm nay',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/tasks'),
                        child: Text('Xem tất cả',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildTaskItem('Tưới rau', false),
                  const SizedBox(height: 10),
                  _buildTaskItem('Bón phân', false),
                  const SizedBox(height: 10),
                  _buildTaskItem('Kiểm tra sâu', false),
                  const SizedBox(height: 10),
                  _buildTaskItem('Thêm', false),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context,
      {required IconData icon,
      required Color iconBgColor,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, bool done) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 2),
              color: done ? AppColors.primaryGreen : Colors.transparent,
            ),
            child: done ? const Icon(Icons.check, color: AppColors.white, size: 14) : null,
          ),
          const SizedBox(width: 12),
          Text(title,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
