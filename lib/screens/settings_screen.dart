import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 0.7;
  double _volume = 0.5;
  bool _voiceAssistant = true;
  bool _farmNotifications = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() ?? {};
    final settings = data['settings'] as Map<String, dynamic>? ?? {};

    setState(() {
      _voiceAssistant = settings['voiceAssistant'] ?? true;
      _farmNotifications = settings['notifications'] ?? true;
      _fontSize = (settings['fontSize'] as num?)?.toDouble() ?? 0.7;
      _volume = (settings['volume'] as num?)?.toDouble() ?? 0.5;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirestoreService().updateUserSettings(uid, {
      'voiceAssistant': _voiceAssistant,
      'notifications': _farmNotifications,
      'fontSize': _fontSize,
      'volume': _volume,
      'textSize': _fontSize > 0.7 ? 'Rất lớn' : _fontSize > 0.4 ? 'Lớn' : 'Bình thường',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () {
            _saveSettings();
            Navigator.pop(context);
          },
        ),
        title: Text('Cài đặt tiện ích',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Display settings
                  _buildCard(
                    title: '👁 Cài đặt hiển thị',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cỡ chữ (${_fontSize > 0.7 ? 'Rất lớn' : _fontSize > 0.4 ? 'Lớn' : 'Bình thường'})',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('A',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 14, color: AppColors.textSecondary)),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                  activeTrackColor: AppColors.primaryGreen,
                                  inactiveTrackColor: AppColors.inputBg,
                                  thumbColor: AppColors.primaryGreen,
                                  trackHeight: 6,
                                ),
                                child: Slider(
                                  value: _fontSize,
                                  onChanged: (v) => setState(() => _fontSize = v),
                                ),
                              ),
                            ),
                            Text('A',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Kéo nút sang phải để chữ to hơn, giúp bạn đọc tin tức dễ dàng.',
                            style:
                                GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Volume
                  _buildCard(
                    title: '🔊 Âm lượng',
                    child: Row(
                      children: [
                        const Icon(Icons.volume_mute, color: AppColors.textSecondary, size: 20),
                        Expanded(
                          child: SliderTheme(
                            data: const SliderThemeData(
                              activeTrackColor: AppColors.primaryGreen,
                              inactiveTrackColor: AppColors.inputBg,
                              thumbColor: AppColors.primaryGreen,
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: _volume,
                              onChanged: (v) => setState(() => _volume = v),
                            ),
                          ),
                        ),
                        const Icon(Icons.volume_up, color: AppColors.textSecondary, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Voice assistant
                  _buildCard(
                    title: '🎤 Trợ lý giọng nói',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khi bật, ứng dụng sẽ đọc to các thông báo và hướng dẫn cho bạn.',
                          style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Trạng thái: ${_voiceAssistant ? 'Bật' : 'Tắt'}',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                            const Spacer(),
                            Switch(
                              value: _voiceAssistant,
                              onChanged: (v) => setState(() => _voiceAssistant = v),
                              activeThumbColor: AppColors.white,
                              activeTrackColor: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Farm notifications
                  _buildCard(
                    title: '🌾 Thông báo nông nghiệp',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khi bật, ứng dụng sẽ gửi lời nhắc đến điện thoại để bạn không quên những việc quan trọng!',
                          style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Trạng thái: ${_farmNotifications ? 'Bật' : 'Tắt'}',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                            const Spacer(),
                            Switch(
                              value: _farmNotifications,
                              onChanged: (v) => setState(() => _farmNotifications = v),
                              activeThumbColor: AppColors.white,
                              activeTrackColor: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Support button
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.headset_mic_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text('Liên hệ hỗ trợ kỹ thuật',
                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Phiên bản ứng dụng: 2.4.0',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
