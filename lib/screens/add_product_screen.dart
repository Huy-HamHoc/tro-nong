import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

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
        centerTitle: true,
        title: Text('Thêm Sản Phẩm',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Chọn dự án',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chọn từ danh sách dự án...',
                      style: GoogleFonts.beVietnamPro(fontSize: 15, color: AppColors.textLight)),
                  Row(
                    children: [
                      Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text('Chọn dự án để tự động liên kết nguồn gốc.',
                style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.primaryGreen)),
            const SizedBox(height: 28),
            Text('Sản lượng dự kiến bán',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Ví dụ: 100'),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Text('kg', style: GoogleFonts.beVietnamPro(fontSize: 15, color: AppColors.textPrimary)),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Giá bán',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ví dụ: 15.000',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VND',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text('Số lượng có sẵn trong kho',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Số lượng thực tế'),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('như\ntrên',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Đăng bán ngay',
                  style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text('Sản phẩm sẽ được hiển thị ngay trên Cửa hàng.',
                  style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
