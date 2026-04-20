import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
        title: Text(
          'Đăng Ký Tài Khoản',
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const LogoWidget(size: 90),
            const SizedBox(height: 16),
            Text(
              'Tạo tài khoản mới',
              style: GoogleFonts.beVietnamPro(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Điền thông tin bên dưới để bắt đầu',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _buildLabel('Họ và tên'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Ví dụ: Nguyễn Văn A'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Số điện thoại'),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: '09xx xxx xxx'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Địa chỉ'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Ví dụ: KTX khu A - ĐHQGHCM'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Mật khẩu'),
            const SizedBox(height: 8),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Nhập mật khẩu'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Nhập lại mật khẩu'),
            const SizedBox(height: 8),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Nhập lại mật khẩu'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Đăng ký', style: GoogleFonts.beVietnamPro(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? ',
                    style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Đăng nhập',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
