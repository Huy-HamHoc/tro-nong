import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      })..forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Logo
            const LogoWidget(size: 200),
            const SizedBox(height: 24),
            // App name
            Text(
              'Trợ Nông',
              style: GoogleFonts.beVietnamPro(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _controller.value,
                  minHeight: 10,
                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
