import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  String? _selectedProjectId;
  String? _selectedProjectName;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _showProjectPicker() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final snap = await FirebaseFirestore.instance
        .collection('projects')
        .where('farmerId', isEqualTo: uid)
        .get();

    if (!mounted) return;

    if (snap.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn chưa có dự án nào. Hãy tạo dự án trước!',
              style: GoogleFonts.beVietnamPro(fontSize: 14)),
          backgroundColor: AppColors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Chọn dự án liên kết',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              ...snap.docs.map((doc) {
                final data = doc.data();
                final name = data['projectName'] ?? 'Dự án';
                final crop = data['cropType'] ?? '';
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.primaryGreen, size: 22),
                  ),
                  title: Text(name,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        fontWeight: _selectedProjectId == doc.id
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: _selectedProjectId == doc.id
                            ? AppColors.primaryGreen
                            : AppColors.textPrimary,
                      )),
                  subtitle: crop.isNotEmpty
                      ? Text(crop,
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 13, color: AppColors.textSecondary))
                      : null,
                  trailing: _selectedProjectId == doc.id
                      ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedProjectId = doc.id;
                      _selectedProjectName = name;
                      // Tự điền tên sản phẩm từ giống cây
                      if (_nameController.text.isEmpty && crop.isNotEmpty) {
                        _nameController.text = crop;
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _copyQuantityToStock() {
    _stockController.text = _quantityController.text;
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim());
    final price = int.tryParse(_priceController.text.trim().replaceAll('.', ''));
    final stock = int.tryParse(_stockController.text.trim());
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Validation
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên sản phẩm');
      return;
    }
    if (quantity == null || quantity <= 0) {
      setState(() => _errorMessage = 'Vui lòng nhập sản lượng hợp lệ');
      return;
    }
    if (price == null || price <= 0) {
      setState(() => _errorMessage = 'Vui lòng nhập giá bán hợp lệ');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirestoreService().addListing({
        'farmerId': uid,
        'productName': name,
        'quantity': quantity,
        'price': price,
        'inStock': stock ?? quantity,
        'projectId': _selectedProjectId ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🛒 Đã đăng bán "$name" thành công!',
                style: GoogleFonts.beVietnamPro(fontSize: 14)),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Lỗi đăng bán: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        centerTitle: true,
        title: Text('Thêm Sản Phẩm',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Error message
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.redAccent)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ─── Chọn dự án ─────────────────────────────────────
            Text('Chọn dự án',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showProjectPicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedProjectId != null
                        ? AppColors.primaryGreen.withValues(alpha: 0.5)
                        : AppColors.divider,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedProjectId != null ? Icons.eco : Icons.folder_outlined,
                      color: _selectedProjectId != null
                          ? AppColors.primaryGreen
                          : AppColors.textLight,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedProjectName ?? 'Chọn từ danh sách dự án...',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          color: _selectedProjectId != null
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                          fontWeight: _selectedProjectId != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text('Chọn dự án để tự động liên kết nguồn gốc.',
                style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.primaryGreen)),
            const SizedBox(height: 24),

            // ─── Tên sản phẩm ────────────────────────────────────
            Text('Tên sản phẩm',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Ví dụ: Lúa ST25'),
            ),
            const SizedBox(height: 24),

            // ─── Sản lượng ───────────────────────────────────────
            Text('Sản lượng dự kiến bán',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Ví dụ: 100'),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('kg',
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Giá bán ──────────────────────────────────────────
            Text('Giá bán',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ví dụ: 15000',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VND/kg',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Tồn kho ─────────────────────────────────────────
            Text('Số lượng có sẵn trong kho',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Số lượng thực tế'),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _copyQuantityToStock,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('như\ntrên',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // ─── Nút đăng bán ─────────────────────────────────────
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text('Đăng bán ngay',
                      style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text('Sản phẩm sẽ được hiển thị ngay trên Cửa hàng.',
                  style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
