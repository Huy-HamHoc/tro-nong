import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _nameController = TextEditingController();
  final _cropController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _areaController = TextEditingController();
  final _waterController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedSoilType = '';
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _soilTypes = [
    'Đất phù sa',
    'Đất phèn',
    'Đất cát',
    'Đất đỏ bazan',
    'Đất mùn',
    'Đất sét',
    'Khác',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _cropController.dispose();
    _startController.dispose();
    _endController.dispose();
    _areaController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startController.text = formatted;
        } else {
          _endDate = picked;
          _endController.text = formatted;
        }
      });
    }
  }

  void _showSoilTypePicker() {
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
                child: Text('Chọn loại đất',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              ..._soilTypes.map((type) => ListTile(
                    title: Text(type,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          color: _selectedSoilType == type
                              ? AppColors.primaryGreen
                              : AppColors.textPrimary,
                          fontWeight:
                              _selectedSoilType == type ? FontWeight.w700 : FontWeight.w400,
                        )),
                    trailing: _selectedSoilType == type
                        ? const Icon(Icons.check, color: AppColors.primaryGreen)
                        : null,
                    onTap: () {
                      setState(() => _selectedSoilType = type);
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final crop = _cropController.text.trim();
    final area = double.tryParse(_areaController.text.trim());
    final waterPerDay = int.tryParse(_waterController.text.trim());
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Validation
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên dự án');
      return;
    }
    if (crop.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên giống cây');
      return;
    }
    if (_startDate == null) {
      setState(() => _errorMessage = 'Vui lòng chọn ngày bắt đầu');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirestoreService().addProject({
        'farmerId': uid,
        'projectName': name,
        'cropType': crop,
        'startDate': Timestamp.fromDate(_startDate!),
        'endDate': _endDate != null ? Timestamp.fromDate(_endDate!) : null,
        'soilType': _selectedSoilType,
        'area': area ?? 0,
        'waterPerDay': waterPerDay ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🌱 Đã tạo dự án "$name" thành công!',
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
      setState(() => _errorMessage = 'Lỗi lưu dự án: $e');
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
        title: Text('Thêm dự án mới',
            style: GoogleFonts.beVietnamPro(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Thông tin dự án',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
            const SizedBox(height: 4),
            Text('Vui lòng điền chi tiết để bắt đầu mùa vụ mới.',
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
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

            _buildLabel('Tên dự án'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Ví dụ: Trồng Lúa Vụ Đông Xuân'),
            ),
            const SizedBox(height: 18),
            _buildLabel('Tên giống cây'),
            const SizedBox(height: 8),
            TextField(
              controller: _cropController,
              decoration: const InputDecoration(hintText: 'Ví dụ: Lúa ST25'),
            ),
            const SizedBox(height: 18),

            // Ngày bắt đầu
            _buildLabel('Ngày bắt đầu'),
            const SizedBox(height: 8),
            TextField(
              controller: _startController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Chọn ngày bắt đầu',
                prefixIcon: Icon(Icons.calendar_today_outlined,
                    color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
              ),
              onTap: () => _pickDate(true),
            ),
            const SizedBox(height: 18),

            // Ngày kết thúc
            _buildLabel('Ngày kết thúc (dự kiến)'),
            const SizedBox(height: 8),
            TextField(
              controller: _endController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Chọn ngày kết thúc',
                prefixIcon: Icon(Icons.calendar_today_outlined,
                    color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
              ),
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: 18),

            // Loại đất
            _buildLabel('Loại đất canh tác'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showSoilTypePicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.terrain_outlined,
                        color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedSoilType.isEmpty ? 'Chọn loại đất...' : _selectedSoilType,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: _selectedSoilType.isEmpty
                              ? AppColors.textLight
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Diện tích
            _buildLabel('Diện tích canh tác'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _areaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Nhập diện tích',
                      prefixIcon: Icon(Icons.crop_square_outlined,
                          color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text('m²',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Số lần tưới
            _buildLabel('Số lần tưới / ngày'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _waterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Số lần',
                      prefixIcon: Icon(Icons.water_drop_outlined,
                          color: AppColors.textSecondary.withValues(alpha: 0.5), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text('lần',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text('Lưu dự án',
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

  static Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.beVietnamPro(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
