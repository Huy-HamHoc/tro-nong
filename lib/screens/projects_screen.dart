import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class ProjectsScreen extends StatelessWidget {
  final Widget? drawer;
  const ProjectsScreen({super.key, this.drawer});

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
        title: Text('Dự án',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
              child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 20),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getProjects(_farmerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi: ${snapshot.error}',
                  style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Dự án đang thực hiện',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 12),

                // Projects from Firestore
                if (docs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.eco_outlined, size: 48, color: AppColors.textLight),
                          const SizedBox(height: 8),
                          Text('Chưa có dự án nào',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 15, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),

                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String projectName = data['projectName'] ?? 'Dự án';
                  final String cropType = data['cropType'] ?? '';
                  final startDate = data['startDate'];
                  String subtitle = cropType;
                  if (startDate != null) {
                    try {
                      final dt = (startDate as Timestamp).toDate();
                      final daysSince = DateTime.now().difference(dt).inDays;
                      subtitle = 'Đã trồng $daysSince ngày';
                    } catch (_) {}
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildProjectCard(
                      context,
                      icon: Icons.eco,
                      iconBgColor: AppColors.primaryGreen,
                      title: projectName,
                      subtitle: subtitle,
                      onTap: () => Navigator.pushNamed(context, '/project-detail',
                          arguments: {'projectId': doc.id, 'data': data}),
                    ),
                  );
                }),

                // Add new project button
                _buildProjectCard(
                  context,
                  icon: Icons.add_circle_outline,
                  iconBgColor: AppColors.redAccent,
                  title: 'Thêm dự án mới',
                  subtitle: '',
                  onTap: () => Navigator.pushNamed(context, '/add-project'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context,
      {required IconData icon,
      required Color iconBgColor,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
