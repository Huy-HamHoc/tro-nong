import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final Widget? drawer;
  const HomeScreen({super.key, this.drawer});

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
        title: Text(
          'Chào Tèo!',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: AppColors.primaryGreen, size: 18),
                const SizedBox(width: 4),
                Text('28°C',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
              ],
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
            // Weather card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hôm nay tại An Giang',
                            style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Nắng nhẹ, 28°C\n- Lý tưởng để ra đồng',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.wb_sunny, color: Colors.orange, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Voice assistant
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF5E0B0).withValues(alpha: 0.5),
                  border: Border.all(color: const Color(0xFFE8D5A0).withValues(alpha: 0.3), width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, size: 48, color: AppColors.primaryGreen.withValues(alpha: 0.7)),
                    const SizedBox(height: 8),
                    Text('Bạn cần giúp gì?',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Tasks section
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
            const SizedBox(height: 12),
            _buildTaskItem('Tưới rau muống', false),
            const SizedBox(height: 8),
            _buildTaskItem('Kiểm tra sâu bệnh', false),
            const SizedBox(height: 24),
            // Feature grid
            Text('Chọn chức năng thực hiện',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildFeatureCard(Icons.auto_stories_outlined, 'Quản lý\ndự án', () {})),
                const SizedBox(width: 12),
                Expanded(child: _buildFeatureCard(Icons.language, 'Diễn đàn\nnông nghiệp', () {})),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildFeatureCard(Icons.storefront_outlined, 'Cửa hàng', () {})),
                const SizedBox(width: 12),
                Expanded(child: _buildFeatureCard(Icons.person_outline, 'Hồ sơ\ncủa tôi', () {})),
              ],
            ),
            const SizedBox(height: 24),
            // Products section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nông sản đang bán',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildProductCard('Rau muống', '10.000đ/bó', Colors.green.shade700),
                  const SizedBox(width: 12),
                  _buildProductCard('Cà chua', '15.000đ/kg', Colors.red.shade600),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, bool done) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 2),
              color: done ? AppColors.primaryGreen : Colors.transparent,
            ),
            child: done ? const Icon(Icons.check, color: AppColors.white, size: 16) : null,
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price, Color imageColor) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: imageColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Icon(Icons.eco, size: 48, color: imageColor),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(price,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
