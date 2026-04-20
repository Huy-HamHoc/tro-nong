import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

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
        title: Text('Lúa',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Voice note button
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: AppColors.white, size: 32),
                  ),
                  const SizedBox(height: 8),
                  Text('Bạn cần ghi chú gì?',
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Recording result
            Text('KẾT QUẢ GHI ÂM',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Hôm nay đã bón phân đợt 1 cho ruộng lúa ở khu Đồng Vàng. Lúa đang lên xanh tốt, chưa thấy dấu hiệu sâu bệnh...',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary, height: 1.6),
              ),
            ),
            const SizedBox(height: 16),
            // Progress bars
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildProgressRow('Tưới nước', '1/2 lần', 0.5),
                  const SizedBox(height: 12),
                  _buildProgressRow('Nuôi trồng', '13/30 ngày', 13 / 30),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Add images section
            Text('THÊM HÌNH ẢNH',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildImageButton(Icons.camera_alt_outlined, 'Chụp ảnh'),
                const SizedBox(width: 12),
                _buildImageButton(Icons.photo_library_outlined, 'Chọn ảnh'),
              ],
            ),
            const SizedBox(height: 16),
            // Photo with location
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.landscape, size: 60, color: Colors.green.withValues(alpha: 0.5))),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('Khu Đồng Vàng',
                              style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Supplies & costs
            Row(
              children: [
                const Icon(Icons.description_outlined, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Text('Vật tư & Chi phí',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 10),
            // Table
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: [
                      Expanded(
                          child: Text('Tên vật tư',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                      Expanded(
                          child: Text('Số lượng',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                      Expanded(
                          child: Text('Chi phí',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Phân bón NPK',
                              style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary))),
                      Expanded(
                          child: Text('2 bao',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary))),
                      Expanded(
                          child: Text('400.000đ',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text('Thêm vật tư mới',
                            style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Total
            Align(
              alignment: Alignment.centerRight,
              child: Text('Tổng: 400.000đ',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
            ),
            const SizedBox(height: 24),
            // Action buttons
            ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text('Lưu Nhật Ký',
                      style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/qr'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code, size: 20),
                  const SizedBox(width: 8),
                  Text('Tạo Mã QR Cho Lô Hàng Này',
                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String label, String value, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
            Text(value,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 28),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
