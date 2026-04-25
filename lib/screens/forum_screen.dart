import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import 'forum_post_detail_screen.dart';

class ForumScreen extends StatefulWidget {
  final Widget? drawer;
  const ForumScreen({super.key, this.drawer});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String _searchQuery = '';

  /// Seed bài viết mẫu vào Firestore (chỉ chạy 1 lần)
  Future<void> _seedSamplePosts(BuildContext context) async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'demo';

    final posts = [
      {
        'authorId': 'farmer_ag01',
        'authorName': 'Trần Văn Bình',
        'title': 'Kinh nghiệm trồng lúa ST25 mùa khô – tránh rầy nâu hiệu quả',
        'content':
            'Năm nay tôi canh tác 3 ha lúa ST25 ở vùng An Giang, vụ Đông Xuân 2024. Qua thực tế theo dõi, rầy nâu xuất hiện nhiều nhất vào tuần thứ 5-6 sau sạ. Tôi áp dụng phương pháp "1 phải 5 giảm": sử dụng giống xác nhận, giảm lượng giống gieo, giảm phân đạm, giảm thuốc trừ sâu, giảm nước tưới và giảm thất thoát sau thu hoạch.\n\nKết quả sau 105 ngày: năng suất đạt 7.2 tấn/ha, chất lượng gạo tốt, chi phí sản xuất giảm 18% so với vụ trước. Đặc biệt, nhờ theo dõi bẫy đèn 3 ngày/lần nên phát hiện sớm và xử lý kịp thời.',
        'likes': 34,
        'commentsCount': 3,
        'tags': ['lúa ST25', 'rầy nâu', 'An Giang'],
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 3))),
      },
      {
        'authorId': 'farmer_ag02',
        'authorName': 'Nguyễn Thị Lan',
        'title': 'Hỏi bà con: Lúa 30 ngày tuổi bị vàng lá – nguyên nhân là gì?',
        'content':
            'Ruộng lúa OM5451 nhà tôi hiện đang 30 ngày sau sạ, gần đây xuất hiện hiện tượng vàng lá từ dưới lên, lá già vàng trước, sau đó lan lên lá trên. Tôi đã bón đủ 3 đợt phân NPK theo lịch khuyến nông rồi.\n\nKiểm tra thì thấy không có rầy hay sâu cuốn lá. Nước trong ruộng bình thường. Bà con có ai gặp tình trạng tương tự không? Có phải thiếu lưu huỳnh (S) không? Tôi đang phân vân có nên bón thêm phân vi lượng không.',
        'likes': 21,
        'commentsCount': 4,
        'tags': ['lúa OM5451', 'vàng lá', 'cần tư vấn'],
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8))),
      },
      {
        'authorId': 'farmer_ag03',
        'authorName': 'Lê Thanh Sơn',
        'title': 'Chia sẻ: Mô hình tôm-lúa kết hợp, lợi nhuận tăng gấp đôi',
        'content':
            'Sau 2 năm chuyển từ canh tác lúa thuần sang mô hình tôm-lúa xen canh, tôi xin chia sẻ kết quả thực tế:\n\n🦐 Vụ tôm (6 tháng mùa khô): thả 120.000 con post/ha, thu hoạch ~600kg tôm thẻ chân trắng. Giá bán 120.000đ/kg → doanh thu ~72 triệu/ha.\n\n🌾 Vụ lúa (mùa mưa): trồng giống Một Bụi Đỏ, năng suất 4.5 tấn/ha. Đất được cải tạo từ chất thải tôm nên ít cần phân hóa học.\n\nTổng lợi nhuận tăng ~220% so với chỉ trồng lúa. Ai muốn tìm hiểu thêm cứ hỏi, tôi sẵn sàng chia sẻ kỹ thuật.',
        'likes': 58,
        'commentsCount': 6,
        'tags': ['tôm-lúa', 'mô hình kết hợp', 'lợi nhuận'],
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'authorId': 'farmer_ag04',
        'authorName': 'Phạm Văn Đức',
        'title': 'Cảnh báo: Bệnh đạo ôn lá đang bùng phát mạnh ở An Giang',
        'content':
            'Bà con chú ý! Vừa qua kiểm tra đồng ruộng tại khu vực Châu Phú, tôi phát hiện bệnh đạo ôn lá đang lây lan rất nhanh, đặc biệt trên các ruộng lúa giai đoạn 20-35 ngày.\n\nDấu hiệu nhận biết: vết bệnh hình thoi, viền nâu, tâm xám trắng. Lá non bị nhiễm sẽ héo khô trong 2-3 ngày nếu không xử lý kịp.\n\n⚡ Biện pháp khẩn cấp:\n- Ngừng bón đạm ngay\n- Phun thuốc Beam 75WP hoặc Filia 525SE\n- Giữ nước trong ruộng 3-5cm\n- Phun lúc sáng sớm hoặc chiều mát\n\nĐừng chủ quan bà con ơi!',
        'likes': 47,
        'commentsCount': 5,
        'tags': ['đạo ôn', 'cảnh báo', 'An Giang'],
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
      },
      {
        'authorId': uid,
        'authorName': 'Nguyễn Hữu Nghĩa',
        'title': 'Cập nhật dự án Lúa ST25 vụ Hè Thu – ngày thứ 45',
        'content':
            'Báo cáo tiến độ dự án "Trồng Lúa ST25 Vụ Hè Thu" của tôi:\n\n📅 Ngày 45 sau sạ: lúa đang trong giai đoạn làm đòng, chiều cao cây trung bình 85cm, màu sắc lá xanh đậm, mật độ chồi tốt khoảng 350 chồi/m².\n\n💧 Chế độ tưới: 2 lần/ngày, duy trì mực nước 3cm. Đã rút nước để lúa cứng cây trước khi vào giai đoạn trỗ.\n\n🌿 Phân bón đợt 3: bón 60kg urê + 30kg kali/ha theo khuyến cáo.\n\nDự kiến thu hoạch sau 60 ngày nữa, kỳ vọng đạt 6.5-7 tấn/ha. Bà con cùng dự đoán xem!',
        'likes': 12,
        'commentsCount': 2,
        'tags': ['nhật ký', 'lúa ST25', 'Hè Thu'],
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1))),
      },
    ];

    // Sample comments cho mỗi bài
    final sampleComments = {
      0: [ // Bài lúa ST25 rầy nâu
        {'authorName': 'Nguyễn Minh Tuấn', 'content': 'Cảm ơn bác Bình! Tôi đang canh tác gần đây cũng áp dụng 1 phải 5 giảm nhưng chưa đạt được kết quả cao như vậy. Bác có thể chia sẻ thêm về lịch bón phân không?', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2, minutes: 30)))},
        {'authorName': 'Lê Thị Mai', 'content': 'Năng suất 7.2 tấn/ha nghe hấp dẫn quá! Giống ST25 giờ có mua ở đâu bác ơi? Nguồn giống xác nhận khó kiếm lắm.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2)))},
        {'authorName': 'Phạm Văn Hùng', 'content': 'Bẫy đèn theo dõi rầy 3 ngày/lần là cách làm rất hay. Tôi hay bỏ qua bước này nên không phát hiện kịp. Học được nhiều từ bài này.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1)))},
      ],
      1: [ // Bài vàng lá
        {'authorName': 'Trần Văn Bình', 'content': 'Chị Lan ơi, triệu chứng này có vẻ giống thiếu lưu huỳnh (S) hoặc kẽm (Zn) hơn. Chị thử bón 10-15kg lưu huỳnh bột/ha xem sao. Đất An Giang hay thiếu S lắm.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 6)))},
        {'authorName': 'Cán bộ KN Vĩnh Phú', 'content': 'Ngoài thiếu S còn có thể do ngộ độc hữu cơ nếu đất vừa vùi rơm rạ. Chị kiểm tra màu nước trong ruộng, nếu đen và có mùi thối thì cần tháo nước ngay.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5)))},
        {'authorName': 'Nguyễn Thành Long', 'content': 'Tôi từng gặp y chang! Nguyên nhân là do pH đất thấp khiến cây không hấp thụ được dinh dưỡng. Bón vôi 500kg/ha trước vụ là giải quyết được.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 4)))},
        {'authorName': 'Lê Thanh Sơn', 'content': 'Theo tôi nên lấy mẫu đất gửi đến trung tâm khuyến nông tỉnh phân tích là chắc nhất chị ạ. Phán đoán không chắc bằng kết quả xét nghiệm.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 3)))},
      ],
      2: [ // Bài tôm-lúa
        {'authorName': 'Nguyễn Văn Phú', 'content': 'Anh Sơn ơi, mật độ thả 120.000 con/ha có cao không? Tôi hay thả 80.000 thôi vì sợ thiếu oxy. Ao anh có sục khí không?', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 20)))},
        {'authorName': 'Trần Thị Hoa', 'content': 'Mô hình tuyệt vời! Vùng nhà tôi đang vận động bà con chuyển sang mô hình này. Anh có thể cho tôi xin số điện thoại để liên hệ tham quan không?', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 18)))},
        {'authorName': 'Lê Thanh Sơn', 'content': 'Anh Phú ơi, tôi có 6 máy sục khí, mật độ này ổn nếu quản lý tốt. Chị Hoa cứ nhắn tin qua đây, tôi sẵn sàng chia sẻ!', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 15)))},
        {'authorName': 'Nguyễn Minh Đạt', 'content': 'Chi phí ban đầu đầu tư ao tôm có cao không anh? Tôi đang tính chuyển nhưng chưa biết vốn thế nào.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 10)))},
        {'authorName': 'Phạm Văn Đức', 'content': 'Mô hình hay đấy nhưng phải cẩn thận dịch bệnh tôm. Năm 2022 bà con ở Cà Mau mất trắng vì EHP. Cần mua tôm giống uy tín.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8)))},
        {'authorName': 'Lê Thanh Sơn', 'content': 'Bác Đức nói đúng! Tôi luôn mua post tại trại giống có kiểm dịch. Không ham rẻ. Giống rẻ mà không sạch là mất cả vốn lẫn lời.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5)))},
      ],
      3: [ // Bài đạo ôn
        {'authorName': 'Nguyễn Thị Lan', 'content': 'Cảm ơn bác báo tin kịp thời! Ruộng nhà tôi cũng gần đó. Bác ơi, Filia có phải pha thêm dầu khoáng không?', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 18)))},
        {'authorName': 'Cán bộ BVTV An Giang', 'content': 'Bà con chú ý thêm: nếu bệnh đã nặng hơn 25% diện tích lá thì cần phun lần 2 sau 5-7 ngày. Liều lượng theo hướng dẫn trên bao bì, không tự ý tăng liều.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 15)))},
        {'authorName': 'Trần Minh Khoa', 'content': 'Beam 75WP hiện tại thị trường đang khan hàng bác ơi. Thay thế bằng Kasai 21.2WP được không?', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 10)))},
        {'authorName': 'Phạm Văn Đức', 'content': 'Kasai dùng được nhưng hiệu quả hơi chậm hơn. Nếu không có Beam thì bà con dùng Tricyclazole 75WP cũng cho kết quả tốt.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 8)))},
        {'authorName': 'Nguyễn Văn Tám', 'content': 'Cảm ơn bác! Tôi vừa đi thăm đồng về, ruộng nhà cũng thấy vài vết nghi ngờ rồi. Sáng mai ra phun ngay.', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 3)))},
      ],
      4: [ // Bài nhật ký ST25
        {'authorName': 'Trần Văn Bình', 'content': 'Theo dõi thấy dự án của bạn tiến triển tốt đó! 350 chồi/m² là mật độ lý tưởng. Nhớ theo dõi chuột phá lúa vào giai đoạn trỗ nhé!', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 45)))},
        {'authorName': 'Nguyễn Thị Lan', 'content': 'Tôi đoán 7 tấn/ha! Chúc dự án thành công bạn nhé 🌾', 'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 20)))},
      ],
    };

    final batch = db.batch();

    for (int i = 0; i < posts.length; i++) {
      final postRef = db.collection('forum_posts').doc();
      batch.set(postRef, posts[i]);

      // Thêm comments
      final comments = sampleComments[i] ?? [];
      for (final comment in comments) {
        final commentRef = postRef.collection('comments').doc();
        batch.set(commentRef, comment);
      }
    }

    await batch.commit();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã thêm ${posts.length} bài viết mẫu!',
              style: GoogleFonts.beVietnamPro(fontSize: 14)),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Diễn đàn Nông dân',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
        actions: [
          // Nút seed dữ liệu mẫu (xoá sau khi có đủ data thật)
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.primaryGreen),
            tooltip: 'Thêm bài viết mẫu',
            onPressed: () => _seedSamplePosts(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm bài viết, tác giả, hashtag...',
                hintStyle: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textLight),
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight, size: 20),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 12),

          // Posts list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().getForumPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGreen),
                  );
                }
                final allDocs = snapshot.data?.docs ?? [];
                final docs = allDocs.where((doc) {
                  if (_searchQuery.isEmpty) return true;
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data['title'] ?? '').toString().toLowerCase();
                  final content = (data['content'] ?? '').toString().toLowerCase();
                  final author = (data['authorName'] ?? '').toString().toLowerCase();
                  final tags = (data['tags'] as List<dynamic>?)?.map((e) => e.toString().toLowerCase()).toList() ?? [];

                  if (title.contains(_searchQuery)) return true;
                  if (content.contains(_searchQuery)) return true;
                  if (author.contains(_searchQuery)) return true;
                  for (final tag in tags) {
                    if (tag.contains(_searchQuery)) return true;
                  }
                  return false;
                }).toList();

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 64, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text('Chưa có bài đăng nào',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 15, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text('Bấm nút ➕ trên góc phải để thêm bài mẫu',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: AppColors.textLight)),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildForumPost(context, postId: doc.id, data: data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumPost(BuildContext context,
      {required String postId, required Map<String, dynamic> data}) {
    final String authorName = data['authorName'] ?? 'Ẩn danh';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final int likes = data['likes'] ?? 0;
    final int commentsCount = data['commentsCount'] ?? 0;
    final tags = (data['tags'] as List<dynamic>?)?.cast<String>() ?? [];

    String timeAgo = '';
    if (data['timestamp'] != null) {
      final ts = data['timestamp'] as Timestamp;
      final diff = DateTime.now().difference(ts.toDate());
      if (diff.isNegative || diff.inMinutes < 1) {
        timeAgo = 'vừa xong';
      } else if (diff.inMinutes < 60) {
        timeAgo = '${diff.inMinutes} phút trước';
      } else if (diff.inHours < 24) {
        timeAgo = '${diff.inHours} giờ trước';
      } else {
        timeAgo = '${diff.inDays} ngày trước';
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ForumPostDetailScreen(postId: postId, data: data),
          ),
        );
      },
      child: Container(
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
                    if (timeAgo.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(timeAgo,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 12, color: AppColors.textSecondary)),
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
            const SizedBox(height: 6),

            // Content preview
            Text(content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14, color: AppColors.textSecondary, height: 1.5)),

            // Tags
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('#$tag',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 12),

            // Engagement row
            Row(
              children: [
                GestureDetector(
                  onTap: () => FirestoreService().likePost(postId),
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$likes',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('$commentsCount bình luận',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                Text('Đọc thêm →',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
