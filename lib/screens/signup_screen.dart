import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_widget.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // Validation
    if (name.isEmpty || phone.isEmpty || address.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Mật khẩu nhập lại không khớp');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService().register(
        fullName: name,
        phoneNumber: phone,
        address: address,
        password: password,
      );
      // Đăng xuất ngay để không tự vào app
      await AuthService().logout();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Đăng ký thành công! Hãy đăng nhập để tiếp tục.',
                style: GoogleFonts.beVietnamPro(fontSize: 14)),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context); // Quay về LoginScreen
        return;
      }
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'Số điện thoại này đã được đăng ký rồi';
          break;
        case 'weak-password':
          msg = 'Mật khẩu quá yếu, vui lòng dùng mật khẩu mạnh hơn';
          break;
        case 'invalid-email':
          msg = 'Số điện thoại không hợp lệ';
          break;
        default:
          msg = 'Đăng ký thất bại: ${e.message}';
      }
      setState(() => _errorMessage = msg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Error box
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.redAccent)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            _buildLabel('Họ và tên'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Ví dụ: Nguyễn Văn A'),
            ),
            const SizedBox(height: 18),

            _buildLabel('Số điện thoại'),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: '09xx xxx xxx'),
            ),
            const SizedBox(height: 18),

            _buildLabel('Địa chỉ'),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Ví dụ: An Giang'),
            ),
            const SizedBox(height: 18),

            _buildLabel('Mật khẩu'),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Ít nhất 6 ký tự'),
            ),
            const SizedBox(height: 18),

            _buildLabel('Nhập lại mật khẩu'),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Nhập lại mật khẩu'),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đăng ký',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 17, fontWeight: FontWeight.w700)),
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
                    style:
                        GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
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
