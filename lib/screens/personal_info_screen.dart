import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _roleController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data() ?? {};
    _nameController.text = data['fullName'] ?? user.displayName ?? '';
    _phoneController.text = data['phoneNumber'] ?? '';
    _addressController.text = data['address'] ?? '';
    _roleController.text = data['role'] ?? '';

    // Theo dõi thay đổi
    _nameController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
    _addressController.addListener(_onChanged);
    _roleController.addListener(_onChanged);

    if (mounted) setState(() => _isLoading = false);
  }

  void _onChanged() {
    if (!_hasChanges && mounted) setState(() => _hasChanges = true);
  }

  Future<void> _handleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final address = _addressController.text.trim();
      final role = _roleController.text.trim();

      // Cập nhật Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': name,
        'phoneNumber': phone,
        'address': address,
        'role': role,
      });

      // Cập nhật displayName trên Firebase Auth
      if (name != user.displayName) {
        await user.updateDisplayName(name);
      }

      if (mounted) {
        setState(() => _hasChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã lưu thông tin thành công!',
                style: GoogleFonts.beVietnamPro(fontSize: 14)),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e', style: GoogleFonts.beVietnamPro(fontSize: 14)),
            backgroundColor: AppColors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Thông tin cá nhân',
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                        child: const Icon(Icons.person, size: 48, color: AppColors.primaryGreen),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: AppColors.white, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Họ và tên
                  _buildField(
                    label: 'Họ và tên',
                    controller: _nameController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 18),

                  // Số điện thoại
                  _buildField(
                    label: 'Số điện thoại',
                    controller: _phoneController,
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    hint: 'Không thể thay đổi',
                  ),
                  const SizedBox(height: 18),

                  // Địa chỉ
                  _buildField(
                    label: 'Địa chỉ',
                    controller: _addressController,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 18),

                  // Vai trò
                  _buildField(
                    label: 'Vai trò / Chức danh',
                    controller: _roleController,
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 12),

                  // Thông tin tài khoản (không chỉnh sửa)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Thông tin tài khoản',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.fingerprint, size: 18, color: AppColors.textLight),
                            const SizedBox(width: 8),
                            Text('UID: ',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 13, color: AppColors.textSecondary)),
                            Expanded(
                              child: Text(
                                FirebaseAuth.instance.currentUser?.uid ?? '',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 12, color: AppColors.textLight),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 18, color: AppColors.textLight),
                            const SizedBox(width: 8),
                            Text('Email: ',
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 13, color: AppColors.textSecondary)),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ?? '',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Đổi mật khẩu
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/change-password'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: AppColors.primaryGreen, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Đổi mật khẩu',
                                    style: GoogleFonts.beVietnamPro(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary)),
                                Text('Thay đổi mật khẩu để an toàn hơn',
                                    style: GoogleFonts.beVietnamPro(
                                        fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nút lưu
                  if (_hasChanges)
                    ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save_outlined, size: 20),
                                const SizedBox(width: 8),
                                Text('Lưu thay đổi',
                                    style: GoogleFonts.beVietnamPro(
                                        fontSize: 16, fontWeight: FontWeight.w700)),
                              ],
                            ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.beVietnamPro(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon,
                color: readOnly
                    ? AppColors.textLight
                    : AppColors.primaryGreen.withValues(alpha: 0.5),
                size: 22),
            filled: true,
            fillColor: readOnly ? AppColors.inputBg.withValues(alpha: 0.5) : null,
          ),
        ),
      ],
    );
  }
}
