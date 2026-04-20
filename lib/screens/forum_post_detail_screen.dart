import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class ForumPostDetailScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> data;
  const ForumPostDetailScreen({super.key, required this.postId, required this.data});

  @override
  State<ForumPostDetailScreen> createState() => _ForumPostDetailScreenState();
}

class _ForumPostDetailScreenState extends State<ForumPostDetailScreen> {
  final _commentController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    // Lấy tên từ Firestore
    String authorName = user?.displayName ?? 'Ẩn danh';
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      authorName = doc.data()?['fullName'] ?? authorName;
    } catch (_) {}

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance
          .collection('forum_posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'authorId': uid,
        'authorName': authorName,
        'content': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tăng commentsCount
      await FirebaseFirestore.instance
          .collection('forum_posts')
          .doc(widget.postId)
          .update({'commentsCount': FieldValue.increment(1)});

      _commentController.clear();
    } catch (_) {}

    if (mounted) setState(() => _isSending = false);
  }

  String _timeAgo(dynamic ts) {
    if (ts == null) return '';
    try {
      final date = (ts as Timestamp).toDate();
      final diff = DateTime.now().difference(date);
      if (diff.isNegative || diff.inMinutes < 1) return 'vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      return '${diff.inDays} ngày trước';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final String authorName = data['authorName'] ?? 'Ẩn danh';
    final String title = data['title'] ?? '';
    final String content = data['content'] ?? '';
    final int likes = data['likes'] ?? 0;
    final String timeAgo = _timeAgo(data['timestamp']);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Bài viết',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Author ───────────────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                        child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authorName,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen)),
                          if (timeAgo.isNotEmpty)
                            Text(timeAgo,
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ─── Title ────────────────────────────────────
                  Text(title,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.3)),
                  const SizedBox(height: 12),

                  // ─── Content ──────────────────────────────────
                  Text(content,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 15, color: AppColors.textSecondary, height: 1.7)),
                  const SizedBox(height: 16),

                  // ─── Like button ──────────────────────────────
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => FirestoreService().likePost(widget.postId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up_outlined,
                                  size: 18, color: AppColors.primaryGreen),
                              const SizedBox(width: 6),
                              Text('$likes Thích',
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryGreen)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // ─── Comments header ──────────────────────────
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 18, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Text('Bình luận',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ─── Comments stream ──────────────────────────
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forum_posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy('createdAt', descending: false)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                color: AppColors.primaryGreen, strokeWidth: 2),
                          ),
                        );
                      }
                      final comments = snap.data?.docs ?? [];
                      if (comments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text('Chưa có bình luận nào. Hãy là người đầu tiên!',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 13, color: AppColors.textSecondary)),
                          ),
                        );
                      }
                      return Column(
                        children: comments.map((c) {
                          final cd = c.data() as Map<String, dynamic>;
                          return _buildComment(cd);
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ─── Comment input ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Viết bình luận...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _isSending ? null : _sendComment,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
            child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
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
                      Text(data['authorName'] ?? 'Ẩn danh',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen)),
                      Text(_timeAgo(data['createdAt']),
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(data['content'] ?? '',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
