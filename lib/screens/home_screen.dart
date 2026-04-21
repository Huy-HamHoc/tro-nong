import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import '../services/weather_service.dart';
import '../widgets/voice_assistant_widget.dart';

class HomeScreen extends StatefulWidget {
  final Widget? drawer;
  final void Function(int)? onSwitchTab;
  const HomeScreen({super.key, this.drawer, this.onSwitchTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _weather;
  bool _weatherLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _weatherLoading = false);
      return;
    }

    // Lấy địa chỉ từ Firestore
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final address = (doc.data()?['address'] as String?) ?? '';

    // Gọi weather API
    final weather = await WeatherService().getWeatherByAddress(
      address.isNotEmpty ? address : 'An Giang',
    );

    if (mounted) {
      setState(() {
        _weather = weather;
        _weatherLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser?.displayName ?? 'bạn';

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: widget.drawer,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Chào $displayName!',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: AppColors.primaryGreen, size: 18),
                const SizedBox(width: 4),
                Text(
                  _weather != null ? '${_weather!['temp']}°C' : '...',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ─── Weather card ──────────────────────────────────────
            _buildWeatherCard(),
            const SizedBox(height: 24),

            // ─── Voice assistant ────────────────────────────────────
            const Center(child: VoiceAssistantWidget()),
            const SizedBox(height: 24),

            // ─── Tasks ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Công việc hôm nay',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/tasks'),
                  child: Text('Xem tất cả',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTaskItem('Tưới rau muống', false),
            const SizedBox(height: 8),
            _buildTaskItem('Kiểm tra sâu bệnh', false),
            const SizedBox(height: 24),

            // ─── Feature grid ───────────────────────────────────────
            Text('Chọn chức năng thực hiện',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildFeatureCard(
                        Icons.auto_stories_outlined, 'Quản lý\ndự án', () => widget.onSwitchTab?.call(1))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildFeatureCard(
                        Icons.language, 'Diễn đàn\nnông nghiệp', () => widget.onSwitchTab?.call(3))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildFeatureCard(
                        Icons.storefront_outlined, 'Cửa hàng', () => widget.onSwitchTab?.call(2))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildFeatureCard(
                        Icons.person_outline, 'Hồ sơ\ncủa tôi', () => widget.onSwitchTab?.call(4))),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Products ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nông sản đang bán',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                GestureDetector(
                  onTap: () => widget.onSwitchTab?.call(2),
                  child: const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getMarketListings(
                    FirebaseAuth.instance.currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Text('Chưa có sản phẩm nào',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textSecondary)),
                    );
                  }
                  final colors = [
                    Colors.green.shade700,
                    Colors.orange.shade700,
                    Colors.teal.shade600,
                    Colors.red.shade600,
                  ];
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return _buildProductCard(
                        data['productName'] ?? 'Sản phẩm',
                        '${_formatPrice(data['price'])}đ/kg',
                        'Kho: ${data['inStock'] ?? 0} kg',
                        colors[index % colors.length],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    if (_weatherLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 12),
            Text('Đang tải thời tiết...',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    if (_weather == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Không thể tải thời tiết',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, color: AppColors.textSecondary)),
                  Text('Kiểm tra địa chỉ trong hồ sơ cá nhân',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() => _weatherLoading = true);
                _loadWeather();
              },
              child: const Icon(Icons.refresh, color: AppColors.primaryGreen),
            ),
          ],
        ),
      );
    }

    // Chọn icon + màu theo thời tiết
    final iconCode = _weather!['icon'] as String;
    final weatherConfig = _getWeatherConfig(iconCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: weatherConfig['bgColor'] as Color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.textSecondary, size: 14),
                    const SizedBox(width: 4),
                    Text(_weather!['city'] as String,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_weather!['description']}, ${_weather!['temp']}°C\n- ${_weather!['advice']}',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text('Độ ẩm: ${_weather!['humidity']}%',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _weatherLoading = true);
              _loadWeather();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (weatherConfig['iconBg'] as Color),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                weatherConfig['icon'] as IconData,
                color: weatherConfig['iconColor'] as Color,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getWeatherConfig(String iconCode) {
    switch (iconCode) {
      case 'Clear':
        return {
          'icon': Icons.wb_sunny,
          'iconColor': Colors.orange,
          'iconBg': Colors.orange.withValues(alpha: 0.2),
          'bgColor': AppColors.inputBg,
        };
      case 'Clouds':
        return {
          'icon': Icons.cloud,
          'iconColor': Colors.blueGrey,
          'iconBg': Colors.blueGrey.withValues(alpha: 0.15),
          'bgColor': AppColors.inputBg,
        };
      case 'Rain':
      case 'Drizzle':
        return {
          'icon': Icons.water_drop,
          'iconColor': Colors.blue,
          'iconBg': Colors.blue.withValues(alpha: 0.15),
          'bgColor': Colors.blue.withValues(alpha: 0.05),
        };
      case 'Thunderstorm':
        return {
          'icon': Icons.bolt,
          'iconColor': Colors.amber,
          'iconBg': Colors.amber.withValues(alpha: 0.2),
          'bgColor': Colors.grey.withValues(alpha: 0.1),
        };
      default:
        return {
          'icon': Icons.wb_cloudy,
          'iconColor': AppColors.primaryGreen,
          'iconBg': AppColors.primaryGreen.withValues(alpha: 0.15),
          'bgColor': AppColors.inputBg,
        };
    }
  }

  Widget _buildTaskItem(String title, bool done) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 2),
              color: done ? AppColors.primaryGreen : Colors.transparent,
            ),
            child: done ? const Icon(Icons.check, color: AppColors.white, size: 16) : null,
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String stock, Color imageColor) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: imageColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Icon(Icons.eco, size: 44, color: imageColor),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis),
                Text(price,
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
                Text(stock,
                    style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    final p = (price is num) ? price.toInt() : 0;
    if (p >= 1000) {
      return '${(p / 1000).toStringAsFixed(p % 1000 == 0 ? 0 : 1)}.000';
    }
    return p.toString();
  }
}
