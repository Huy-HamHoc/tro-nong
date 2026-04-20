import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

/// Màn hình ghi nhật ký canh tác hàng ngày
/// Collection: crop_logs/{logId}
class DailyLogScreen extends StatefulWidget {
  final String projectId;
  final String projectName;
  final int expectedWaterPerDay; // Lượng tưới kỳ vọng từ dự án

  const DailyLogScreen({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.expectedWaterPerDay,
  });

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  final _notesController = TextEditingController();

  // Tưới nước
  int _waterCount = 0;

  // Tình trạng cây
  String _plantStatus = 'Bình thường';
  final List<String> _plantStatuses = [
    'Bình thường',
    'Phát triển tốt',
    'Cần chú ý',
    'Có sâu bệnh',
    'Đang ra hoa',
    'Sắp thu hoạch',
  ];

  // Phân bón / thuốc
  bool _fertilized = false;
  bool _pesticide = false;
  String _fertilizerNote = '';
  String _pesticideNote = '';

  // Thời tiết hôm nay
  String _weather = 'Nắng';
  final List<String> _weatherOptions = [
    'Nắng', 'Có mây', 'Mưa nhỏ', 'Mưa lớn', 'Dông', 'Sương mù',
  ];

  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveLog() async {
    setState(() => _isSaving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    try {
      await FirebaseFirestore.instance.collection('crop_logs').add({
        // ─── Định danh ──────────────────────────
        'projectId': widget.projectId,
        'farmerId': uid,
        'date': todayStr,           // "2024-04-20" — dùng để nhóm theo ngày
        'timestamp': FieldValue.serverTimestamp(),

        // ─── Tưới nước ──────────────────────────
        'waterCount': _waterCount,                   // Số lần tưới trong ngày
        'expectedWater': widget.expectedWaterPerDay, // Kỳ vọng (từ dự án)

        // ─── Tình trạng cây ─────────────────────
        'plantStatus': _plantStatus,   // Trạng thái tổng quát

        // ─── Thời tiết ──────────────────────────
        'weather': _weather,

        // ─── Phân bón ───────────────────────────
        'fertilized': _fertilized,         // Có bón phân không
        'fertilizerNote': _fertilizerNote, // Loại phân, liều lượng

        // ─── Thuốc BVTV ─────────────────────────
        'pesticide': _pesticide,           // Có phun thuốc không
        'pesticideNote': _pesticideNote,   // Loại thuốc, liều lượng

        // ─── Ghi chú ────────────────────────────
        'notes': _notesController.text.trim(),

        // ─── Hình ảnh (URL) ─────────────────────
        // 'imageUrls': [],  // Sẽ bổ sung sau khi có Firebase Storage
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã lưu nhật ký ngày $todayStr!',
                style: GoogleFonts.beVietnamPro(fontSize: 14)),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: AppColors.redAccent),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nhật ký hôm nay',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
            Text(dateStr,
                style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ─── Header dự án ───────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.primaryGreen, size: 18),
                  const SizedBox(width: 8),
                  Text(widget.projectName,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── 1. Thời tiết ────────────────────────────────────
            _buildSectionTitle('🌤 Thời tiết hôm nay'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _weatherOptions.map((w) {
                final selected = _weather == w;
                return GestureDetector(
                  onTap: () => setState(() => _weather = w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryGreen : AppColors.inputBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primaryGreen
                            : AppColors.divider,
                      ),
                    ),
                    child: Text(w,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ─── 2. Tưới nước ────────────────────────────────────
            _buildSectionTitle('💧 Số lần tưới hôm nay'),
            const SizedBox(height: 4),
            Text('Kỳ vọng: ${widget.expectedWaterPerDay} lần/ngày',
                style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _counterBtn(Icons.remove, () {
                    if (_waterCount > 0) setState(() => _waterCount--);
                  }),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text('$_waterCount',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
                      Text('lần',
                          style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  _counterBtn(Icons.add, () => setState(() => _waterCount++)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── 3. Tình trạng cây ───────────────────────────────
            _buildSectionTitle('🌱 Tình trạng cây'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _plantStatuses.map((s) {
                final selected = _plantStatus == s;
                return GestureDetector(
                  onTap: () => setState(() => _plantStatus = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1565C0) : AppColors.inputBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected ? const Color(0xFF1565C0) : AppColors.divider),
                    ),
                    child: Text(s,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ─── 4. Phân bón ─────────────────────────────────────
            _buildToggleSection(
              icon: '🌿',
              title: 'Có bón phân hôm nay không?',
              value: _fertilized,
              onChanged: (v) => setState(() => _fertilized = v),
              noteHint: 'Loại phân, liều lượng (VD: Urê 50kg/ha)',
              onNoteChanged: (v) => _fertilizerNote = v,
            ),
            const SizedBox(height: 14),

            // ─── 5. Thuốc BVTV ───────────────────────────────────
            _buildToggleSection(
              icon: '🛡',
              title: 'Có phun thuốc BVTV không?',
              value: _pesticide,
              onChanged: (v) => setState(() => _pesticide = v),
              noteHint: 'Loại thuốc, liều lượng (VD: Beam 75WP, 1 gói/500L)',
              onNoteChanged: (v) => _pesticideNote = v,
            ),
            const SizedBox(height: 20),

            // ─── 6. Ghi chú thêm ─────────────────────────────────
            _buildSectionTitle('📝 Ghi chú thêm'),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Ghi lại quan sát, vấn đề phát sinh, kế hoạch ngày mai...',
              ),
            ),
            const SizedBox(height: 28),

            // ─── Nút lưu ────────────────────────────────────────
            ElevatedButton(
              onPressed: _isSaving ? null : _saveLog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text('Lưu Nhật Ký Hôm Nay',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.beVietnamPro(
            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 22),
      ),
    );
  }

  Widget _buildToggleSection({
    required String icon,
    required String title,
    required bool value,
    required void Function(bool) onChanged,
    required String noteHint,
    required void Function(String) onNoteChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$icon  $title',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Switch(
                value: value,
                activeColor: AppColors.primaryGreen,
                onChanged: onChanged,
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(hintText: noteHint),
              onChanged: onNoteChanged,
            ),
          ],
        ],
      ),
    );
  }
}
