import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Top logo + app name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Trợ Nông',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Large logo
              const LogoWidget(size: 120),
              const SizedBox(height: 20),
              // Greeting
              Text(
                'Chào bạn!',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mời bạn đăng nhập để tiếp tục',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              // Phone field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại của bạn',
                  prefixIcon: Icon(Icons.phone_android, color: AppColors.primaryGreen.withValues(alpha: 0.5), size: 22),
                ),
              ),
              const SizedBox(height: 20),
              // Password field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mật khẩu',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Nhập mật khẩu',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryGreen.withValues(alpha: 0.5), size: 22),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textLight,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Quên mật khẩu?',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Login button
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Đăng nhập', style: GoogleFonts.beVietnamPro(fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chưa có tài khoản? ',
                    style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      'Đăng ký ngay',
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
      ),
    );
  }
}
