import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

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
        title: Text('Tạo Mã QR',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('TRUY XUẤT NGUỒN GỐC',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                    letterSpacing: 1)),
            const SizedBox(height: 4),
            Text('Thông tin lô hàng',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildLabel('Mã lô hàng'),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Ví dụ: ST25_1')),
            const SizedBox(height: 14),
            _buildLabel('Tên lô hàng'),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Ví dụ: Gạo ST25')),
            const SizedBox(height: 14),
            _buildLabel('Ngày thu hoạch'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: '20 tháng 04, 2026',
                suffixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 20),
              ),
            ),
            const SizedBox(height: 14),
            _buildLabel('Sản lượng'),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ví dụ: 500',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('KG',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildLabel('Mô tả'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Ví dụ: Lô này ngon'),
            ),
            const SizedBox(height: 20),
            // Generate QR button
            ElevatedButton(
              onPressed: () {},
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
            // QR code display
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.qr_code_2, size: 120, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 12),
                    Text('Mã QR đã sẵn sàng',
                        style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.download, color: AppColors.primaryGreen, size: 18),
                        const SizedBox(width: 4),
                        Text('Lưu mã về máy',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lô hàng này sẽ được lưu vào lịch sử quét mã của bạn để dễ dàng quản lý sau này.',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                    ),
                  ),
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
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
