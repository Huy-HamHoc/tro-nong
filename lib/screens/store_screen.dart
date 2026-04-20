import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StoreScreen extends StatelessWidget {
  final Widget? drawer;
  const StoreScreen({super.key, this.drawer});

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
        centerTitle: true,
        title: Text('Cửa Hàng',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Revenue summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.yellowAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tóm tắt hôm nay',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Doanh thu',
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                  Text('2.500.000đ',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
                  const SizedBox(height: 10),
                  Divider(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 6),
                  Text('Lợi nhuận',
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                  Text('800.000đ',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Add product button
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/add-product'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, color: AppColors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Text('Thêm sản phẩm\nmới',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Product list
            Text('Sản phẩm đang bán',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _buildProductItem('Rau muống', 'Đã bán: ', '15 kg', 'Còn: 5 kg', Colors.green),
            const SizedBox(height: 12),
            _buildProductItem('Cà chua', 'Đã bán: ', '8 kg', 'Còn: 12 kg', Colors.red),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(
      String name, String soldLabel, String soldValue, String remaining, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.eco, color: color, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(soldLabel,
                        style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                    Text(soldValue,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                    const SizedBox(width: 16),
                    Text(remaining,
                        style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
