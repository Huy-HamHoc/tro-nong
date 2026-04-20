import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';

class QrScreen extends StatelessWidget {
  final String projectId;
  final String projectName;

  const QrScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  // Dữ liệu mã hóa trong QR: chứa projectId để mở lại dự án
  String get _qrData => 'tronong://project/$projectId';

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
        title: Text('Mã QR Dự Án',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Icon + tiêu đề
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_scanner, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mã truy cập nhanh',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: AppColors.textSecondary)),
                        Text(projectName,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // QR Code thật
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 220,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.primaryGreen,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Quét để mở dự án này',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Hướng dẫn
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cách sử dụng',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _buildStep('1', 'In hoặc lưu mã QR này'),
                  _buildStep('2', 'Mở app Trợ Nông trên điện thoại'),
                  _buildStep('3', 'Quét mã → vào thẳng trang dự án'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Thông tin kỹ thuật
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID dự án: $projectId',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 12, color: AppColors.textLight),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text('Mã QR này chỉ mở được dự án trong tài khoản của bạn.',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(number,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Text(text,
              style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
