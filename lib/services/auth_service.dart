import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// User hiện tại (null nếu chưa đăng nhập)
  User? get currentUser => _auth.currentUser;

  /// Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Chuyển số điện thoại → email giả để dùng với Firebase Auth
  String _phoneToEmail(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    return '$cleaned@tronong.app';
  }

  // ─── ĐĂNG KÝ ────────────────────────────────────────────────

  /// Tạo tài khoản mới + lưu hồ sơ vào Firestore
  Future<UserCredential> register({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String password,
  }) async {
    final email = _phoneToEmail(phoneNumber);

    // Tạo tài khoản Firebase Auth
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Cập nhật displayName
    await credential.user!.updateDisplayName(fullName);

    // Lưu hồ sơ vào Firestore collection "users"
    await _db.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': 'Nông dân tiêu biểu tại An Giang',
      'settings': {
        'textSize': 'Bình thường',
        'voiceAssistant': true,
        'notifications': true,
      },
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // ─── ĐĂNG NHẬP ──────────────────────────────────────────────

  /// Đăng nhập bằng số điện thoại + mật khẩu
  Future<UserCredential> login({
    required String phoneNumber,
    required String password,
  }) async {
    final email = _phoneToEmail(phoneNumber);
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ─── ĐĂNG XUẤT ──────────────────────────────────────────────

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ─── ĐỔI MẬT KHẨU ───────────────────────────────────────────

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser!;
    final email = user.email!;

    // Xác thực lại trước khi đổi mật khẩu
    final cred = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  // ─── LẤY HỒ SƠ TỪ FIRESTORE ────────────────────────────────

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;
    final doc = await _db.collection('users').doc(currentUser!.uid).get();
    return doc.exists ? doc.data() : null;
  }
}
