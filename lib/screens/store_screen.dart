import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class StoreScreen extends StatelessWidget {
  final Widget? drawer;
  const StoreScreen({super.key, this.drawer});

  String get _farmerId => FirebaseAuth.instance.currentUser?.uid ?? '';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getMarketListings(_farmerId),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];

          // Tính tổng doanh thu và lợi nhuận (price * sold)
          int totalRevenue = 0;
          for (final doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final price = (data['price'] as num?)?.toInt() ?? 0;
            final sold = (data['sold'] as num?)?.toInt() ?? 0;
            totalRevenue += price * sold;
          }

          return SingleChildScrollView(
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
                      Text('Tóm tắt',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Text('Doanh thu',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textSecondary)),
                      Text(
                        snapshot.connectionState == ConnectionState.waiting
                            ? '...'
                            : '${_formatCurrency(totalRevenue)}đ',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreen),
                      ),
                      Divider(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                      Text('Số sản phẩm',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textSecondary)),
                      Text('${docs.length} loại',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen)),
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
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Product list from Firestore
                Text('Sản phẩm đang bán',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 14),

                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: AppColors.primaryGreen),
                    ),
                  )
                else if (docs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.storefront_outlined, size: 48, color: AppColors.textLight),
                          const SizedBox(height: 8),
                          Text('Chưa có sản phẩm nào',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 15, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  )
                else
                  ...docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final String name = data['productName'] ?? 'Sản phẩm';
                    final int sold = (data['sold'] as num?)?.toInt() ?? 0;
                    final int inStock = (data['inStock'] as num?)?.toInt() ?? 0;
                    final int price = (data['price'] as num?)?.toInt() ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildProductItem(
                        name: name,
                        soldValue: '$sold kg',
                        remaining: 'Còn: $inStock kg',
                        price: '${_formatCurrency(price)}đ/kg',
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}.000';
    }
    return value.toString();
  }

  Widget _buildProductItem({
    required String name,
    required String soldValue,
    required String remaining,
    required String price,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(price,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Đã bán: ',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, color: AppColors.textSecondary)),
                    Text(soldValue,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen)),
                    const SizedBox(width: 12),
                    Text(remaining,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, color: AppColors.textSecondary)),
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
