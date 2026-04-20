import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import 'daily_log_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nhận arguments từ navigation
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String projectId = args?['projectId'] ?? '';
    final Map<String, dynamic> projectData = args?['data'] ?? {};

    final String projectName = projectData['projectName'] ?? 'Dự án';
    final String cropType = projectData['cropType'] ?? '';
    final String soilType = projectData['soilType'] ?? '';
    final num area = projectData['area'] ?? 0;
    final num waterPerDay = projectData['waterPerDay'] ?? 0;

    // Tính ngày đã trồng
    int daysSince = 0;
    int totalDays = 0;
    String startDateStr = '';
    String endDateStr = '';
    try {
      if (projectData['startDate'] != null) {
        final startDate = (projectData['startDate'] as Timestamp).toDate();
        daysSince = DateTime.now().difference(startDate).inDays;
        startDateStr = DateFormat('dd/MM/yyyy').format(startDate);
      }
      if (projectData['endDate'] != null) {
        final startDate = (projectData['startDate'] as Timestamp).toDate();
        final endDate = (projectData['endDate'] as Timestamp).toDate();
        totalDays = endDate.difference(startDate).inDays;
        endDateStr = DateFormat('dd/MM/yyyy').format(endDate);
      }
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(projectName,
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: AppColors.primaryGreen),
            tooltip: 'Mã QR dự án',
            onPressed: () => Navigator.pushNamed(
              context,
              '/qr',
              arguments: {
                'projectId': projectId,
                'projectName': projectName,
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.redAccent),
            onPressed: () => _confirmDelete(context, projectId, projectName),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ─── THÔNG TIN DỰ ÁN ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: AppColors.primaryGreen, size: 22),
                      const SizedBox(width: 8),
                      Text('Thông tin dự án',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildInfoRow('Giống cây', cropType),
                  _buildInfoRow('Loại đất', soilType),
                  _buildInfoRow('Diện tích', '${area.toStringAsFixed(0)} m²'),
                  _buildInfoRow('Tưới/ngày', '${waterPerDay.toStringAsFixed(0)} lần'),
                  _buildInfoRow('Bắt đầu', startDateStr),
                  if (endDateStr.isNotEmpty) _buildInfoRow('Kết thúc (dự kiến)', endDateStr),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── TIẾN ĐỘ ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (waterPerDay > 0)
                    _buildProgressRow('Tưới nước', '0/${waterPerDay.toStringAsFixed(0)} lần', 0),
                  if (waterPerDay > 0) const SizedBox(height: 12),
                  _buildProgressRow(
                    'Nuôi trồng',
                    totalDays > 0
                        ? '$daysSince/$totalDays ngày'
                        : '$daysSince ngày',
                    totalDays > 0 ? (daysSince / totalDays).clamp(0.0, 1.0) : 0.5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── NHẬT KÝ (crop_logs) ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nhật ký canh tác',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DailyLogScreen(
                        projectId: projectId,
                        projectName: projectName,
                        expectedWaterPerDay: waterPerDay.toInt(),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: AppColors.white, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stream nhật ký từ Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().getCropLogs(projectId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: AppColors.primaryGreen),
                    ),
                  );
                }
                final rawDocs = snapshot.data?.docs ?? [];
                // Sort trong code để tránh cần composite index Firestore
                final docs = [...rawDocs]..sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aDate = aData['date'] as String? ?? '';
                  final bDate = bData['date'] as String? ?? '';
                  return bDate.compareTo(aDate); // mới nhất trước
                });
                if (docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.note_alt_outlined, size: 40, color: AppColors.textLight),
                          const SizedBox(height: 8),
                          Text('Chưa có nhật ký nào',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 14, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('Bấm nút ➕ để ghi nhật ký hôm nay',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildLogCard(data);
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> data) {
    // Ư u tiên hiển thị date ("2024-04-20") hoặc timestamp
    String dateStr = data['date'] ?? '';
    if (dateStr.isEmpty && data['timestamp'] != null) {
      try {
        final ts = (data['timestamp'] as Timestamp).toDate();
        dateStr = DateFormat('dd/MM/yyyy').format(ts);
      } catch (_) {}
    } else if (dateStr.isNotEmpty) {
      // Đổi "2024-04-20" → "20/04/2024"
      try {
        final parts = dateStr.split('-');
        dateStr = '${parts[2]}/${parts[1]}/${parts[0]}';
      } catch (_) {}
    }

    final int waterCount = data['waterCount'] ?? 0;
    final int expectedWater = data['expectedWater'] ?? 0;
    final String plantStatus = data['plantStatus'] ?? '';
    final String weather = data['weather'] ?? '';
    final bool fertilized = data['fertilized'] ?? false;
    final String fertNote = data['fertilizerNote'] ?? '';
    final bool pesticide = data['pesticide'] ?? false;
    final String pestNote = data['pesticideNote'] ?? '';
    final String notes = data['notes'] ?? '';
    // Legacy field
    final String voiceNote = data['voiceNote'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ngày + thời tiết
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(dateStr,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              ),
              if (weather.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(weather,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Tưới nước
          _buildLogRow(
            Icons.water_drop,
            'Tưới nước',
            expectedWater > 0
                ? '$waterCount/$expectedWater lần'
                : '$waterCount lần',
            waterCount >= expectedWater && expectedWater > 0
                ? Colors.blue
                : AppColors.textSecondary,
          ),

          // Tình trạng cây
          if (plantStatus.isNotEmpty)
            _buildLogRow(Icons.eco, 'Tình trạng cây', plantStatus, AppColors.primaryGreen),

          // Phân bón
          if (fertilized)
            _buildLogRow(
              Icons.grass,
              'Bón phân',
              fertNote.isNotEmpty ? fertNote : 'Đã bón',
              Colors.brown.shade600,
            ),

          // Thuốc BVTV
          if (pesticide)
            _buildLogRow(
              Icons.shield_outlined,
              'Thuốc BVTV',
              pestNote.isNotEmpty ? pestNote : 'Đã phun',
              Colors.orange.shade700,
            ),

          // Ghi chú / voiceNote
          if (notes.isNotEmpty || voiceNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                notes.isNotEmpty ? notes : voiceNote,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text('$label: ',
              style: GoogleFonts.beVietnamPro(
                  fontSize: 13, color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, String value, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
            Text(value,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String projectId, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Xóa dự án?',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        content: Text('Bạn có chắc muốn xóa dự án "$name"? Hành động này không thể hoàn tác.',
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await FirestoreService().deleteProject(projectId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa dự án "$name"',
                        style: GoogleFonts.beVietnamPro(fontSize: 14)),
                    backgroundColor: AppColors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Xóa',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.redAccent)),
          ),
        ],
      ),
    );
  }
}
