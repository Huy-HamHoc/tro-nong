import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ForumScreen extends StatelessWidget {
  final Widget? drawer;
  const ForumScreen({super.key, this.drawer});

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
        title: Text('Diễn đàn Nông dân',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textLight, size: 20),
                  const SizedBox(width: 10),
                  Text('Tìm kiếm bài viết...',
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textLight)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Post 1
            _buildForumPost(
              context,
              authorName: 'Trợ Nông Admin',
              timeAgo: '2 giờ trước',
              title: 'Kinh nghiệm trồng rau muống mùa mưa - tránh úng rễ',
              content:
                  'Chào bà con, vào mùa mưa lớn, rau muống rất dễ bị úng rễ và vàng lá. Để khắc phục, bà con nên lên liếp cao ít nhất 20cm và đảm bảo rãnh thoát nước thông thoáng. Hạn chế bón phân đạm khi trời mưa liên tục...',
              likes: 125,
              comments: 24,
              views: '1.2k',
              hasImages: true,
            ),
            const SizedBox(height: 16),
            // Post 2
            _buildForumPost(
              context,
              authorName: 'Trợ Nông Admin',
              timeAgo: 'Hôm qua',
              title: 'Thảo luận: Bà con có mẹo gì trị rầy nâu hại lúa không ạ?',
              content:
                  'Gần đây nhiều khu vực báo cáo tình trạng rầy nâu xuất hiện sớm trên lúa vụ mới. Bà con thường dùng cách dân gian hay loại thuốc sinh học nào hiệu quả, an toàn xin chia sẻ cùng mọi người nhé!',
              likes: 89,
              comments: 45,
              views: '850',
              hasImages: false,
              featuredComment: _buildFeaturedComment(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildForumPost(
    BuildContext context, {
    required String authorName,
    required String timeAgo,
    required String title,
    required String content,
    required int likes,
    required int comments,
    required String views,
    bool hasImages = false,
    Widget? featuredComment,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorName,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(timeAgo,
                          style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Title
          Text(title,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          // Content
          Text(content,
              style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
          if (hasImages) ...[
            const SizedBox(height: 12),
            // Image placeholders
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildImagePlaceholder(Colors.green.shade700),
                  const SizedBox(width: 8),
                  _buildImagePlaceholder(Colors.green.shade500),
                ],
              ),
            ),
          ],
          if (featuredComment != null) ...[
            const SizedBox(height: 12),
            featuredComment,
          ],
          const SizedBox(height: 14),
          // Engagement
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('$likes', style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(width: 20),
              Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('$comments',
                  style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(width: 20),
              Icon(Icons.remove_red_eye_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(views, style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(Color color) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image, size: 40, color: color.withValues(alpha: 0.5)),
    );
  }

  Widget _buildFeaturedComment() {
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
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text('Bác Tư (Long An)',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '"Bác thử dùng hỗn hợp gừng, tỏi, ớt ngâm rượu pha loãng phun đều ruộng lúc chiều mát. Cách này nhà tui làm mấy năm nay rầy đỡ hẳn mà lúa vẫn sạch..."',
            style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
