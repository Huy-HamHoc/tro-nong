import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Thêm dự án mới',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Thông tin dự án',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
            const SizedBox(height: 4),
            Text('Vui lòng điền chi tiết để bắt đầu mùa vụ mới.',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            _buildLabel('Tên dự án'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Ví dụ: Trồng Lúa Vụ Đông Xuân'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Tên giống cây'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Ví dụ: Lúa ST25'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Ngày bắt đầu'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                prefixIcon: Icon(Icons.calendar_today_outlined,
                    color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 18),
            _buildLabel('Ngày kết thúc'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                prefixIcon: Icon(Icons.calendar_today_outlined,
                    color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 18),
            _buildLabel('Loại đất canh tác'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Chọn loại đất...',
                prefixIcon: Icon(Icons.terrain_outlined,
                    color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildLabel('Diện tích canh tác'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Loại đất...',
                      prefixIcon: Icon(Icons.crop_square_outlined,
                          color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('m²',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildLabel('Số lần tưới / ngày'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Số lần',
                      prefixIcon: Icon(Icons.water_drop_outlined,
                          color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('lần',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text('Lưu dự án',
                      style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.beVietnamPro(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
